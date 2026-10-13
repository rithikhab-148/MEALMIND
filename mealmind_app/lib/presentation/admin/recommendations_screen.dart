import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/prediction_provider.dart';
import '../../widgets/recommendation_card.dart';
import '../../widgets/section_header.dart';

class RecommendationsScreen extends StatelessWidget {
  const RecommendationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final predProvider = Provider.of<PredictionProvider>(context);
    final recs = predProvider.recommendations;

    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Recommendations & Menu Matrix', style: TextStyle(fontWeight: FontWeight.w800)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 4-Quadrant Strategic Menu Matrix
            SectionHeader(
              title: 'Strategic Menu Optimization Matrix',
              subtitle: '4-quadrant food performance classification',
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
                children: [
                  _buildMatrixRow(
                    '⭐ Star Performers (High Rating • Low Waste)',
                    'Paneer Butter Masala (4.8★, 4.2% waste)\nMasala Dosa (4.6★, 5.1% waste)',
                    AppColors.normalGreen,
                  ),
                  const Divider(height: 20),
                  _buildMatrixRow(
                    '🐎 Workhorses (High Volume • Moderate Waste)',
                    'Steamed Basmati Rice (4.2★, 9.7% waste)\nChapati / Phulka (4.2★, 10.5% waste)',
                    AppColors.primary,
                  ),
                  const Divider(height: 20),
                  _buildMatrixRow(
                    '🔍 Portion Mismatch (High Rating • High Plate Waste)',
                    'South Indian Sambar (4.0★, 19.5% waste)\nAction: Reduce initial ladle serving volume.',
                    Colors.orange[800]!,
                  ),
                  const Divider(height: 20),
                  _buildMatrixRow(
                    '⚠️ Re-Evaluations (Low Rating • High Waste)',
                    'Mixed Vegetable Poriyal (2.8★, 27.9% waste)\nAction: Replace with Aloo Gobi or revamp seasoning.',
                    AppColors.criticalRed,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // AI Actionable Recommendations List
            SectionHeader(
              title: 'Actionable Kitchen Interventions',
              subtitle: 'Practical steps with estimated monthly financial savings',
            ),
            const SizedBox(height: 8),

            ...recs.map((rec) {
              return RecommendationCard(
                recommendation: rec,
                onToggleApplied: () => predProvider.toggleRecommendation(rec.id),
              );
            }),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildMatrixRow(String category, String items, Color color) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 4,
          height: 48,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(category, style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: color)),
              const SizedBox(height: 4),
              Text(items, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, height: 1.3)),
            ],
          ),
        ),
      ],
    );
  }
}
