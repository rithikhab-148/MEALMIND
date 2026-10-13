import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../data/models/prediction_model.dart';
import '../../providers/prediction_provider.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/waste_badge.dart';

class AiPredictionsAdminScreen extends StatelessWidget {
  const AiPredictionsAdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final predProvider = Provider.of<PredictionProvider>(context);
    final predictions = predProvider.predictions;

    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Demand & Waste Forecasts', style: TextStyle(fontWeight: FontWeight.w800)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.chipBackground,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.primary.withOpacity(0.3)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.smart_toy_outlined, color: AppColors.primary, size: 28),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'AI models evaluate 12 features including historical intake, student RSVPs, dish satisfaction ratings, and calendar events.',
                      style: TextStyle(fontSize: 12, color: AppColors.textPrimary, height: 1.3),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Tomorrow\'s Item Predictions', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
                TextButton.icon(
                  onPressed: () {
                    predProvider.runDemandForecastForMenu(
                      foodItems: ['Steamed Basmati Rice', 'South Indian Sambar', 'Paneer Butter Masala', 'Mixed Vegetable Poriyal'],
                      mealType: 'Lunch',
                      expectedAttendance: 525,
                      confirmations: 495,
                    );
                  },
                  icon: const Icon(Icons.refresh, size: 16),
                  label: const Text('Rerun ML Model'),
                ),
              ],
            ),
            const SizedBox(height: 8),

            ...predictions.map((pred) {
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: pred.exceedsThreshold ? AppColors.criticalRed.withOpacity(0.4) : AppColors.border,
                    width: pred.exceedsThreshold ? 1.5 : 1.0,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(pred.foodItem, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                        WasteBadge(
                          wastePercentage: pred.predictedWastePercentage,
                          customLabel: '${pred.predictedWastePercentage}% (${pred.predictedRiskLevel} Risk)',
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: Text('Target Prep: ${pred.recommendedPreparation} ${pred.unit}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.primary)),
                        ),
                        Expanded(
                          child: Text('Est. Intake: ${pred.predictedConsumption} ${pred.unit}', style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      pred.alertMessage ?? 'Optimal forecast',
                      style: TextStyle(
                        fontSize: 12,
                        color: pred.exceedsThreshold ? AppColors.criticalRed : AppColors.textSecondary,
                        fontWeight: pred.exceedsThreshold ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                    if (pred.actionableSuggestion != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        '💡 Recommendation: ${pred.actionableSuggestion}',
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primary),
                      ),
                    ],
                  ],
                ),
              );
            }),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
