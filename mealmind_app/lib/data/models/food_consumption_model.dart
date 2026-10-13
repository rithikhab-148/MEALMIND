import '../../core/utils/calculations.dart';

class FoodConsumptionModel {
  final String id;
  final String foodItem;
  final double preparedQuantity;
  final double consumedQuantity;
  final double remainingQuantity;
  final double wasteQuantity;
  final double wastePercentage;
  final String unit;
  final String date;
  final String mealType;
  final DateTime recordedAt;

  FoodConsumptionModel({
    required this.id,
    required this.foodItem,
    required this.preparedQuantity,
    required this.consumedQuantity,
    required this.remainingQuantity,
    required this.wasteQuantity,
    required this.wastePercentage,
    this.unit = 'kg',
    required this.date,
    required this.mealType,
    required this.recordedAt,
  });

  factory FoodConsumptionModel.create({
    required String id,
    required String foodItem,
    required double preparedQuantity,
    required double consumedQuantity,
    String unit = 'kg',
    required String date,
    required String mealType,
    DateTime? recordedAt,
  }) {
    final waste = Calculations.calculateWasteQuantity(preparedQuantity, consumedQuantity);
    final pct = Calculations.calculateWastePercentage(waste, preparedQuantity);
    final remaining = (preparedQuantity - consumedQuantity).clamp(0.0, double.infinity);

    return FoodConsumptionModel(
      id: id,
      foodItem: foodItem,
      preparedQuantity: preparedQuantity,
      consumedQuantity: consumedQuantity,
      remainingQuantity: remaining,
      wasteQuantity: waste,
      wastePercentage: pct,
      unit: unit,
      date: date,
      mealType: mealType,
      recordedAt: recordedAt ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'food_item': foodItem,
      'prepared_quantity': preparedQuantity,
      'consumed_quantity': consumedQuantity,
      'remaining_quantity': remainingQuantity,
      'waste_quantity': wasteQuantity,
      'waste_percentage': wastePercentage,
      'unit': unit,
      'date': date,
      'meal_type': mealType,
      'recorded_at': recordedAt.toIso8601String(),
    };
  }

  factory FoodConsumptionModel.fromMap(Map<String, dynamic> map) {
    return FoodConsumptionModel(
      id: map['id'] ?? '',
      foodItem: map['food_item'] ?? '',
      preparedQuantity: (map['prepared_quantity'] ?? 0.0).toDouble(),
      consumedQuantity: (map['consumed_quantity'] ?? 0.0).toDouble(),
      remainingQuantity: (map['remaining_quantity'] ?? 0.0).toDouble(),
      wasteQuantity: (map['waste_quantity'] ?? 0.0).toDouble(),
      wastePercentage: (map['waste_percentage'] ?? 0.0).toDouble(),
      unit: map['unit'] ?? 'kg',
      date: map['date'] ?? '',
      mealType: map['meal_type'] ?? 'Lunch',
      recordedAt: map['recorded_at'] != null
          ? DateTime.tryParse(map['recorded_at']) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}
