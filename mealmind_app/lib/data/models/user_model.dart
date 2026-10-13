class UserModel {
  final String id;
  final String name;
  final String email;
  final String role; // 'admin', 'staff', 'student'
  final String institutionId;
  final String? diningHallId;
  final String? studentIdNumber;
  final int mealsConfirmedCount;
  final double personalFoodSavedKg;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.institutionId,
    this.diningHallId,
    this.studentIdNumber,
    this.mealsConfirmedCount = 0,
    this.personalFoodSavedKg = 0.0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
      'institution_id': institutionId,
      'dining_hall_id': diningHallId,
      'student_id_number': studentIdNumber,
      'meals_confirmed_count': mealsConfirmedCount,
      'personal_food_saved_kg': personalFoodSavedKg,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      role: map['role'] ?? 'student',
      institutionId: map['institution_id'] ?? '',
      diningHallId: map['dining_hall_id'],
      studentIdNumber: map['student_id_number'],
      mealsConfirmedCount: map['meals_confirmed_count'] ?? 0,
      personalFoodSavedKg: (map['personal_food_saved_kg'] ?? 0.0).toDouble(),
    );
  }

  bool get isAdmin => role == 'admin';
  bool get isStaff => role == 'staff';
  bool get isStudent => role == 'student';
}
