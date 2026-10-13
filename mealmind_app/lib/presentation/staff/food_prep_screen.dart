import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../core/constants/app_constants.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/formatters.dart';
import '../../data/models/food_prep_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/waste_provider.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

class FoodPrepScreen extends StatefulWidget {
  const FoodPrepScreen({super.key});

  @override
  State<FoodPrepScreen> createState() => _FoodPrepScreenState();
}

class _FoodPrepScreenState extends State<FoodPrepScreen> {
  final _formKey = GlobalKey<FormState>();
  String _selectedFoodItem = 'Steamed Basmati Rice';
  String _selectedMeal = 'Lunch';
  String _selectedUnit = 'kg';
  final _qtyController = TextEditingController(text: '160');
  final _batchController = TextEditingController(text: 'B1-LUNCH');
  final _notesController = TextEditingController();
  bool _isLoading = false;

  void _handleSavePrep() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final wasteProvider = Provider.of<WasteProvider>(context, listen: false);

    final log = FoodPrepModel(
      id: const Uuid().v4(),
      foodItem: _selectedFoodItem,
      quantityPrepared: double.tryParse(_qtyController.text) ?? 100.0,
      unit: _selectedUnit,
      date: DateTime.now().toIso8601String().substring(0, 10),
      mealType: _selectedMeal,
      prepTime: DateTime.now(),
      staffName: authProvider.currentUser?.name ?? 'Chef Staff',
      batchNumber: _batchController.text.trim(),
      notes: _notesController.text.trim().isNotEmpty ? _notesController.text.trim() : null,
    );

    wasteProvider.addPrepLog(log);
    await Future.delayed(const Duration(milliseconds: 400));
    setState(() => _isLoading = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Logged ${log.quantityPrepared} ${log.unit} of ${log.foodItem} prepared!'),
          backgroundColor: AppColors.normalGreen,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final wasteProvider = Provider.of<WasteProvider>(context);
    final recentLogs = wasteProvider.getPrepLogs(mealType: _selectedMeal);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Food Preparation Log', style: TextStyle(fontWeight: FontWeight.w800)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('New Preparation Entry', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 14),

                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Meal Session', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                              const SizedBox(height: 6),
                              DropdownButtonFormField<String>(
                                value: _selectedMeal,
                                decoration: const InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10)),
                                items: AppConstants.mealTypes.map((m) => DropdownMenuItem(value: m, child: Text(m))).toList(),
                                onChanged: (v) => setState(() => _selectedMeal = v!),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Food Item', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                              const SizedBox(height: 6),
                              DropdownButtonFormField<String>(
                                value: _selectedFoodItem,
                                decoration: const InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10)),
                                items: [
                                  'Steamed Basmati Rice',
                                  'South Indian Sambar',
                                  'Paneer Butter Masala',
                                  'Mixed Vegetable Poriyal',
                                  'Fresh Set Curd',
                                  'Idli & Sambar',
                                  'Jeera Rice & Dal Makhani',
                                ].map((item) => DropdownMenuItem(value: item, child: Text(item, overflow: TextOverflow.ellipsis))).toList(),
                                onChanged: (v) => setState(() => _selectedFoodItem = v!),
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
                          flex: 2,
                          child: CustomTextField(
                            label: 'Quantity Prepared',
                            hint: '100',
                            controller: _qtyController,
                            keyboardType: TextInputType.number,
                            validator: (v) => v == null || v.isEmpty ? 'Quantity required' : null,
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
                                value: _selectedUnit,
                                decoration: const InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10)),
                                items: AppConstants.units.map((u) => DropdownMenuItem(value: u, child: Text(u))).toList(),
                                onChanged: (v) => setState(() => _selectedUnit = v!),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    CustomTextField(
                      label: 'Batch ID / Kitchen Station',
                      hint: 'e.g. B1-LUNCH',
                      controller: _batchController,
                    ),
                    const SizedBox(height: 12),

                    CustomTextField(
                      label: 'Kitchen Notes (Optional)',
                      hint: 'e.g. Prepared extra 10kg due to college sports event visit',
                      controller: _notesController,
                      maxLines: 2,
                    ),
                    const SizedBox(height: 16),

                    CustomButton(
                      text: 'Record Batch Preparation',
                      icon: Icons.save_outlined,
                      onPressed: _handleSavePrep,
                      isLoading: _isLoading,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              const Text("Today's Recorded Prep Batches", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),

              ...recentLogs.map((log) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.chipBackground,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.soup_kitchen, color: AppColors.primary, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(log.foodItem, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                            const SizedBox(height: 2),
                            Text(
                              'Batch ${log.batchNumber ?? "N/A"} • ${Formatters.formatTime(log.prepTime)} • ${log.staffName}',
                              style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '${log.quantityPrepared} ${log.unit}',
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.primary),
                      ),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
