import 'package:flutter_test/flutter_test.dart';
import '../lib/core/utils/calculations.dart';
import '../lib/core/utils/environmental_factors.dart';

void main() {
  group('MealMind Calculations Unit Tests', () {
    test('calculateWasteQuantity handles normal and edge cases', () {
      expect(Calculations.calculateWasteQuantity(100.0, 85.0), 15.0);
      expect(Calculations.calculateWasteQuantity(100.0, 100.0), 0.0);
      expect(Calculations.calculateWasteQuantity(100.0, 110.0), 0.0); // Clamped >= 0
      expect(Calculations.calculateWasteQuantity(null, 50.0), 0.0);
    });

    test('calculateWastePercentage computes accurate percentage safely', () {
      expect(Calculations.calculateWastePercentage(20.0, 100.0), 20.0);
      expect(Calculations.calculateWastePercentage(15.5, 160.0), 9.69);
      expect(Calculations.calculateWastePercentage(0.0, 100.0), 0.0);
      expect(Calculations.calculateWastePercentage(10.0, 0.0), 0.0); // Zero division safe
      expect(Calculations.calculateWastePercentage(null, null), 0.0);
    });

    test('calculateWasteCost computes accurate monetary loss', () {
      expect(Calculations.calculateWasteCost(20.0, 50.0), 1000.0);
      expect(Calculations.calculateWasteCost(19.0, 55.0), 1045.0);
      expect(Calculations.calculateWasteCost(0.0, 45.0), 0.0);
      expect(Calculations.calculateWasteCost(null, 45.0), 0.0);
    });

    test('calculateWasteReduction computes reduction percentage', () {
      expect(Calculations.calculateWasteReduction(100.0, 80.0), 20.0);
      expect(Calculations.calculateWasteReduction(50.0, 50.0), 0.0);
      expect(Calculations.calculateWasteReduction(0.0, 10.0), 0.0);
    });

    test('calculatePotentialSavings computes difference safely', () {
      expect(Calculations.calculatePotentialSavings(50000.0, 30000.0), 20000.0);
      expect(Calculations.calculatePotentialSavings(20000.0, 30000.0), 0.0);
    });

    test('calculateExpectedAttendance estimates attendance with historical factor', () {
      expect(Calculations.calculateExpectedAttendance(500, historicalMultiplier: 1.05, walkInOffset: 10), 535);
      expect(Calculations.calculateExpectedAttendance(0), 0);
    });

    test('evaluateWasteSeverity returns correct severity levels', () {
      expect(Calculations.evaluateWasteSeverity(12.0, 15.0), 'normal');
      expect(Calculations.evaluateWasteSeverity(17.5, 15.0), 'warning');
      expect(Calculations.evaluateWasteSeverity(24.0, 15.0), 'critical');
    });

    test('EnvironmentalMetrics calculates correct carbon and water baselines', () {
      final metrics = EnvironmentalMetrics.fromFoodSaved(10.0);
      expect(metrics.foodSavedKg, 10.0);
      expect(metrics.co2AvoidedKg, 25.0); // 10 * 2.5
      expect(metrics.waterSavedLitres, 10000.0); // 10 * 1000
    });
  });
}
