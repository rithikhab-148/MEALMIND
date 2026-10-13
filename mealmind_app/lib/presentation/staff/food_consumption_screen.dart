import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../core/constants/app_constants.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/calculations.dart';
import '../../data/models/food_consumption_model.dart';
import '../../providers/waste_provider.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/waste_badge.dart';

class FoodConsumptionScreen extends StatefulWidget {
  const FoodConsumptionScreen({super.key});

  @override
  State<FoodConsumptionScreen> createState() => _FoodConsumptionScreenState();
}

class _FoodConsumptionScreenState extends State<FoodConsumptionScreen> {
  final _formKey = GlobalKey<FormState>();
  String _selectedFoodItem = 'Steamed Basmati Rice';
  String _selectedMeal = 'Lunch';
  String _selectedUnit = 'kg';

  final _prepQtyController = TextEditingController(text: '160');
  final _consumedQtyController = TextEditingController(text: '144.5');

  double _wasteQty = 15.5;
  double _wastePct = 9.7;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _recalculate();
  }

  void _recalculate() {
    final prep = double.tryParse(_prepQtyController.text) ?? 0.0;
    final cons = double.tryParse(_consumedQtyController.text) ?? 0.0;
    final waste = Calculations.calculateWasteQuantity(prep, cons);
    final pct = Calculations.calculateWastePercentage(waste, prep);

    setState(() {
      _wasteQty = waste;
      _wastePct = pct;
    });
  }

  void _handleSaveConsumption() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final wasteProvider = Provider.of<WasteProvider>(context, listen: false);

    final log = FoodConsumptionModel.create(
      id: const Uuid().v4(),
      foodItem: _selectedFoodItem,
      preparedQuantity: double.tryParse(_prepQtyController.text) ?? 0.0,
      consumedQuantity: double.tryParse(_consumedQtyController.text) ?? 0.0,
      unit: _selectedUnit,
      date: DateTime.now().toIso8601String().substring(0, 10),
      mealType: _selectedMeal,
    );

    wasteProvider.recordConsumption(log);
    await Future.delayed(const Duration(milliseconds: 400));
    setState(() => _isLoading = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Recorded consumption for ${log.foodItem}: Waste is ${log.wastePercentage}%'),
          backgroundColor: log.wastePercentage > 15.0 ? AppColors.criticalRed : AppColors.normalGreen,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final wasteProvider = Provider.of<WasteProvider>(context);
    final logs = wasteProvider.getConsumptionLogs(mealType: _selectedMeal);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Food Consumption & Auto-Waste', style: TextStyle(fontWeight: FontWeight.w800)),
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
                    const Text('Post-Meal Consumption Recording', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
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
                          child: CustomTextField(
                            label: 'Prepared Quantity',
                            controller: _prepQtyController,
                            keyboardType: TextInputType.number,
                            onChanged: (_) => _recalculate(),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: CustomTextField(
                            label: 'Consumed Quantity',
                            controller: _consumedQtyController,
                            keyboardType: TextInputType.number,
                            onChanged: (_) => _recalculate(),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Automatic Real-Time Calculation Feedback
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.backgroundLight,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Auto-Calculated Waste Quantity:', style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                              Text(
                                '$_wasteQty $_selectedUnit',
                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Calculated Waste %:', style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                              WasteBadge(wastePercentage: _wastePct, targetThreshold: 15.0),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    CustomButton(
                      text: 'Save Consumption Record',
                      icon: Icons.check_circle_outline,
                      onPressed: _handleSaveConsumption,
                      isLoading: _isLoading,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              const Text("Today's Consumptions & Waste Log", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),

              ...logs.map((log) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(log.foodItem, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                          const SizedBox(height: 2),
                          Text(
                            'Prep: ${log.preparedQuantity} | Consumed: ${log.consumedQuantity} ${log.unit}',
                            style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${log.wasteQuantity} ${log.unit} waste',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: log.wastePercentage > 15 ? AppColors.criticalRed : AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          WasteBadge(wastePercentage: log.wastePercentage, targetThreshold: 15.0, showIcon: false),
                        ],
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
