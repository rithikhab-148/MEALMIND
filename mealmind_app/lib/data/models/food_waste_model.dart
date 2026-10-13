import '../../core/utils/calculations.dart';

class FoodWasteModel {
  final String id;
  final String foodItem;
  final double wasteQuantity;
  final String unit;
  final String wasteType; // Preparation waste, Plate waste, Spoiled food, etc.
  final String wasteReason; // Excess preparation, Low attendance, Poor taste, etc.
  final String date;
  final String mealType;
  final double costPerUnit;
  final double wasteCost;
  final String? notes;
  final String staffName;
  final DateTime recordedAt;

  FoodWasteModel({
    required this.id,
    required this.foodItem,
    required this.wasteQuantity,
    this.unit = 'kg',
    required this.wasteType,
    required this.wasteReason,
    required this.date,
    required this.mealType,
    required this.costPerUnit,
    required this.wasteCost,
    this.notes,
    required this.staffName,
    required this.recordedAt,
  });

  factory FoodWasteModel.create({
    required String id,
    required String foodItem,
    required double wasteQuantity,
    String unit = 'kg',
    required String wasteType,
    required String wasteReason,
    required String date,
    required String mealType,
    required double costPerUnit,
    String? notes,
    required String staffName,
    DateTime? recordedAt,
  }) {
    final cost = Calculations.calculateWasteCost(wasteQuantity, costPerUnit);
    return FoodWasteModel(
      id: id,
      foodItem: foodItem,
      wasteQuantity: wasteQuantity,
      unit: unit,
      wasteType: wasteType,
      wasteReason: wasteReason,
      date: date,
      mealType: mealType,
      costPerUnit: costPerUnit,
      wasteCost: cost,
      notes: notes,
      staffName: staffName,
      recordedAt: recordedAt ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'food_item': foodItem,
      'waste_quantity': wasteQuantity,
      'unit': unit,
      'waste_type': wasteType,
      'waste_reason': wasteReason,
      'date': date,
      'meal_type': mealType,
      'cost_per_unit': costPerUnit,
      'waste_cost': wasteCost,
      'notes': notes,
      'staff_name': staffName,
      'recorded_at': recordedAt.toIso8601String(),
    };
  }

  factory FoodWasteModel.fromMap(Map<String, dynamic> map) {
    return FoodWasteModel(
      id: map['id'] ?? '',
      foodItem: map['food_item'] ?? '',
      wasteQuantity: (map['waste_quantity'] ?? 0.0).toDouble(),
      unit: map['unit'] ?? 'kg',
      wasteType: map['waste_type'] ?? 'Plate waste',
      wasteReason: map['waste_reason'] ?? 'Excess preparation',
      date: map['date'] ?? '',
      mealType: map['meal_type'] ?? 'Lunch',
      costPerUnit: (map['cost_per_unit'] ?? 40.0).toDouble(),
      wasteCost: (map['waste_cost'] ?? 0.0).toDouble(),
      notes: map['notes'],
      staffName: map['staff_name'] ?? 'Staff',
      recordedAt: map['recorded_at'] != null
          ? DateTime.tryParse(map['recorded_at']) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}
