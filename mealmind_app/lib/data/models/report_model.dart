class ReportModel {
  final String title;
  final String period; // 'Daily', 'Weekly', 'Monthly'
  final DateTime generatedAt;
  final double totalPreparedKg;
  final double totalConsumedKg;
  final double totalWasteKg;
  final double wastePercentage;
  final double totalFinancialLoss;
  final String topWastedItem;
  final String highestWasteMeal;
  final String primaryWasteReason;
  final double co2AvoidedKg;
  final double waterSavedLitres;
  final List<Map<String, dynamic>> foodBreakdown;
  final List<String> topRecommendations;

  ReportModel({
    required this.title,
    required this.period,
    required this.generatedAt,
    required this.totalPreparedKg,
    required this.totalConsumedKg,
    required this.totalWasteKg,
    required this.wastePercentage,
    required this.totalFinancialLoss,
    required this.topWastedItem,
    required this.highestWasteMeal,
    required this.primaryWasteReason,
    required this.co2AvoidedKg,
    required this.waterSavedLitres,
    required this.foodBreakdown,
    required this.topRecommendations,
  });
}
