import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../data/models/prediction_model.dart';
import '../../providers/prediction_provider.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/waste_badge.dart';

class StaffPredictionsScreen extends StatefulWidget {
  const StaffPredictionsScreen({super.key});

  @override
  State<StaffPredictionsScreen> createState() => _StaffPredictionsScreenState();
}

class _StaffPredictionsScreenState extends State<StaffPredictionsScreen> {
  String _selectedMeal = 'Lunch';

  void _showExplainabilityModal(PredictionModel pred) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'AI Factor Attribution: ${pred.foodItem}',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.chipBackground,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Confidence ${pred.confidenceScore}%',
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primary),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              const Text(
                'Factors mathematically influencing this kitchen prep recommendation:',
                style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 16),
              ...pred.explainableFactors.map((f) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.backgroundLight,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.analytics_outlined, size: 16, color: AppColors.primary),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(f.factor, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
                            Text(f.value, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                          ],
                        ),
                      ),
                      Text(
                        f.impact,
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.primary),
                      ),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 10),
              CustomButton(
                text: 'Close Breakdown',
                onPressed: () => Navigator.pop(ctx),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final predProvider = Provider.of<PredictionProvider>(context);
    final predictions = predProvider.predictions;

    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Food Demand Forecast', style: TextStyle(fontWeight: FontWeight.w800)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Forecast Context Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1B5E20), Color(0xFF2E7D32)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "TOMORROW'S LUNCH FORECAST",
                        style: TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.w700),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.white24,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text('AI MODEL ACTIVE', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Expected Turnout: 525 Students',
                    style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    '495 Confirmed via Student RSVP • 30 Historic Walk-in Buffer',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Recommended Preparation',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                ),
                if (predProvider.isForecasting)
                  const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
              ],
            ),
            const SizedBox(height: 10),

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
                        Text(
                          pred.foodItem,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                        ),
                        WasteBadge(
                          wastePercentage: pred.predictedWastePercentage,
                          customLabel: 'Predicted Waste: ${pred.predictedWastePercentage}% (${pred.predictedRiskLevel} Risk)',
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Target Prep Qty', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                              Text(
                                '${pred.recommendedPreparation} ${pred.unit}',
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.primary),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Est. Consumed', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                              Text(
                                '${pred.predictedConsumption} ${pred.unit}',
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    if (pred.actionableSuggestion != null) ...[
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFEBEE),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.tips_and_updates, color: AppColors.criticalRed, size: 16),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                pred.actionableSuggestion!,
                                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.criticalRed),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: 12),
                    InkWell(
                      onTap: () => _showExplainabilityModal(pred),
                      child: const Row(
                        children: [
                          Icon(Icons.info_outline, size: 14, color: AppColors.primary),
                          SizedBox(width: 4),
                          Text(
                            'Why this recommendation? (Explainable AI Factors)',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primary),
                          ),
                        ],
                      ),
                    ),
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
