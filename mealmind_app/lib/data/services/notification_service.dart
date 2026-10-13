import '../models/alert_model.dart';
import 'firestore_service.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FirestoreService _firestore = FirestoreService();

  void sendWasteAlert({
    required String foodItem,
    required double wastePercentage,
    required double targetThreshold,
    required String mealType,
  }) {
    final diff = (wastePercentage - targetThreshold).toStringAsFixed(1);
    final isCritical = wastePercentage > targetThreshold + 5.0;

    _firestore.addAlert(
      AlertModel(
        id: 'alt_${DateTime.now().millisecondsSinceEpoch}',
        title: isCritical ? '🔴 Critical: Waste Threshold Exceeded' : '⚠️ Warning: Elevated Waste Level',
        message: 'Today\'s $mealType $foodItem waste reached ${wastePercentage.toStringAsFixed(1)}%, exceeding target ($targetThreshold%) by $diff%.',
        severity: isCritical ? 'critical' : 'warning',
        targetRole: 'staff',
        timestamp: DateTime.now(),
        relatedFoodItem: foodItem,
      ),
    );
  }

  void sendAttendanceNotice({
    required String mealType,
    required int expectedAttendance,
    required int confirmationCount,
  }) {
    _firestore.addAlert(
      AlertModel(
        id: 'alt_att_${DateTime.now().millisecondsSinceEpoch}',
        title: '📊 Attendance RSVP Update',
        message: '$confirmationCount students have confirmed for $mealType. Predicted demand: $expectedAttendance.',
        severity: 'normal',
        targetRole: 'staff',
        timestamp: DateTime.now(),
      ),
    );
  }

  void broadcastStudentReminder(String mealType) {
    _firestore.addAlert(
      AlertModel(
        id: 'alt_stu_${DateTime.now().millisecondsSinceEpoch}',
        title: '🔔 Confirm Your $mealType Meal',
        message: 'Please tap your attendance confirmation for $mealType to help the mess prepare the exact right quantity.',
        severity: 'normal',
        targetRole: 'student',
        timestamp: DateTime.now(),
      ),
    );
  }
}
