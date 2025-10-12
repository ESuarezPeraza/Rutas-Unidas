import 'user.dart';

enum TripStatus { planned, inProgress, completed, cancelled }

class Trip {
  final String id;
  final String title;
  final String? description;
  final String? imageUrl;
  final DateTime? startDate;
  final DateTime? endDate;
  final String organizerId;
  final User? organizer;
  final TripStatus status;
  final bool isPublic;
  final int maxParticipants;
  final List<String>? tags;
  final DateTime createdAt;
  final DateTime? updatedAt;

  // Nuevos campos de ubicación
  final double? meetingLat;
  final double? meetingLng;
  final double? destinationLat;
  final double? destinationLng;
  final String? meetingAddress;
  final String? destinationAddress;

  Trip({
    required this.id,
    required this.title,
    this.description,
    this.imageUrl,
    this.startDate,
    this.endDate,
    required this.organizerId,
    this.organizer,
    this.status = TripStatus.planned,
    this.isPublic = true,
    this.maxParticipants = 10,
    this.tags,
    required this.createdAt,
    this.updatedAt,
    this.meetingLat,
    this.meetingLng,
    this.destinationLat,
    this.destinationLng,
    this.meetingAddress,
    this.destinationAddress,
  });

  factory Trip.fromJson(Map<String, dynamic> json) {
    return Trip(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      imageUrl: json['image_url'],
      startDate: json['start_date'] != null ? DateTime.parse(json['start_date']) : null,
      endDate: json['end_date'] != null ? DateTime.parse(json['end_date']) : null,
      organizerId: json['organizer_id'],
      organizer: json['organizer'] != null ? User.fromJson(json['organizer']) : null,
      status: TripStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => TripStatus.planned,
      ),
      isPublic: json['is_public'] ?? true,
      maxParticipants: json['max_participants'] ?? 10,
      tags: json['tags'] != null ? List<String>.from(json['tags']) : null,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
      meetingLat: json['meeting_lat']?.toDouble(),
      meetingLng: json['meeting_lng']?.toDouble(),
      destinationLat: json['destination_lat']?.toDouble(),
      destinationLng: json['destination_lng']?.toDouble(),
      meetingAddress: json['meeting_address'],
      destinationAddress: json['destination_address'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'image_url': imageUrl,
      'start_date': startDate?.toIso8601String(),
      'end_date': endDate?.toIso8601String(),
      'organizer_id': organizerId,
      'status': status.name,
      'is_public': isPublic,
      'max_participants': maxParticipants,
      'tags': tags,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'meeting_lat': meetingLat,
      'meeting_lng': meetingLng,
      'destination_lat': destinationLat,
      'destination_lng': destinationLng,
      'meeting_address': meetingAddress,
      'destination_address': destinationAddress,
    };
  }

  Trip copyWith({
    String? id,
    String? title,
    String? description,
    String? imageUrl,
    DateTime? startDate,
    DateTime? endDate,
    String? organizerId,
    User? organizer,
    TripStatus? status,
    bool? isPublic,
    int? maxParticipants,
    List<String>? tags,
    DateTime? createdAt,
    DateTime? updatedAt,
    double? meetingLat,
    double? meetingLng,
    double? destinationLat,
    double? destinationLng,
    String? meetingAddress,
    String? destinationAddress,
  }) {
    return Trip(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      organizerId: organizerId ?? this.organizerId,
      organizer: organizer ?? this.organizer,
      status: status ?? this.status,
      isPublic: isPublic ?? this.isPublic,
      maxParticipants: maxParticipants ?? this.maxParticipants,
      tags: tags ?? this.tags,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      meetingLat: meetingLat ?? this.meetingLat,
      meetingLng: meetingLng ?? this.meetingLng,
      destinationLat: destinationLat ?? this.destinationLat,
      destinationLng: destinationLng ?? this.destinationLng,
      meetingAddress: meetingAddress ?? this.meetingAddress,
      destinationAddress: destinationAddress ?? this.destinationAddress,
    );
  }

  String get formattedDate {
    if (startDate == null) return 'Fecha por definir';

    final start = '${startDate!.day.toString().padLeft(2, '0')}/${startDate!.month.toString().padLeft(2, '0')}/${startDate!.year}';

    if (endDate == null) return start;

    final end = '${endDate!.day.toString().padLeft(2, '0')}/${endDate!.month.toString().padLeft(2, '0')}/${endDate!.year}';
    return '$start - $end';
  }

  bool get isUpcoming => startDate != null && startDate!.isAfter(DateTime.now());
  bool get isPast => endDate != null && endDate!.isBefore(DateTime.now());
  bool get isCurrent => startDate != null && endDate != null &&
                       startDate!.isBefore(DateTime.now()) &&
                       endDate!.isAfter(DateTime.now());
}