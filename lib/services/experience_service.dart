import 'dart:math' as math;
import '../config/supabase_config.dart';

class ExperienceService {
  // Puntos de experiencia por actividad
  static const int CREATE_TRIP_POINTS = 10;
  static const int JOIN_TRIP_POINTS = 5;
  static const int COMPLETE_TRIP_POINTS = 20;
  static const int ORGANIZE_SUCCESSFUL_TRIP_POINTS = 30;

  /// Otorga puntos por crear un viaje
  static Future<bool> awardTripCreation(String userId) async {
    try {
      await SupabaseConfig.client.rpc('increment_user_experience', params: {
        'user_id': userId,
        'points': CREATE_TRIP_POINTS,
      });
      return true;
    } catch (e) {
      print('Error awarding trip creation points: $e');
      return false;
    }
  }

  /// Otorga puntos por unirse a un viaje
  static Future<bool> awardTripJoin(String userId) async {
    try {
      await SupabaseConfig.client.rpc('increment_user_experience', params: {
        'user_id': userId,
        'points': JOIN_TRIP_POINTS,
      });
      return true;
    } catch (e) {
      print('Error awarding trip join points: $e');
      return false;
    }
  }

  /// Otorga puntos por completar un viaje (participante)
  static Future<bool> awardTripCompletion(String userId) async {
    try {
      await SupabaseConfig.client.rpc('increment_user_experience', params: {
        'user_id': userId,
        'points': COMPLETE_TRIP_POINTS,
      });
      return true;
    } catch (e) {
      print('Error awarding trip completion points: $e');
      return false;
    }
  }

  /// Otorga puntos por organizar un viaje exitoso
  static Future<bool> awardSuccessfulOrganization(String userId) async {
    try {
      await SupabaseConfig.client.rpc('increment_user_experience', params: {
        'user_id': userId,
        'points': ORGANIZE_SUCCESSFUL_TRIP_POINTS,
      });
      return true;
    } catch (e) {
      print('Error awarding successful organization points: $e');
      return false;
    }
  }

  /// Calcula el nivel basado en la experiencia
  static int calculateLevel(int experience) {
    // Nivel = sqrt(experiencia / 10) + 1
    // Esto hace que subir de nivel sea progresivamente más difícil
    return math.sqrt(experience / 10).floor() + 1;
  }

  /// Experiencia necesaria para el siguiente nivel
  static int experienceForNextLevel(int currentLevel) {
    // Experiencia = (nivel^2) * 10
    return currentLevel * currentLevel * 10;
  }

  /// Progreso hacia el siguiente nivel (0.0 a 1.0)
  static double levelProgress(int experience) {
    final currentLevel = calculateLevel(experience);
    final currentLevelExp = experienceForNextLevel(currentLevel - 1);
    final nextLevelExp = experienceForNextLevel(currentLevel);

    final progress = experience - currentLevelExp;
    final required = nextLevelExp - currentLevelExp;

    return progress / required;
  }

  /// Obtiene estadísticas del usuario
  static Future<Map<String, dynamic>?> getUserStats(String userId) async {
    try {
      final response = await SupabaseConfig.client
          .from('users')
          .select('experience, created_at')
          .eq('id', userId)
          .single();

      final experience = response['experience'] ?? 0;
      final level = calculateLevel(experience);
      final progress = levelProgress(experience);
      final nextLevelExp = experienceForNextLevel(level);

      // Contar viajes organizados
      final organizedTrips = await SupabaseConfig.client
          .from('trips')
          .select('id')
          .eq('organizer_id', userId)
          .then((data) => data.length);

      // Contar viajes como participante
      final participatedTrips = await SupabaseConfig.client
          .from('trip_participants')
          .select('id')
          .eq('user_id', userId)
          .neq('role', 'organizer')
          .then((data) => data.length);

      return {
        'experience': experience,
        'level': level,
        'progress': progress,
        'nextLevelExp': nextLevelExp,
        'organizedTrips': organizedTrips,
        'participatedTrips': participatedTrips,
        'totalTrips': organizedTrips + participatedTrips,
      };
    } catch (e) {
      print('Error getting user stats: $e');
      return null;
    }
  }
}