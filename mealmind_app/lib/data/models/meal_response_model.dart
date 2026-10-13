class MealResponseModel {
  final String id;
  final String studentId;
  final String studentName;
  final String date; // YYYY-MM-DD
  final String mealType; // Breakfast, Lunch, Snacks, Dinner
  final String response; // 'YES', 'NO'
  final DateTime timestamp;
  final String? diningHallId;

  MealResponseModel({
    required this.id,
    required this.studentId,
    required this.studentName,
    required this.date,
    required this.mealType,
    required this.response,
    required this.timestamp,
    this.diningHallId,
  });

  bool get willAttend => response.toUpperCase() == 'YES';

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'student_id': studentId,
      'student_name': studentName,
      'date': date,
      'meal_type': mealType,
      'response': response,
      'timestamp': timestamp.toIso8601String(),
      'dining_hall_id': diningHallId,
    };
  }

  factory MealResponseModel.fromMap(Map<String, dynamic> map) {
    return MealResponseModel(
      id: map['id'] ?? '',
      studentId: map['student_id'] ?? '',
      studentName: map['student_name'] ?? 'Student',
      date: map['date'] ?? '',
      mealType: map['meal_type'] ?? 'Lunch',
      response: map['response'] ?? 'YES',
      timestamp: map['timestamp'] != null
          ? DateTime.tryParse(map['timestamp']) ?? DateTime.now()
          : DateTime.now(),
      diningHallId: map['dining_hall_id'],
    );
  }
}
