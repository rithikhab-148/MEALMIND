import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../core/constants/app_colors.dart';

class WasteTrendLineChart extends StatelessWidget {
  final List<double> dataPoints;
  final List<String> labels;
  final String unit;

  const WasteTrendLineChart({
    super.key,
    required this.dataPoints,
    required this.labels,
    this.unit = 'kg',
  });

  @override
  Widget build(BuildContext context) {
    if (dataPoints.isEmpty) {
      return const Center(child: Text('No trend data available'));
    }

    final maxY = dataPoints.reduce((a, b) => a > b ? a : b) * 1.25;

    return AspectRatio(
      aspectRatio: 1.7,
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: (maxY / 4).clamp(1.0, 100.0),
            getDrawingHorizontalLine: (value) => const FlLine(
              color: AppColors.divider,
              strokeWidth: 1,
            ),
          ),
          titlesData: FlTitlesData(
            show: true,
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                interval: 1,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index >= 0 && index < labels.length) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        labels[index],
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w600,
                          fontSize: 11,
                        ),
                      ),
                    );
                  }
                  return const Text('');
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (value, meta) {
                  return Text(
                    '${value.toInt()}$unit',
                    style: const TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 10,
                    ),
                  );
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          minX: 0,
          maxX: (dataPoints.length - 1).toDouble(),
          minY: 0,
          maxY: maxY < 10 ? 10 : maxY,
          lineBarsData: [
            LineChartBarData(
              spots: List.generate(
                dataPoints.length,
                (i) => FlSpot(i.toDouble(), dataPoints[i]),
              ),
              isCurved: true,
              color: AppColors.primary,
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
                  radius: 4,
                  color: Colors.white,
                  strokeWidth: 2.5,
                  strokeColor: AppColors.primary,
                ),
              ),
              belowBarData: BarAreaData(
                show: true,
                color: AppColors.primary.withOpacity(0.12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WasteReasonDonutChart extends StatelessWidget {
  final Map<String, double> reasonData;

  const WasteReasonDonutChart({
    super.key,
    required this.reasonData,
  });

  @override
  Widget build(BuildContext context) {
    final colors = [
      AppColors.primary,
      AppColors.secondary,
      AppColors.warningYellow,
      AppColors.criticalRed,
      const Color(0xFF5C6BC0),
    ];

    final entries = reasonData.entries.toList();

    return Column(
      children: [
        SizedBox(
          height: 180,
          child: PieChart(
            PieChartData(
              sectionsSpace: 3,
              centerSpaceRadius: 40,
              sections: List.generate(entries.length, (i) {
                final color = colors[i % colors.length];
                return PieChartSectionData(
                  color: color,
                  value: entries[i].value,
                  title: '${entries[i].value.toInt()}%',
                  radius: 45,
                  titleStyle: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                );
              }),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 8,
          children: List.generate(entries.length, (i) {
            final color = colors[i % colors.length];
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
                const SizedBox(width: 6),
                Text(
                  entries[i].key,
                  style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                ),
              ],
            );
          }),
        ),
      ],
    );
  }
}
