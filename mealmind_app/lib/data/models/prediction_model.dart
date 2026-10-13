class ExplainableFactor {
  final String factor;
  final String value;
  final String impact;

  ExplainableFactor({
    required this.factor,
    required this.value,
    required this.impact,
  });

  factory ExplainableFactor.fromMap(Map<String, dynamic> map) {
    return ExplainableFactor(
      factor: map['factor'] ?? '',
      value: map['value'] ?? '',
      impact: map['impact'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'factor': factor,
      'value': value,
      'impact': impact,
    };
  }
}

class PredictionModel {
  final String foodItem;
  final String mealType;
  final int expectedAttendance;
  final int mealConfirmations;
  final double predictedConsumption;
  final double recommendedPreparation;
  final String unit;
  final double confidenceScore;
  final List<ExplainableFactor> explainableFactors;
  final String predictedRiskLevel; // 'Low', 'Medium', 'High'
  final double predictedWastePercentage;
  final bool exceedsThreshold;
  final String? alertMessage;
  final String? actionableSuggestion;
  final bool isAiEstimate;

  PredictionModel({
    required this.foodItem,
    required this.mealType,
    required this.expectedAttendance,
    required this.mealConfirmations,
    required this.predictedConsumption,
    required this.recommendedPreparation,
    this.unit = 'kg',
    required this.confidenceScore,
    required this.explainableFactors,
    this.predictedRiskLevel = 'Low',
    this.predictedWastePercentage = 6.5,
    this.exceedsThreshold = false,
    this.alertMessage,
    this.actionableSuggestion,
    this.isAiEstimate = true,
  });

  factory PredictionModel.fromMap(Map<String, dynamic> map) {
    final factors = (map['explainable_factors'] as List<dynamic>?)
            ?.map((e) => ExplainableFactor.fromMap(e as Map<String, dynamic>))
            .toList() ??
        [];

    return PredictionModel(
      foodItem: map['food_item'] ?? '',
      mealType: map['meal_type'] ?? 'Lunch',
      expectedAttendance: map['expected_attendance'] ?? 500,
      mealConfirmations: map['meal_confirmations'] ?? 480,
      predictedConsumption: (map['predicted_consumption'] ?? 0.0).toDouble(),
      recommendedPreparation: (map['recommended_preparation'] ?? 0.0).toDouble(),
      unit: map['unit'] ?? 'kg',
      confidenceScore: (map['confidence_score'] ?? 90.0).toDouble(),
      explainableFactors: factors,
      predictedRiskLevel: map['predicted_risk_level'] ?? 'Low',
      predictedWastePercentage: (map['predicted_waste_percentage'] ?? 6.0).toDouble(),
      exceedsThreshold: map['exceeds_threshold'] ?? false,
      alertMessage: map['alert_message'],
      actionableSuggestion: map['actionable_suggestion'],
      isAiEstimate: map['is_ai_estimate'] ?? true,
    );
  }
}
