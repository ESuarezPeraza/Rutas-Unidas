import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../models/user.dart' as app_user;
import '../config/supabase_config.dart';

class AuthProvider with ChangeNotifier {
  app_user.User? _currentUser;
  bool _isLoading = false;
  String? _error;
  final Connectivity _connectivity = Connectivity();

  app_user.User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _currentUser != null;

  AuthProvider() {
    _initializeAuth();
  }

  void _initializeAuth() {
    final session = SupabaseConfig.client.auth.currentSession;
    if (session != null) {
      _loadUserProfile(session.user.id);
    }

    SupabaseConfig.client.auth.onAuthStateChange.listen((event) {
      print('DEBUG: Auth state change: ${event.event}');
      final session = event.session;
      if (session != null) {
        print('DEBUG: Session exists, loading profile for user: ${session.user.id}');
        _loadUserProfile(session.user.id);
      } else {
        print('DEBUG: No session, setting currentUser to null');
        _currentUser = null;
        notifyListeners();
      }
    });
  }

  Future<void> _loadUserProfile(String userId) async {
    print('DEBUG: Loading user profile for userId: $userId');

    // Check connectivity before loading profile
    final connectivityResult = await _connectivity.checkConnectivity();
    print('DEBUG: Connectivity status during profile load: $connectivityResult');

    if (connectivityResult == ConnectivityResult.none) {
      _error = 'No hay conexión a internet. No se pudo cargar el perfil.';
      _currentUser = null;
      notifyListeners();
      return;
    }

    try {
      final response = await SupabaseConfig.client
          .from('users')
          .select()
          .eq('id', userId)
          .single();

      print('DEBUG: User profile loaded successfully: ${response['email']}');
      _currentUser = app_user.User.fromJson(response);
      _error = null;
    } catch (e) {
      print('DEBUG: Error loading user profile: $e');
      // Check if it's a network-related error
      if (e.toString().contains('Network is unreachable') ||
          e.toString().contains('Connection refused') ||
          e.toString().contains('Failed host lookup')) {
        _error = 'Error de conexión al cargar perfil. Verifica tu conexión a internet.';
      } else {
        _error = 'Error al cargar el perfil: $e';
      }
      _currentUser = null;
      // Crear perfil básico si no existe
      try {
        final authUser = SupabaseConfig.client.auth.currentUser;
        print('DEBUG: Creating basic profile for authUser: ${authUser?.id}');
        if (authUser != null) {
          await SupabaseConfig.client.from('users').insert({
            'id': authUser.id,
            'email': authUser.email,
            'experience': 0,
            'created_at': DateTime.now().toIso8601String(),
          });
          _currentUser = app_user.User(
            id: authUser.id,
            email: authUser.email ?? '',
            experience: 0,
            createdAt: DateTime.now(),
          );
          print('DEBUG: Basic profile created successfully');
          _error = null;
        }
      } catch (createError) {
        print('DEBUG: Error creating basic profile: $createError');
        if (createError.toString().contains('Network is unreachable') ||
            createError.toString().contains('Connection refused') ||
            createError.toString().contains('Failed host lookup')) {
          _error = 'Error de conexión al crear perfil. Verifica tu conexión a internet.';
        } else {
          _error = 'Error al crear perfil: $createError';
        }
      }
    }
    notifyListeners();
  }

  Future<bool> signUp({
    required String email,
    required String password,
    String? name,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    // Check connectivity before attempting sign up
    final connectivityResult = await _connectivity.checkConnectivity();
    print('DEBUG: Connectivity status: $connectivityResult');

    if (connectivityResult == ConnectivityResult.none) {
      _error = 'No hay conexión a internet. Verifica tu conexión y vuelve a intentar.';
      _isLoading = false;
      notifyListeners();
      return false;
    }

    try {
      final response = await SupabaseConfig.client.auth.signUp(
        email: email,
        password: password,
      );

      if (response.user != null) {
        // Crear perfil de usuario
        await SupabaseConfig.client.from('users').insert({
          'id': response.user!.id,
          'email': email,
          'name': name,
          'experience': 0,
          'created_at': DateTime.now().toIso8601String(),
        });

        _currentUser = app_user.User(
          id: response.user!.id,
          email: email,
          name: name,
          experience: 0,
          createdAt: DateTime.now(),
        );
      }

      _isLoading = false;
      notifyListeners();
      return response.user != null;
    } catch (e) {
      print('DEBUG: Sign up error: $e');
      // Check if it's a network-related error
      if (e.toString().contains('Network is unreachable') ||
          e.toString().contains('Connection refused') ||
          e.toString().contains('Failed host lookup')) {
        _error = 'Error de conexión. Verifica tu conexión a internet e intenta nuevamente.';
      } else {
        _error = 'Error al registrarse: $e';
      }
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> signIn({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    // Check connectivity before attempting sign in
    final connectivityResult = await _connectivity.checkConnectivity();
    print('DEBUG: Connectivity status: $connectivityResult');

    if (connectivityResult == ConnectivityResult.none) {
      _error = 'No hay conexión a internet. Verifica tu conexión y vuelve a intentar.';
      _isLoading = false;
      notifyListeners();
      return false;
    }

    print('DEBUG: Attempting sign in for email: $email');
    try {
      final response = await SupabaseConfig.client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      print('DEBUG: Sign in response user: ${response.user?.id}');
      _isLoading = false;
      notifyListeners();
      return response.user != null;
    } catch (e) {
      print('DEBUG: Sign in error: $e');
      // Check if it's a network-related error
      if (e.toString().contains('Network is unreachable') ||
          e.toString().contains('Connection refused') ||
          e.toString().contains('Failed host lookup')) {
        _error = 'Error de conexión. Verifica tu conexión a internet e intenta nuevamente.';
      } else {
        _error = 'Error al iniciar sesión: $e';
      }
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> signOut() async {
    _isLoading = true;
    notifyListeners();

    try {
      await SupabaseConfig.client.auth.signOut();
      _currentUser = null;
      _error = null;
    } catch (e) {
      _error = 'Error al cerrar sesión: $e';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> updateProfile({
    String? name,
    String? avatarUrl,
    String? role,
  }) async {
    if (_currentUser == null) return false;

    try {
      final updates = <String, dynamic>{};
      if (name != null) updates['name'] = name;
      if (avatarUrl != null) updates['avatar_url'] = avatarUrl;
      if (role != null) updates['role'] = role;
      updates['updated_at'] = DateTime.now().toIso8601String();

      await SupabaseConfig.client
          .from('users')
          .update(updates)
          .eq('id', _currentUser!.id);

      _currentUser = _currentUser!.copyWith(
        name: name,
        avatarUrl: avatarUrl,
        role: role,
        updatedAt: DateTime.now(),
      );

      _error = null;
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Error al actualizar perfil: $e';
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateExperience(int newExperience) async {
    if (_currentUser == null) return false;

    try {
      await SupabaseConfig.client
          .from('users')
          .update({
            'experience': newExperience,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', _currentUser!.id);

      _currentUser = _currentUser!.copyWith(
        experience: newExperience,
        updatedAt: DateTime.now(),
      );

      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Error al actualizar experiencia: $e';
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}