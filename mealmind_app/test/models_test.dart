import 'package:flutter_test/flutter_test.dart';
import '../lib/data/models/user_model.dart';
import '../lib/data/models/menu_item_model.dart';
import '../lib/data/models/meal_response_model.dart';
import '../lib/data/models/food_prep_model.dart';
import '../lib/data/models/food_consumption_model.dart';
import '../lib/data/models/food_waste_model.dart';
import '../lib/data/models/feedback_model.dart';
import '../lib/data/models/prediction_model.dart';

void main() {
  group('MealMind Data Models Unit Tests', () {
    test('UserModel serialization and role getters', () {
      final user = UserModel(
        id: 'u1',
        name: 'Admin User',
        email: 'admin@college.edu',
        role: 'admin',
        institutionId: 'inst1',
      );

      expect(user.isAdmin, true);
      expect(user.isStaff, false);
      expect(user.isStudent, false);

      final map = user.toMap();
      final fromMap = UserModel.fromMap(map);
      expect(fromMap.id, 'u1');
      expect(fromMap.name, 'Admin User');
      expect(fromMap.role, 'admin');
    });

    test('MenuItemModel serialization', () {
      final item = MenuItemModel(
        id: 'm1',
        date: '2026-08-27',
        mealType: 'Lunch',
        foodItem: 'Steamed Basmati Rice',
        quantityPlanned: 150.0,
        servingSizeGrams: 280.0,
        costPerUnit: 45.0,
      );

      final map = item.toMap();
      final fromMap = MenuItemModel.fromMap(map);
      expect(fromMap.foodItem, 'Steamed Basmati Rice');
      expect(fromMap.costPerUnit, 45.0);
      expect(fromMap.quantityPlanned, 150.0);
    });

    test('MealResponseModel RSVP logic', () {
      final rsvpYes = MealResponseModel(
        id: 'r1',
        studentId: 's1',
        studentName: 'Aditya',
        date: '2026-08-27',
        mealType: 'Lunch',
        response: 'YES',
        timestamp: DateTime.now(),
      );

      final rsvpNo = MealResponseModel(
        id: 'r2',
        studentId: 's1',
        studentName: 'Aditya',
        date: '2026-08-27',
        mealType: 'Lunch',
        response: 'NO',
        timestamp: DateTime.now(),
      );

      expect(rsvpYes.willAttend, true);
      expect(rsvpNo.willAttend, false);
    });

    test('FoodConsumptionModel auto-waste computation', () {
      final consumption = FoodConsumptionModel.create(
        id: 'c1',
        foodItem: 'Paneer Butter Masala',
        preparedQuantity: 80.0,
        consumedQuantity: 76.0,
        date: '2026-08-27',
        mealType: 'Lunch',
      );

      expect(consumption.wasteQuantity, 4.0);
      expect(consumption.wastePercentage, 5.0); // (4 / 80) * 100
      expect(consumption.remainingQuantity, 4.0);
    });

    test('FoodWasteModel cost calculation', () {
      final waste = FoodWasteModel.create(
        id: 'w1',
        foodItem: 'Mixed Vegetable Poriyal',
        wasteQuantity: 20.0,
        unit: 'kg',
        wasteType: 'Plate waste',
        wasteReason: 'Poor taste',
        date: '2026-08-27',
        mealType: 'Lunch',
        costPerUnit: 55.0,
        staffName: 'Chef Ramesh',
      );

      expect(waste.wasteCost, 1100.0); // 20 * 55
      expect(waste.wasteReason, 'Poor taste');
    });

    test('PredictionModel explainable factors parsing', () {
      final pred = PredictionModel(
        foodItem: 'Steamed Rice',
        mealType: 'Lunch',
        expectedAttendance: 500,
        mealConfirmations: 480,
        predictedConsumption: 144.0,
        recommendedPreparation: 150.0,
        confidenceScore: 94.0,
        explainableFactors: [
          ExplainableFactor(factor: 'RSVP Rate', value: '96%', impact: 'High Confidence'),
        ],
      );

      expect(pred.recommendedPreparation, 150.0);
      expect(pred.explainableFactors.first.factor, 'RSVP Rate');
      expect(pred.isAiEstimate, true);
    });
  });
}
