/// Core mathematical and analytical functions for MealMind
class Calculations {
  /// Calculates waste quantity: prepared - consumed
  /// Clamps result to >= 0.0
  static double calculateWasteQuantity(double? prepared, double? consumed) {
    if (prepared == null || consumed == null) return 0.0;
    final waste = prepared - consumed;
    return waste < 0.0 ? 0.0 : double.parse(waste.toStringAsFixed(2));
  }

  /// Calculates waste percentage: (waste / prepared) * 100
  /// Handles zero division safely
  static double calculateWastePercentage(double? waste, double? prepared) {
    if (waste == null || prepared == null || prepared <= 0.0) return 0.0;
    final pct = (waste / prepared) * 100.0;
    return double.parse(pct.toStringAsFixed(2));
  }

  /// Calculates financial waste cost: waste * costPerUnit
  static double calculateWasteCost(double? waste, double? costPerUnit) {
    if (waste == null || costPerUnit == null || waste <= 0.0 || costPerUnit <= 0.0) {
      return 0.0;
    }
    final cost = waste * costPerUnit;
    return double.parse(cost.toStringAsFixed(2));
  }

  /// Calculates waste reduction percentage: ((prev - curr) / prev) * 100
  static double calculateWasteReduction(double? previousWaste, double? currentWaste) {
    if (previousWaste == null || currentWaste == null || previousWaste <= 0.0) {
      return 0.0;
    }
    final reduction = ((previousWaste - currentWaste) / previousWaste) * 100.0;
    return double.parse(reduction.toStringAsFixed(2));
  }

  /// Calculates potential financial savings: baselineCost - projectedCost
  static double calculatePotentialSavings(double? baselineCost, double? projectedCost) {
    if (baselineCost == null || projectedCost == null) return 0.0;
    final savings = baselineCost - projectedCost;
    return savings < 0.0 ? 0.0 : double.parse(savings.toStringAsFixed(2));
  }

  /// Estimates expected attendance using confirmations and historical adjustment
  static int calculateExpectedAttendance(
    int confirmations, {
    double historicalMultiplier = 1.05,
    int walkInOffset = 10,
  }) {
    if (confirmations <= 0) return 0;
    final expected = (confirmations * historicalMultiplier) + walkInOffset;
    return expected.round();
  }

  /// Evaluates waste severity against institution target threshold
  /// Returns 'normal' (Green), 'warning' (Yellow), or 'critical' (Red)
  static String evaluateWasteSeverity(double actualPct, double targetThresholdPct) {
    if (actualPct <= targetThresholdPct) {
      return 'normal';
    } else if (actualPct <= targetThresholdPct + 5.0) {
      return 'warning';
    } else {
      return 'critical';
    }
  }
}
