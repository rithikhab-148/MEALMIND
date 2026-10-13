import 'package:flutter/material.dart';
import '../data/models/food_prep_model.dart';
import '../data/models/food_consumption_model.dart';
import '../data/models/food_waste_model.dart';
import '../data/models/alert_model.dart';
import '../data/services/firestore_service.dart';
import '../data/services/notification_service.dart';
import '../../core/utils/calculations.dart';

class WasteProvider with ChangeNotifier {
  final FirestoreService _firestore = FirestoreService();
  final NotificationService _notificationService = NotificationService();

  String _selectedMealType = 'Lunch';
  String _selectedDate = DateTime.now().toIso8601String().substring(0, 10);

  String get selectedMealType => _selectedMealType;
  String get selectedDate => _selectedDate;

  void setSelectedMealType(String mealType) {
    _selectedMealType = mealType;
    notifyListeners();
  }

  void setSelectedDate(String date) {
    _selectedDate = date;
    notifyListeners();
  }

  // Prep Logs
  List<FoodPrepModel> getPrepLogs({String? mealType}) {
    return _firestore.getPrepLogs(
      mealType: mealType ?? _selectedMealType,
      date: _selectedDate,
    );
  }

  void addPrepLog(FoodPrepModel log) {
    _firestore.addPrepLog(log);
    notifyListeners();
  }

  // Consumption Logs
  List<FoodConsumptionModel> getConsumptionLogs({String? mealType}) {
    return _firestore.getConsumptionLogs(
      mealType: mealType ?? _selectedMealType,
      date: _selectedDate,
    );
  }

  void recordConsumption(FoodConsumptionModel log) {
    _firestore.recordConsumption(log);

    // Check if waste exceeds threshold and trigger alert
    final threshold = _firestore.targetWasteThreshold;
    if (log.wastePercentage > threshold) {
      _notificationService.sendWasteAlert(
        foodItem: log.foodItem,
        wastePercentage: log.wastePercentage,
        targetThreshold: threshold,
        mealType: log.mealType,
      );
    }
    notifyListeners();
  }

  // Waste Logs
  List<FoodWasteModel> getWasteLogs({String? mealType, String? wasteType}) {
    return _firestore.getWasteLogs(
      mealType: mealType,
      date: _selectedDate,
      wasteType: wasteType,
    );
  }

  void recordWaste(FoodWasteModel waste) {
    _firestore.recordWaste(waste);
    notifyListeners();
  }

  // Alerts
  List<AlertModel> getAlerts({String? role}) {
    return _firestore.getAlerts(role: role);
  }

  void markAlertRead(String id) {
    _firestore.markAlertRead(id);
    notifyListeners();
  }
}
