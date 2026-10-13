class MenuItemModel {
  final String id;
  final String date; // YYYY-MM-DD
  final String mealType; // Breakfast, Lunch, Snacks, Dinner
  final String foodItem;
  final double quantityPlanned;
  final double servingSizeGrams;
  final double costPerUnit;
  final String unit;
  final double averageRating;
  final int ratingCount;
  final bool isSpecialItem;

  MenuItemModel({
    required this.id,
    required this.date,
    required this.mealType,
    required this.foodItem,
    required this.quantityPlanned,
    this.servingSizeGrams = 200.0,
    required this.costPerUnit,
    this.unit = 'kg',
    this.averageRating = 4.0,
    this.ratingCount = 0,
    this.isSpecialItem = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date,
      'meal_type': mealType,
      'food_item': foodItem,
      'quantity_planned': quantityPlanned,
      'serving_size_grams': servingSizeGrams,
      'cost_per_unit': costPerUnit,
      'unit': unit,
      'average_rating': averageRating,
      'rating_count': ratingCount,
      'is_special_item': isSpecialItem,
    };
  }

  factory MenuItemModel.fromMap(Map<String, dynamic> map) {
    return MenuItemModel(
      id: map['id'] ?? '',
      date: map['date'] ?? '',
      mealType: map['meal_type'] ?? 'Lunch',
      foodItem: map['food_item'] ?? '',
      quantityPlanned: (map['quantity_planned'] ?? 0.0).toDouble(),
      servingSizeGrams: (map['serving_size_grams'] ?? 200.0).toDouble(),
      costPerUnit: (map['cost_per_unit'] ?? 0.0).toDouble(),
      unit: map['unit'] ?? 'kg',
      averageRating: (map['average_rating'] ?? 4.0).toDouble(),
      ratingCount: map['rating_count'] ?? 0,
      isSpecialItem: map['is_special_item'] ?? false,
    );
  }
}
