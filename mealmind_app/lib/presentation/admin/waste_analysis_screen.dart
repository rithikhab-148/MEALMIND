import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/analytics_provider.dart';
import '../../widgets/custom_chart.dart';
import '../../widgets/section_header.dart';

class WasteAnalysisScreen extends StatelessWidget {
  const WasteAnalysisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final analytics = Provider.of<AnalyticsProvider>(context);
    final reasons = analytics.getWasteReasonDistribution();
    final foodWaste = analytics.getFoodWiseWaste();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Waste Breakdown & Reasons', style: TextStyle(fontWeight: FontWeight.w800)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Waste Reasons Donut Chart
            SectionHeader(
              title: 'Primary Waste Reasons',
              subtitle: 'Identified root causes from kitchen staff logs',
            ),
            const SizedBox(height: 8),

            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: WasteReasonDonutChart(reasonData: reasons),
            ),
            const SizedBox(height: 20),

            // Food-Wise Waste Volume Matrix
            SectionHeader(
              title: 'Food-Item Waste Distribution (kg)',
              subtitle: 'Top wasted ingredients this week',
            ),
            const SizedBox(height: 8),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: foodWaste.entries.map((entry) {
                  final double pct = (entry.value / 62.0).clamp(0.0, 1.0);
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(entry.key, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                            Text('${entry.value} kg (${(pct * 100).toStringAsFixed(0)}%)', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                          ],
                        ),
                        const SizedBox(height: 6),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: pct,
                            backgroundColor: Colors.grey[200],
                            valueColor: AlwaysStoppedAnimation<Color>(
                              pct > 0.25 ? AppColors.criticalRed : (pct > 0.15 ? AppColors.warningYellow : AppColors.primary),
                            ),
                            minHeight: 8,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),

            // Meal Session Comparison Card
            SectionHeader(
              title: 'Meal-Wise Waste Breakdown',
              subtitle: 'Distribution across daily meal timings',
            ),
            const SizedBox(height: 8),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: const Column(
                children: [
                  _MealRow('Breakfast (7:30 AM - 9:30 AM)', '12.0 kg', '19.3%', AppColors.secondary),
                  Divider(height: 20),
                  _MealRow('Lunch (12:30 PM - 2:30 PM)', '36.5 kg', '58.8%', AppColors.criticalRed),
                  Divider(height: 20),
                  _MealRow('Snacks (4:30 PM - 5:45 PM)', '4.0 kg', '6.5%', AppColors.normalGreen),
                  Divider(height: 20),
                  _MealRow('Dinner (7:30 PM - 9:30 PM)', '9.5 kg', '15.4%', AppColors.warningYellow),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _MealRow extends StatelessWidget {
  final String meal;
  final String weight;
  final String share;
  final Color color;

  const _MealRow(this.meal, this.weight, this.share, this.color);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: Text(meal, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600))),
        Text(weight, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
        const SizedBox(width: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: color.withOpacity(0.12),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(share, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: color)),
        ),
      ],
    );
  }
}
