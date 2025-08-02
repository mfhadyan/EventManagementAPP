import 'user.dart';

class Event {
  final int id;
  final String title;
  final String description;
  final String location;
  final DateTime startDate;
  final DateTime endDate;
  final int maxAttendees;
  final double price;
  final String status;
  final String category;
  final User creator;
  final int registrationsCount;
  final int availableSpots;
  final bool isAvailable;
  final DateTime createdAt;
  final DateTime updatedAt;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.startDate,
    required this.endDate,
    required this.maxAttendees,
    required this.price,
    required this.status,
    required this.category,
    required this.creator,
    required this.registrationsCount,
    required this.availableSpots,
    required this.isAvailable,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      location: json['location'] ?? '',
      startDate: json['start_date'] != null 
          ? DateTime.parse(json['start_date']) 
          : DateTime.now(),
      endDate: json['end_date'] != null 
          ? DateTime.parse(json['end_date']) 
          : DateTime.now(),
      maxAttendees: json['max_attendees'] ?? 0,
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      status: json['status'] ?? 'active',
      category: json['category'] ?? 'Other',
      creator: json['creator'] != null 
          ? User(
              id: json['creator']['id'] ?? 0,
              name: json['creator']['name'] ?? 'Unknown',
              studentNumber: json['creator']['student_number'] ?? 'N/A',
              email: json['creator']['email'] ?? 'unknown@example.com',
              major: json['creator']['major'] ?? 'Unknown',
              classYear: json['creator']['class_year'] != null 
                  ? (json['creator']['class_year'] is String 
                      ? int.tryParse(json['creator']['class_year']) ?? 0
                      : json['creator']['class_year'])
                  : 0,
            )
          : User(
              id: 0,
              name: 'Unknown',
              studentNumber: 'N/A',
              email: 'unknown@example.com',
              major: 'Unknown',
              classYear: 0,
            ),
      registrationsCount: json['registrations_count'] ?? 0,
      availableSpots: json['available_spots'] ?? 0,
      isAvailable: json['is_available'] ?? true,
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : DateTime.now(),
      updatedAt: json['updated_at'] != null 
          ? DateTime.parse(json['updated_at']) 
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'location': location,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'max_attendees': maxAttendees,
      'price': price,
      'status': status,
      'category': category,
      'creator': creator.toJson(),
      'registrations_count': registrationsCount,
      'available_spots': availableSpots,
      'is_available': isAvailable,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
} 