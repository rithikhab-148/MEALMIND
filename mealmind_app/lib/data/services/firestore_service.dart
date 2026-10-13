import 'package:uuid/uuid.dart';
import '../models/menu_item_model.dart';
import '../models/meal_response_model.dart';
import '../models/food_prep_model.dart';
import '../models/food_consumption_model.dart';
import '../models/food_waste_model.dart';
import '../models/feedback_model.dart';
import '../models/prediction_model.dart';
import '../models/recommendation_model.dart';
import '../models/alert_model.dart';
import 'demo_data_service.dart';

class FirestoreService {
  static final FirestoreService _instance = FirestoreService._internal();
  factory FirestoreService() => _instance;
  FirestoreService._internal();

  final _uuid = const Uuid();

  // In-memory data store with Demo initialization
  List<MenuItemModel> _menus = [];
  List<MealResponseModel> _responses = [];
  List<FoodPrepModel> _prepLogs = [];
  List<FoodConsumptionModel> _consumptionLogs = [];
  List<FoodWasteModel> _wasteLogs = [];
  List<FeedbackModel> _feedbackLogs = [];
  List<PredictionModel> _predictions = [];
  List<RecommendationModel> _recommendations = [];
  List<AlertModel> _alerts = [];
  double _targetWasteThreshold = 15.0;

  bool _initialized = false;

  void init() {
    if (_initialized) return;
    _menus = DemoDataService.getTodayMenu();
    _responses = DemoDataService.getInitialStudentResponses('usr_student_01');
    _prepLogs = DemoDataService.getInitialPrepLogs();
    _consumptionLogs = DemoDataService.getInitialConsumptionLogs();
    _wasteLogs = DemoDataService.getInitialWasteLogs();
    _feedbackLogs = DemoDataService.getInitialFeedback();
    _predictions = DemoDataService.getInitialPredictions();
    _recommendations = DemoDataService.getInitialRecommendations();
    _alerts = DemoDataService.getInitialAlerts();
    _initialized = true;
  }

  // --- Target Waste Threshold ---
  double get targetWasteThreshold => _targetWasteThreshold;
  void setTargetWasteThreshold(double threshold) {
    _targetWasteThreshold = threshold;
  }

  // --- Menus ---
  List<MenuItemModel> getMenus({String? mealType, String? date}) {
    init();
    return _menus.where((item) {
      if (mealType != null && item.mealType != mealType) return false;
      if (date != null && item.date != date) return false;
      return true;
    }).toList();
  }

  void addMenuItem(MenuItemModel item) {
    _menus.add(item);
  }

  void updateMenuItem(MenuItemModel updatedItem) {
    final idx = _menus.indexWhere((i) => i.id == updatedItem.id);
    if (idx != -1) {
      _menus[idx] = updatedItem;
    }
  }

  void deleteMenuItem(String id) {
    _menus.removeWhere((i) => i.id == id);
  }

  // --- Meal Responses (RSVP) ---
  List<MealResponseModel> getResponses({String? studentId, String? mealType, String? date}) {
    init();
    return _responses.where((rsp) {
      if (studentId != null && rsp.studentId != studentId) return false;
      if (mealType != null && rsp.mealType != mealType) return false;
      if (date != null && rsp.date != date) return false;
      return true;
    }).toList();
  }

  int getConfirmedCount({required String mealType, required String date}) {
    init();
    return _responses
        .where((r) => r.mealType == mealType && r.date == date && r.willAttend)
        .length;
  }

  void setMealResponse({
    required String studentId,
    required String studentName,
    required String date,
    required String mealType,
    required String response, // 'YES' or 'NO'
  }) {
    init();
    final existingIdx = _responses.indexWhere(
      (r) => r.studentId == studentId && r.date == date && r.mealType == mealType,
    );

    if (existingIdx != -1) {
      _responses[existingIdx] = MealResponseModel(
        id: _responses[existingIdx].id,
        studentId: studentId,
        studentName: studentName,
        date: date,
        mealType: mealType,
        response: response,
        timestamp: DateTime.now(),
      );
    } else {
      _responses.add(
        MealResponseModel(
          id: _uuid.v4(),
          studentId: studentId,
          studentName: studentName,
          date: date,
          mealType: mealType,
          response: response,
          timestamp: DateTime.now(),
        ),
      );
    }
  }

