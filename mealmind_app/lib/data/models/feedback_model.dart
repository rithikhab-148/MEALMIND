class FeedbackModel {
  final String id;
  final String studentId;
  final String studentName;
  final String foodItem;
  final String date;
  final String mealType;
  final double tasteRating; // 1 to 5
  final double qualityRating; // 1 to 5
  final double portionRating; // 1 to 5 (1=Too small, 3=Perfect, 5=Too big)
  final double overallRating; // 1 to 5
  final String? comments;
  final String? portionIssueReported; // 'too_large', 'too_small', 'optimal'
  final DateTime createdAt;

  FeedbackModel({
    required this.id,
    required this.studentId,
    required this.studentName,
    required this.foodItem,
    required this.date,
    required this.mealType,
    required this.tasteRating,
    required this.qualityRating,
    required this.portionRating,
    required this.overallRating,
    this.comments,
    this.portionIssueReported,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'student_id': studentId,
      'student_name': studentName,
      'food_item': foodItem,
      'date': date,
      'meal_type': mealType,
      'taste_rating': tasteRating,
      'quality_rating': qualityRating,
      'portion_rating': portionRating,
      'overall_rating': overallRating,
      'comments': comments,
      'portion_issue_reported': portionIssueReported,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory FeedbackModel.fromMap(Map<String, dynamic> map) {
    return FeedbackModel(
      id: map['id'] ?? '',
      studentId: map['student_id'] ?? '',
      studentName: map['student_name'] ?? 'Student',
      foodItem: map['food_item'] ?? '',
      date: map['date'] ?? '',
      mealType: map['meal_type'] ?? 'Lunch',
      tasteRating: (map['taste_rating'] ?? 4.0).toDouble(),
      qualityRating: (map['quality_rating'] ?? 4.0).toDouble(),
      portionRating: (map['portion_rating'] ?? 3.0).toDouble(),
      overallRating: (map['overall_rating'] ?? 4.0).toDouble(),
      comments: map['comments'],
      portionIssueReported: map['portion_issue_reported'],
      createdAt: map['created_at'] != null
          ? DateTime.tryParse(map['created_at']) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}
