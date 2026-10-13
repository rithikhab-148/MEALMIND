import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../data/models/recommendation_model.dart';

class RecommendationCard extends StatelessWidget {
  final RecommendationModel recommendation;
  final VoidCallback onToggleApplied;

  const RecommendationCard({
    super.key,
    required this.recommendation,
    required this.onToggleApplied,
  });

  @override
  Widget build(BuildContext context) {
    Color impactColor;
    if (recommendation.impactLevel == 'Critical') {
      impactColor = AppColors.criticalRed;
    } else if (recommendation.impactLevel == 'High') {
      impactColor = AppColors.tertiary;
    } else {
      impactColor = AppColors.secondary;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: recommendation.isApplied ? AppColors.normalGreen : AppColors.border,
          width: recommendation.isApplied ? 1.5 : 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: impactColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${recommendation.impactLevel.toUpperCase()} IMPACT',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: impactColor,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.chipBackground,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.savings_outlined, size: 13, color: AppColors.primary),
                    const SizedBox(width: 4),
                    Text(
                      'Save ${recommendation.estimatedSavingsMonthly}/mo',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            recommendation.title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            recommendation.description,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Target: ${recommendation.targetRole}',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textMuted,
                ),
              ),
              InkWell(
                onTap: onToggleApplied,
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: recommendation.isApplied
                        ? AppColors.normalGreen
                        : AppColors.backgroundLight,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: recommendation.isApplied
                          ? AppColors.normalGreen
                          : AppColors.border,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        recommendation.isApplied ? Icons.check : Icons.add_task,
                        size: 14,
                        color: recommendation.isApplied ? Colors.white : AppColors.textPrimary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        recommendation.isApplied ? 'Implemented' : 'Mark Implemented',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: recommendation.isApplied ? Colors.white : AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
