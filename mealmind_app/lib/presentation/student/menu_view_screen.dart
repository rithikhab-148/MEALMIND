import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_constants.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/formatters.dart';
import '../../providers/meal_provider.dart';

class MenuViewScreen extends StatefulWidget {
  const MenuViewScreen({super.key});

  @override
  State<MenuViewScreen> createState() => _MenuViewScreenState();
}

class _MenuViewScreenState extends State<MenuViewScreen> {
  String _selectedMeal = 'Lunch';

  @override
  Widget build(BuildContext context) {
    final mealProvider = Provider.of<MealProvider>(context);
    final items = mealProvider.getMenus(mealType: _selectedMeal);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Dining Hall Menu", style: TextStyle(fontWeight: FontWeight.w800)),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: AppConstants.mealTypes.map((meal) {
                final isSelected = _selectedMeal == meal;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ChoiceChip(
                    label: Text(meal),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) setState(() => _selectedMeal = meal);
                    },
                    selectedColor: AppColors.primary,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.chipBackground,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, color: AppColors.primary, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Menu for ${Formatters.formatDate(DateTime.now())} • $_selectedMeal session',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primary),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            if (items.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 40),
                  child: Text('No items scheduled for this meal slot yet.', style: TextStyle(color: AppColors.textSecondary)),
                ),
              )
            else
              ...items.map((item) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              item.foodItem,
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                            ),
                          ),
                          Row(
                            children: [
                              Icon(Icons.star, size: 16, color: Colors.amber[700]),
                              const SizedBox(width: 4),
                              Text(
                                '${item.averageRating} (${item.ratingCount})',
                                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          _buildDetailChip(Icons.scale_outlined, '${item.servingSizeGrams.toInt()}g portion'),
                          const SizedBox(width: 8),
                          _buildDetailChip(Icons.inventory_2_outlined, '${item.quantityPlanned} ${item.unit} prepared'),
                          if (item.isSpecialItem) ...[
                            const SizedBox(width: 8),
                            _buildDetailChip(Icons.auto_awesome, 'Chef Special', color: Colors.amber[800]),
                          ],
                        ],
                      ),
                    ],
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailChip(IconData icon, String text, {Color? color}) {
    final c = color ?? AppColors.textSecondary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: c.withOpacity(0.08),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: c),
          const SizedBox(width: 4),
          Text(text, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: c)),
        ],
      ),
    );
  }
}
