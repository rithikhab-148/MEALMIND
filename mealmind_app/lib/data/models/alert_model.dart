class AlertModel {
  final String id;
  final String title;
  final String message;
  final String severity; // 'normal', 'warning', 'critical'
  final String targetRole; // 'admin', 'staff', 'student'
  final DateTime timestamp;
  final bool isRead;
  final String? relatedFoodItem;

  AlertModel({
    required this.id,
    required this.title,
    required this.message,
    required this.severity,
    required this.targetRole,
    required this.timestamp,
    this.isRead = false,
    this.relatedFoodItem,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'severity': severity,
      'target_role': targetRole,
      'timestamp': timestamp.toIso8601String(),
      'is_read': isRead,
      'related_food_item': relatedFoodItem,
    };
  }

  factory AlertModel.fromMap(Map<String, dynamic> map) {
    return AlertModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      message: map['message'] ?? '',
      severity: map['severity'] ?? 'warning',
      targetRole: map['target_role'] ?? 'all',
      timestamp: map['timestamp'] != null
          ? DateTime.tryParse(map['timestamp']) ?? DateTime.now()
          : DateTime.now(),
      isRead: map['is_read'] ?? false,
      relatedFoodItem: map['related_food_item'],
    );
  }
}
