import 'package:flutter/material.dart';
import '../models/trip.dart';
import '../models/trip_participant.dart';
import '../config/supabase_config.dart';
import '../services/experience_service.dart';
import '../services/storage_service.dart';

extension SafeNotify on ChangeNotifier {
  void safeNotifyListeners() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }
}

class TripsProvider with ChangeNotifier {
  List<Trip> _trips = [];
  List<Trip> _userTrips = [];
  List<Trip> _exploreTrips = [];
  bool _isLoading = false;
  String? _error;

  List<Trip> get trips => _trips;
  List<Trip> get userTrips => _userTrips;
  List<Trip> get exploreTrips => _exploreTrips;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadExploreTrips() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      print('Cargando viajes de exploración...');

      final response = await SupabaseConfig.client
          .from('trips')
          .select('*, organizer:users(*)')
          .eq('is_public', true)
          .order('created_at', ascending: false);

      print('Respuesta de Supabase: $response');

      _exploreTrips = response.map<Trip>((json) {
        print('Procesando viaje: $json');
        return Trip.fromJson(json);
      }).toList();

      print('Viajes cargados exitosamente: ${_exploreTrips.length}');
      _error = null;
    } catch (e) {
      print('Error detallado al cargar viajes: $e');
      _error = 'Error al cargar viajes. Verifica tu conexión a internet.';
      _exploreTrips = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadUserTrips(String userId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      print('Cargando viajes del usuario: $userId');

      // Cargar viajes donde el usuario es organizador
      final organizerTrips = await SupabaseConfig.client
          .from('trips')
          .select('*, organizer:users(*)')
          .eq('organizer_id', userId);

      print('Viajes como organizador: ${organizerTrips.length}');

      // Cargar viajes donde el usuario es participante
      final participantTrips = await SupabaseConfig.client
          .from('trip_participants')
          .select('trip:trips(*, organizer:users(*))')
          .eq('user_id', userId);

      print('Viajes como participante: ${participantTrips.length}');

      final trips = <Trip>[];

      // Agregar viajes organizados
      trips.addAll(organizerTrips.map<Trip>((json) {
        print('Procesando viaje organizado: ${json['title']}');
        return Trip.fromJson(json);
      }));

      // Agregar viajes como participante
      for (final participant in participantTrips) {
        if (participant['trip'] != null) {
          print('Procesando viaje como participante: ${participant['trip']['title']}');
          trips.add(Trip.fromJson(participant['trip']));
        }
      }

      // Remover duplicados y ordenar por fecha
      final uniqueTrips = <String, Trip>{};
      for (final trip in trips) {
        uniqueTrips[trip.id] = trip;
      }

      _userTrips = uniqueTrips.values.toList()
        ..sort((a, b) => (b.startDate ?? b.createdAt).compareTo(a.startDate ?? a.createdAt));

      print('Viajes del usuario cargados: ${_userTrips.length}');
      _error = null;
    } catch (e) {
      print('Error detallado al cargar viajes del usuario: $e');
      _error = 'Error al cargar tus viajes. Verifica tu conexión a internet.';
      _userTrips = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> createTrip({
    required String title,
    String? description,
    String? imageUrl,
    DateTime? startDate,
    DateTime? endDate,
    required String organizerId,
    bool isPublic = true,
    int maxParticipants = 10,
    List<String>? tags,
    double? meetingLat,
    double? meetingLng,
    double? destinationLat,
    double? destinationLng,
    String? meetingAddress,
    String? destinationAddress,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      print('=== CREANDO VIAJE ===');
      print('Título: $title');
      print('Descripción: $description');
      print('Imagen URL: $imageUrl');
      print('Fecha inicio: $startDate');
      print('Fecha fin: $endDate');
      print('Organizador ID: $organizerId');
      print('Es público: $isPublic');

      final tripData = {
        'title': title,
        'description': description,
        'image_url': imageUrl,
        'start_date': startDate?.toIso8601String(),
        'end_date': endDate?.toIso8601String(),
        'organizer_id': organizerId,
        'status': 'planned',
        'is_public': isPublic,
        'max_participants': maxParticipants,
        'tags': tags,
        'created_at': DateTime.now().toIso8601String(),
        'meeting_lat': meetingLat,
        'meeting_lng': meetingLng,
        'destination_lat': destinationLat,
        'destination_lng': destinationLng,
        'meeting_address': meetingAddress,
        'destination_address': destinationAddress,
      };

      print('Datos a enviar: $tripData');

      final response = await SupabaseConfig.client
          .from('trips')
          .insert(tripData)
          .select('*, organizer:users(*)')
          .single();

      print('Respuesta de Supabase: $response');

      var newTrip = Trip.fromJson(response);
      print('Viaje creado: ${newTrip.title}');

      // Si hay imagen, actualizar con el ID real del viaje
      if (imageUrl != null && imageUrl.isNotEmpty) {
        final realImageUrl = await StorageService.updateTripImage(imageUrl, newTrip.id, null);
        if (realImageUrl != null) {
          imageUrl = realImageUrl;
          // Actualizar el viaje con la URL correcta
          newTrip = newTrip.copyWith(imageUrl: realImageUrl);
        }
      }

      // Agregar el organizador como participante
      await SupabaseConfig.client.from('trip_participants').insert({
        'trip_id': newTrip.id,
        'user_id': organizerId,
        'role': 'organizer',
        'joined_at': DateTime.now().toIso8601String(),
      });

      _trips.insert(0, newTrip);
      _userTrips.insert(0, newTrip);
      if (isPublic) {
        _exploreTrips.insert(0, newTrip);
      }

      // Otorgar puntos de experiencia por crear viaje
      await ExperienceService.awardTripCreation(organizerId);

      print('✅ Viaje creado exitosamente');
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      print('❌ Error detallado al crear viaje: $e');
      print('Stack trace: ${StackTrace.current}');
      _error = 'Error al crear viaje: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> joinTrip(String tripId, String userId) async {
    try {
      // Verificar si ya está participando
      final existing = await SupabaseConfig.client
          .from('trip_participants')
          .select()
          .eq('trip_id', tripId)
          .eq('user_id', userId)
          .maybeSingle();

      if (existing != null) {
        _error = 'Ya estás participando en este viaje';
        safeNotifyListeners();
        return false;
      }

      // Verificar límite de participantes
      final tripResponse = await SupabaseConfig.client
          .from('trips')
          .select('max_participants')
          .eq('id', tripId)
          .single();

      final participantCount = await SupabaseConfig.client
          .from('trip_participants')
          .select()
          .eq('trip_id', tripId)
          .then((data) => data.length);

      if (participantCount >= (tripResponse['max_participants'] ?? 10)) {
        _error = 'El viaje ya está completo';
        safeNotifyListeners();
        return false;
      }

      // Unirse al viaje
      await SupabaseConfig.client.from('trip_participants').insert({
        'trip_id': tripId,
        'user_id': userId,
        'role': 'participant',
        'joined_at': DateTime.now().toIso8601String(),
      });

      // Recargar viajes del usuario
      await loadUserTrips(userId);

      // Otorgar puntos de experiencia por unirse al viaje
      await ExperienceService.awardTripJoin(userId);

      return true;
    } catch (e) {
      _error = 'Error al unirse al viaje. Puede que ya estés participando o el viaje esté completo.';
      safeNotifyListeners();
      return false;
    }
  }

  Future<bool> leaveTrip(String tripId, String userId) async {
    try {
      await SupabaseConfig.client
          .from('trip_participants')
          .delete()
          .eq('trip_id', tripId)
          .eq('user_id', userId)
          .neq('role', 'organizer'); // No permitir que el organizador abandone

      // Recargar viajes del usuario
      await loadUserTrips(userId);

      return true;
    } catch (e) {
      _error = 'Error al abandonar el viaje: $e';
      safeNotifyListeners();
      return false;
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}