  // --- Food Preparation Logs ---
  List<FoodPrepModel> getPrepLogs({String? mealType, String? date}) {
    init();
    return _prepLogs.where((p) {
      if (mealType != null && p.mealType != mealType) return false;
      if (date != null && p.date != date) return false;
      return true;
    }).toList();
  }

  void addPrepLog(FoodPrepModel log) {
    _prepLogs.insert(0, log);
  }

  // --- Food Consumption Logs ---
  List<FoodConsumptionModel> getConsumptionLogs({String? mealType, String? date}) {
    init();
    return _consumptionLogs.where((c) {
      if (mealType != null && c.mealType != mealType) return false;
      if (date != null && c.date != date) return false;
      return true;
    }).toList();
  }

  void recordConsumption(FoodConsumptionModel log) {
    final idx = _consumptionLogs.indexWhere(
      (c) => c.foodItem == log.foodItem && c.date == log.date && c.mealType == log.mealType,
    );
    if (idx != -1) {
      _consumptionLogs[idx] = log;
    } else {
      _consumptionLogs.insert(0, log);
    }
  }

  // --- Food Waste Logs ---
  List<FoodWasteModel> getWasteLogs({String? mealType, String? date, String? wasteType}) {
    init();
    return _wasteLogs.where((w) {
      if (mealType != null && w.mealType != mealType) return false;
      if (date != null && w.date != date) return false;
      if (wasteType != null && w.wasteType != wasteType) return false;
      return true;
    }).toList();
  }

  void recordWaste(FoodWasteModel waste) {
    _wasteLogs.insert(0, waste);
  }

  // --- Student Feedback ---
  List<FeedbackModel> getFeedback({String? foodItem, String? mealType}) {
    init();
    return _feedbackLogs.where((f) {
      if (foodItem != null && f.foodItem != foodItem) return false;
      if (mealType != null && f.mealType != mealType) return false;
      return true;
    }).toList();
  }

  void submitFeedback(FeedbackModel feedback) {
    _feedbackLogs.insert(0, feedback);
  }

  // --- Predictions & Recommendations ---
  List<PredictionModel> getPredictions() {
    init();
    return _predictions;
  }

  void updatePredictions(List<PredictionModel> newPredictions) {
    _predictions = newPredictions;
  }

  List<RecommendationModel> getRecommendations() {
    init();
    return _recommendations;
  }

  void toggleRecommendationApplied(String id) {
    final idx = _recommendations.indexWhere((r) => r.id == id);
    if (idx != -1) {
      final rec = _recommendations[idx];
      _recommendations[idx] = RecommendationModel(
        id: rec.id,
        category: rec.category,
        title: rec.title,
        description: rec.description,
        impactLevel: rec.impactLevel,
        estimatedSavingsMonthly: rec.estimatedSavingsMonthly,
        targetRole: rec.targetRole,
        icon: rec.icon,
        isApplied: !rec.isApplied,
      );
    }
  }

  // --- Alerts & Notifications ---
  List<AlertModel> getAlerts({String? role}) {
    init();
    return _alerts.where((a) {
      if (role != null && a.targetRole != 'all' && a.targetRole != role) {
        return false;
      }
      return true;
    }).toList();
  }

  void addAlert(AlertModel alert) {
    _alerts.insert(0, alert);
  }

  void markAlertRead(String id) {
    final idx = _alerts.indexWhere((a) => a.id == id);
    if (idx != -1) {
      final a = _alerts[idx];
      _alerts[idx] = AlertModel(
        id: a.id,
        title: a.title,
        message: a.message,
        severity: a.severity,
        targetRole: a.targetRole,
        timestamp: a.timestamp,
        isRead: true,
        relatedFoodItem: a.relatedFoodItem,
      );
    }
  }
}
