import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../core/constants/app_constants.dart';
import '../../core/constants/app_colors.dart';
import '../../data/models/menu_item_model.dart';
import '../../providers/meal_provider.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

class MenuManagementScreen extends StatefulWidget {
  const MenuManagementScreen({super.key});

  @override
  State<MenuManagementScreen> createState() => _MenuManagementScreenState();
}

class _MenuManagementScreenState extends State<MenuManagementScreen> {
  String _selectedMeal = 'Lunch';

  void _showAddEditDialog({MenuItemModel? existingItem}) {
    final nameController = TextEditingController(text: existingItem?.foodItem ?? '');
    final qtyController = TextEditingController(text: existingItem?.quantityPlanned.toString() ?? '100');
    final servingController = TextEditingController(text: existingItem?.servingSizeGrams.toString() ?? '200');
    final costController = TextEditingController(text: existingItem?.costPerUnit.toString() ?? '45');
    String unit = existingItem?.unit ?? 'kg';
    bool isSpecial = existingItem?.isSpecialItem ?? false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      existingItem != null ? 'Edit Menu Item' : 'Add Menu Item',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      label: 'Food Item Name',
                      hint: 'e.g. Paneer Butter Masala',
                      controller: nameController,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            label: 'Planned Quantity',
                            hint: '100',
                            controller: qtyController,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Unit', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                              const SizedBox(height: 6),
                              DropdownButtonFormField<String>(
                                value: unit,
                                decoration: const InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10)),
                                items: AppConstants.units.map((u) => DropdownMenuItem(value: u, child: Text(u))).toList(),
                                onChanged: (v) => setModalState(() => unit = v!),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            label: 'Serving Size (g/ml)',
                            hint: '200',
                            controller: servingController,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: CustomTextField(
                            label: 'Cost per Unit (₹)',
                            hint: '45',
                            controller: costController,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    CheckboxListTile(
                      title: const Text('Chef Special Dish', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                      value: isSpecial,
                      onChanged: (v) => setModalState(() => isSpecial = v ?? false),
                      contentPadding: EdgeInsets.zero,
                      activeColor: AppColors.primary,
                    ),
                    const SizedBox(height: 16),
                    CustomButton(
                      text: existingItem != null ? 'Save Changes' : 'Add to Menu',
                      onPressed: () {
                        final mealProvider = Provider.of<MealProvider>(context, listen: false);
                        if (existingItem != null) {
                          mealProvider.updateMenuItem(
                            MenuItemModel(
                              id: existingItem.id,
                              date: existingItem.date,
                              mealType: _selectedMeal,
                              foodItem: nameController.text.trim(),
                              quantityPlanned: double.tryParse(qtyController.text) ?? 100.0,
                              servingSizeGrams: double.tryParse(servingController.text) ?? 200.0,
                              costPerUnit: double.tryParse(costController.text) ?? 45.0,
                              unit: unit,
                              isSpecialItem: isSpecial,
                              averageRating: existingItem.averageRating,
                              ratingCount: existingItem.ratingCount,
                            ),
                          );
                        } else {
                          mealProvider.addMenuItem(
                            MenuItemModel(
                              id: const Uuid().v4(),
                              date: DateTime.now().toIso8601String().substring(0, 10),
                              mealType: _selectedMeal,
                              foodItem: nameController.text.trim(),
                              quantityPlanned: double.tryParse(qtyController.text) ?? 100.0,
                              servingSizeGrams: double.tryParse(servingController.text) ?? 200.0,
                              costPerUnit: double.tryParse(costController.text) ?? 45.0,
                              unit: unit,
                              isSpecialItem: isSpecial,
                            ),
                          );
                        }
                        Navigator.pop(ctx);
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final mealProvider = Provider.of<MealProvider>(context);
    final items = mealProvider.getMenus(mealType: _selectedMeal);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu Management', style: TextStyle(fontWeight: FontWeight.w800)),
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
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            item.foodItem,
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                          ),
                          if (item.isSpecialItem) ...[
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.amber[100],
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text('SPECIAL', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.amber[900])),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Planned: ${item.quantityPlanned} ${item.unit} • Serving: ${item.servingSizeGrams.toInt()}g • ₹${item.costPerUnit}/${item.unit}',
                        style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit_outlined, size: 20, color: AppColors.primary),
                  onPressed: () => _showAddEditDialog(existingItem: item),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, size: 20, color: AppColors.criticalRed),
                  onPressed: () => mealProvider.deleteMenuItem(item.id),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddEditDialog(),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Add Dish', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
