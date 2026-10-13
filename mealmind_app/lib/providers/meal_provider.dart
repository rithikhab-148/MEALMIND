import 'package:flutter/material.dart';
import '../data/models/menu_item_model.dart';
import '../data/models/meal_response_model.dart';
import '../data/models/feedback_model.dart';
import '../data/services/firestore_service.dart';

class MealProvider with ChangeNotifier {
  final FirestoreService _firestore = FirestoreService();

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

  List<MenuItemModel> getMenus({String? mealType}) {
    return _firestore.getMenus(
      mealType: mealType ?? _selectedMealType,
      date: _selectedDate,
    );
  }

  void addMenuItem(MenuItemModel item) {
    _firestore.addMenuItem(item);
    notifyListeners();
  }

  void updateMenuItem(MenuItemModel item) {
    _firestore.updateMenuItem(item);
    notifyListeners();
  }

  void deleteMenuItem(String id) {
    _firestore.deleteMenuItem(id);
    notifyListeners();
  }

  // Student RSVPs
  List<MealResponseModel> getStudentResponses(String studentId) {
    return _firestore.getResponses(studentId: studentId, date: _selectedDate);
  }

  int getConfirmedCount(String mealType) {
    return _firestore.getConfirmedCount(mealType: mealType, date: _selectedDate);
  }

  void setStudentResponse({
    required String studentId,
    required String studentName,
    required String mealType,
    required String response, // 'YES' or 'NO'
  }) {
    _firestore.setMealResponse(
      studentId: studentId,
      studentName: studentName,
      date: _selectedDate,
      mealType: mealType,
      response: response,
    );
    notifyListeners();
  }

  // Feedback
  List<FeedbackModel> getFeedback({String? foodItem}) {
    return _firestore.getFeedback(foodItem: foodItem);
  }

  void submitFeedback(FeedbackModel feedback) {
    _firestore.submitFeedback(feedback);
    notifyListeners();
  }
}
