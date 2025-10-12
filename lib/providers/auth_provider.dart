import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide User;
import '../models/user.dart' as app_user;
import '../config/supabase_config.dart';

class AuthProvider with ChangeNotifier {
  app_user.User? _currentUser;
  bool _isLoading = false;
  String? _error;

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
      final session = event.session;
      if (session != null) {
        _loadUserProfile(session.user.id);
      } else {
        _currentUser = null;
        notifyListeners();
      }
    });
  }

  Future<void> _loadUserProfile(String userId) async {
    try {
      final response = await SupabaseConfig.client
          .from('users')
          .select()
          .eq('id', userId)
          .single();

      _currentUser = app_user.User.fromJson(response);
      _error = null;
    } catch (e) {
      _error = 'Error al cargar el perfil: $e';
      _currentUser = null;
      // Crear perfil básico si no existe
      try {
        final authUser = SupabaseConfig.client.auth.currentUser;
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
          _error = null;
        }
      } catch (createError) {
        _error = 'Error al crear perfil: $createError';
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
      _error = 'Error al registrarse: $e';
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

    try {
      final response = await SupabaseConfig.client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      _isLoading = false;
      notifyListeners();
      return response.user != null;
    } catch (e) {
      _error = 'Error al iniciar sesión: $e';
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