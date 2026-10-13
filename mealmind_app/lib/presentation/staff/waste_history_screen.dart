import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/formatters.dart';
import '../../providers/waste_provider.dart';

class WasteHistoryScreen extends StatefulWidget {
  const WasteHistoryScreen({super.key});

  @override
  State<WasteHistoryScreen> createState() => _WasteHistoryScreenState();
}

class _WasteHistoryScreenState extends State<WasteHistoryScreen> {
  String? _selectedMealFilter;
  String? _selectedTypeFilter;

  @override
  Widget build(BuildContext context) {
    final wasteProvider = Provider.of<WasteProvider>(context);
    final logs = wasteProvider.getWasteLogs(
      mealType: _selectedMealFilter,
      wasteType: _selectedTypeFilter,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Food Waste Log History', style: TextStyle(fontWeight: FontWeight.w800)),
      ),
      body: Column(
        children: [
          // Filter Row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String?>(
                    value: _selectedMealFilter,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      hintText: 'All Meals',
                    ),
                    items: [
                      const DropdownMenuItem(value: null, child: Text('All Meals')),
                      ...['Breakfast', 'Lunch', 'Snacks', 'Dinner']
                          .map((m) => DropdownMenuItem(value: m, child: Text(m))),
                    ],
                    onChanged: (v) => setState(() => _selectedMealFilter = v),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: DropdownButtonFormField<String?>(
                    value: _selectedTypeFilter,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      hintText: 'All Types',
                    ),
                    items: [
                      const DropdownMenuItem(value: null, child: Text('All Types')),
                      ...['Plate waste', 'Leftover food', 'Spoiled food', 'Overproduction']
                          .map((t) => DropdownMenuItem(value: t, child: Text(t, overflow: TextOverflow.ellipsis))),
                    ],
                    onChanged: (v) => setState(() => _selectedTypeFilter = v),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: logs.isEmpty
                ? const Center(child: Text('No waste records matching filters.', style: TextStyle(color: AppColors.textSecondary)))
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: logs.length,
                    itemBuilder: (context, index) {
                      final item = logs[index];
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
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFFEBEE),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    Formatters.formatCurrency(item.wasteCost),
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.criticalRed,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              '${item.wasteQuantity} ${item.unit} • ${item.wasteType} • Reason: ${item.wasteReason}',
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
                            ),
                            if (item.notes != null) ...[
                              const SizedBox(height: 6),
                              Text(
                                'Note: "${item.notes}"',
                                style: const TextStyle(fontSize: 11, fontStyle: FontStyle.italic, color: AppColors.textMuted),
                              ),
                            ],
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Logged by ${item.staffName}',
                                  style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                                ),
                                Text(
                                  '${item.mealType} • ${Formatters.formatTime(item.recordedAt)}',
                                  style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
