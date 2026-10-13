import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

class WasteBadge extends StatelessWidget {
  final double wastePercentage;
  final double targetThreshold;
  final String? customLabel;
  final bool showIcon;

  const WasteBadge({
    super.key,
    required this.wastePercentage,
    this.targetThreshold = 15.0,
    this.customLabel,
    this.showIcon = true,
  });

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;
    IconData icon;
    String label;

    if (wastePercentage <= targetThreshold) {
      bg = AppColors.chipBackground;
      fg = AppColors.normalGreen;
      icon = Icons.check_circle_outline;
      label = customLabel ?? 'Normal (${wastePercentage.toStringAsFixed(1)}%)';
    } else if (wastePercentage <= targetThreshold + 5.0) {
      bg = const Color(0xFFFFF8E1);
      fg = AppColors.warningYellow;
      icon = Icons.warning_amber_rounded;
      label = customLabel ?? 'Warning (${wastePercentage.toStringAsFixed(1)}%)';
    } else {
      bg = const Color(0xFFFFEBEE);
      fg = AppColors.criticalRed;
      icon = Icons.error_outline;
      label = customLabel ?? 'Critical (${wastePercentage.toStringAsFixed(1)}%)';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: fg.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showIcon) ...[
            Icon(icon, size: 14, color: fg),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: fg,
            ),
          ),
        ],
      ),
    );
  }
}
