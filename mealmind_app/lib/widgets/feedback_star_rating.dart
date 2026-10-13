import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

class FeedbackStarRating extends StatelessWidget {
  final String title;
  final double rating;
  final void Function(double) onRatingChanged;
  final String? lowLabel;
  final String? highLabel;

  const FeedbackStarRating({
    super.key,
    required this.title,
    required this.rating,
    required this.onRatingChanged,
    this.lowLabel = 'Poor',
    this.highLabel = 'Excellent',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                '${rating.toStringAsFixed(1)} / 5.0',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              final starIndex = index + 1;
              return IconButton(
                onPressed: () => onRatingChanged(starIndex.toDouble()),
                icon: Icon(
                  starIndex <= rating ? Icons.star_rounded : Icons.star_outline_rounded,
                  color: starIndex <= rating ? Colors.amber[700] : AppColors.textMuted,
                  size: 32,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 4),
                constraints: const BoxConstraints(),
              );
            }),
          ),
          if (lowLabel != null && highLabel != null) ...[
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(lowLabel!, style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
                Text(highLabel!, style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
