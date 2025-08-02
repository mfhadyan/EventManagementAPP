class User {
  final int id;
  final String name;
  final String studentNumber;
  final String email;
  final String major;
  final int classYear;

  User({
    required this.id,
    required this.name,
    required this.studentNumber,
    required this.email,
    required this.major,
    required this.classYear,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      studentNumber: json['student_number'] ?? '',
      email: json['email'] ?? 'unknown@example.com',
      major: json['major'] ?? 'Unknown',
      classYear: json['class_year'] != null 
          ? (json['class_year'] is String 
              ? int.parse(json['class_year']) 
              : json['class_year'])
          : 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'student_number': studentNumber,
      'email': email,
      'major': major,
      'class_year': classYear,
    };
  }
} 