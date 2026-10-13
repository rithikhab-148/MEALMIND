import 'package:flutter/material.dart';
import '../data/models/prediction_model.dart';
import '../data/models/recommendation_model.dart';
import '../data/services/firestore_service.dart';
import '../data/services/ml_api_service.dart';

class PredictionProvider with ChangeNotifier {
  final FirestoreService _firestore = FirestoreService();
  final MLApiService _mlApiService = MLApiService();

  bool _isForecasting = false;
  bool get isForecasting => _isForecasting;

  List<PredictionModel> get predictions => _firestore.getPredictions();
  List<RecommendationModel> get recommendations => _firestore.getRecommendations();

  Future<void> runDemandForecastForMenu({
    required List<String> foodItems,
    required String mealType,
    required int expectedAttendance,
    required int confirmations,
  }) async {
    _isForecasting = true;
    notifyListeners();

    final List<PredictionModel> results = [];
    for (var item in foodItems) {
      final pred = await _mlApiService.getDemandPrediction(
        foodItem: item,
        mealType: mealType,
        expectedAttendance: expectedAttendance,
        mealConfirmations: confirmations,
        targetThreshold: _firestore.targetWasteThreshold,
      );
      results.add(pred);
    }

    _firestore.updatePredictions(results);
    _isForecasting = false;
    notifyListeners();
  }

  void toggleRecommendation(String id) {
    _firestore.toggleRecommendationApplied(id);
    notifyListeners();
  }
}
