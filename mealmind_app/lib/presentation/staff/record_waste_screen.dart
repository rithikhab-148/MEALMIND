import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../core/constants/app_constants.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/formatters.dart';
import '../../data/models/food_waste_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/waste_provider.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

class RecordWasteScreen extends StatefulWidget {
  const RecordWasteScreen({super.key});

  @override
  State<RecordWasteScreen> createState() => _RecordWasteScreenState();
}

class _RecordWasteScreenState extends State<RecordWasteScreen> {
  final _formKey = GlobalKey<FormState>();
  String _selectedFoodItem = 'Mixed Vegetable Poriyal';
  String _selectedMeal = 'Lunch';
  String _selectedWasteType = 'Plate waste';
  String _selectedWasteReason = 'Poor taste';
  String _selectedUnit = 'kg';

  final _qtyController = TextEditingController(text: '19.0');
  final _costPerUnitController = TextEditingController(text: '55.0');
  final _notesController = TextEditingController(text: 'Vegetables were reported overly salty, leading to high plate scrapings');
  bool _isLoading = false;

  void _handleRecordWaste() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final wasteProvider = Provider.of<WasteProvider>(context, listen: false);

    final qty = double.tryParse(_qtyController.text) ?? 0.0;
    final cost = double.tryParse(_costPerUnitController.text) ?? 40.0;

    final waste = FoodWasteModel.create(
      id: const Uuid().v4(),
      foodItem: _selectedFoodItem,
      wasteQuantity: qty,
      unit: _selectedUnit,
      wasteType: _selectedWasteType,
      wasteReason: _selectedWasteReason,
      date: DateTime.now().toIso8601String().substring(0, 10),
      mealType: _selectedMeal,
      costPerUnit: cost,
      notes: _notesController.text.trim().isNotEmpty ? _notesController.text.trim() : null,
      staffName: authProvider.currentUser?.name ?? 'Chef Staff',
    );

    wasteProvider.recordWaste(waste);
    await Future.delayed(const Duration(milliseconds: 400));
    setState(() => _isLoading = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Logged ${waste.wasteQuantity} ${waste.unit} waste of ${waste.foodItem} (${Formatters.formatCurrency(waste.wasteCost)} loss)'),
          backgroundColor: AppColors.criticalRed,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final qty = double.tryParse(_qtyController.text) ?? 0.0;
    final costPerUnit = double.tryParse(_costPerUnitController.text) ?? 0.0;
    final estimatedLoss = qty * costPerUnit;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Record Food Waste & Reason', style: TextStyle(fontWeight: FontWeight.w800)),
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
                    const Text('Categorized Waste Entry', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 14),

                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Meal Type', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
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
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Waste Type', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                              const SizedBox(height: 6),
                              DropdownButtonFormField<String>(
                                value: _selectedWasteType,
                                decoration: const InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10)),
                                items: AppConstants.wasteTypes.map((t) => DropdownMenuItem(value: t, child: Text(t, style: const TextStyle(fontSize: 13)))).toList(),
                                onChanged: (v) => setState(() => _selectedWasteType = v!),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Waste Reason', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                              const SizedBox(height: 6),
                              DropdownButtonFormField<String>(
                                value: _selectedWasteReason,
                                decoration: const InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10)),
                                items: AppConstants.wasteReasons.map((r) => DropdownMenuItem(value: r, child: Text(r, style: const TextStyle(fontSize: 13)))).toList(),
                                onChanged: (v) => setState(() => _selectedWasteReason = v!),
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
                            label: 'Wasted Quantity',
                            controller: _qtyController,
                            keyboardType: TextInputType.number,
                            onChanged: (_) => setState(() {}),
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
                      label: 'Food Cost Per Unit (₹)',
                      controller: _costPerUnitController,
                      keyboardType: TextInputType.number,
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: 12),

                    CustomTextField(
                      label: 'Staff Observation / Root Cause Notes',
                      controller: _notesController,
                      maxLines: 2,
                    ),
                    const SizedBox(height: 16),

                    // Financial Loss Card
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF3E0),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.orange[300]!),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Estimated Financial Loss:', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                          Text(
                            Formatters.formatCurrency(estimatedLoss),
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.orange[900]),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    CustomButton(
                      text: 'Submit Waste Record',
                      icon: Icons.delete_outline,
                      backgroundColor: AppColors.criticalRed,
                      onPressed: _handleRecordWaste,
                      isLoading: _isLoading,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
