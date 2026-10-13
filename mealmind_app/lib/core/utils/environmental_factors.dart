import '../constants/app_constants.dart';

class EnvironmentalMetrics {
  final double foodSavedKg;
  final double co2AvoidedKg;
  final double waterSavedLitres;
  final double moneySaved;
  final String assumptionNote;

  EnvironmentalMetrics({
    required this.foodSavedKg,
    required this.co2AvoidedKg,
    required this.waterSavedLitres,
    required this.moneySaved,
    this.assumptionNote = 'Estimates calculated based on UNEP/FAO conversion baselines: 2.5 kg CO2e/kg food waste and 1,000 L embedded water/kg food.',
  });

  factory EnvironmentalMetrics.fromFoodSaved(double foodSavedKg, {double avgCostPerKg = 45.0}) {
    final co2 = foodSavedKg * AppConstants.co2PerKgWaste;
    final water = foodSavedKg * AppConstants.waterLitresPerKgWaste;
    final money = foodSavedKg * avgCostPerKg;

    return EnvironmentalMetrics(
      foodSavedKg: double.parse(foodSavedKg.toStringAsFixed(1)),
      co2AvoidedKg: double.parse(co2.toStringAsFixed(1)),
      waterSavedLitres: double.parse(water.toStringAsFixed(0)),
      moneySaved: double.parse(money.toStringAsFixed(0)),
    );
  }
}
