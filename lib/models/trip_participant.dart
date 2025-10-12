import 'user.dart';
import 'trip.dart';

enum ParticipantRole { organizer, participant }

class TripParticipant {
  final String id;
  final String tripId;
  final String userId;
  final User? user;
  final Trip? trip;
  final ParticipantRole role;
  final DateTime joinedAt;

  TripParticipant({
    required this.id,
    required this.tripId,
    required this.userId,
    this.user,
    this.trip,
    this.role = ParticipantRole.participant,
    required this.joinedAt,
  });

  factory TripParticipant.fromJson(Map<String, dynamic> json) {
    return TripParticipant(
      id: json['id'],
      tripId: json['trip_id'],
      userId: json['user_id'],
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      trip: json['trip'] != null ? Trip.fromJson(json['trip']) : null,
      role: ParticipantRole.values.firstWhere(
        (e) => e.name == json['role'],
        orElse: () => ParticipantRole.participant,
      ),
      joinedAt: DateTime.parse(json['joined_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'trip_id': tripId,
      'user_id': userId,
      'role': role.name,
      'joined_at': joinedAt.toIso8601String(),
    };
  }

  TripParticipant copyWith({
    String? id,
    String? tripId,
    String? userId,
    User? user,
    Trip? trip,
    ParticipantRole? role,
    DateTime? joinedAt,
  }) {
    return TripParticipant(
      id: id ?? this.id,
      tripId: tripId ?? this.tripId,
      userId: userId ?? this.userId,
      user: user ?? this.user,
      trip: trip ?? this.trip,
      role: role ?? this.role,
      joinedAt: joinedAt ?? this.joinedAt,
    );
  }
}