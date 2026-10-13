class FoodPrepModel {
  final String id;
  final String foodItem;
  final double quantityPrepared;
  final String unit;
  final String date; // YYYY-MM-DD
  final String mealType; // Breakfast, Lunch, Snacks, Dinner
  final DateTime prepTime;
  final String staffName;
  final String? batchNumber;
  final String? notes;

  FoodPrepModel({
    required this.id,
    required this.foodItem,
    required this.quantityPrepared,
    this.unit = 'kg',
    required this.date,
    required this.mealType,
    required this.prepTime,
    required this.staffName,
    this.batchNumber,
    this.notes,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'food_item': foodItem,
      'quantity_prepared': quantityPrepared,
      'unit': unit,
      'date': date,
      'meal_type': mealType,
      'prep_time': prepTime.toIso8601String(),
      'staff_name': staffName,
      'batch_number': batchNumber,
      'notes': notes,
    };
  }

  factory FoodPrepModel.fromMap(Map<String, dynamic> map) {
    return FoodPrepModel(
      id: map['id'] ?? '',
      foodItem: map['food_item'] ?? '',
      quantityPrepared: (map['quantity_prepared'] ?? 0.0).toDouble(),
      unit: map['unit'] ?? 'kg',
      date: map['date'] ?? '',
      mealType: map['meal_type'] ?? 'Lunch',
      prepTime: map['prep_time'] != null
          ? DateTime.tryParse(map['prep_time']) ?? DateTime.now()
          : DateTime.now(),
      staffName: map['staff_name'] ?? 'Staff',
      batchNumber: map['batch_number'],
      notes: map['notes'],
    );
  }
}
