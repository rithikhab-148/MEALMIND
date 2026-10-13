import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/analytics_provider.dart';
import '../../widgets/custom_chart.dart';
import '../../widgets/section_header.dart';
import 'waste_analysis_screen.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  String _selectedRange = 'Weekly';

  @override
  Widget build(BuildContext context) {
    final analytics = Provider.of<AnalyticsProvider>(context);

    List<String> labels;
    if (_selectedRange == 'Daily') {
      labels = ['Breakfast', 'Lunch', 'Snacks', 'Dinner'];
    } else if (_selectedRange == 'Weekly') {
      labels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    } else {
      labels = ['Week 1', 'Week 2', 'Week 3', 'Week 4'];
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Waste & Attendance Analytics', style: TextStyle(fontWeight: FontWeight.w800)),
        actions: [
          IconButton(
            icon: const Icon(Icons.pie_chart_outline),
            tooltip: 'Waste Reasons',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const WasteAnalysisScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Time Horizon Segmented Filter
            Row(
              children: ['Daily', 'Weekly', 'Monthly'].map((range) {
                final isSelected = _selectedRange == range;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ChoiceChip(
                      label: Center(child: Text(range)),
                      selected: isSelected,
                      onSelected: (selected) {
                        if (selected) {
                          setState(() => _selectedRange = range);
                          analytics.setTimeRange(range);
                        }
                      },
                      selectedColor: AppColors.primary,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : AppColors.textPrimary,
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),

            // Food Waste Volume Trend Chart
            SectionHeader(
              title: '$_selectedRange Waste Trend (kg)',
              subtitle: 'Aggregate food waste recorded across all dining sessions',
            ),
            const SizedBox(height: 8),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: WasteTrendLineChart(
                dataPoints: analytics.getDailyWasteTrend(),
                labels: labels,
                unit: 'kg',
              ),
            ),
            const SizedBox(height: 20),

            // Student Attendance & Turnout Correlation
            SectionHeader(
              title: 'Attendance & RSVP Correlation',
              subtitle: 'Expected vs Actual student diners',
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
                  _buildAttendanceRow('Mon', 540, 520, 96.3),
                  const Divider(height: 16),
                  _buildAttendanceRow('Tue', 530, 515, 97.1),
                  const Divider(height: 16),
                  _buildAttendanceRow('Wed', 525, 495, 94.3),
                  const Divider(height: 16),
                  _buildAttendanceRow('Thu', 535, 528, 98.7),
                  const Divider(height: 16),
                  _buildAttendanceRow('Fri', 510, 480, 94.1),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Key Takeaway Banner
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.chipBackground,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.primary.withOpacity(0.2)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.insights, color: AppColors.primary, size: 24),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Analytical Insight: Days with >95% RSVP confirmation show an average 21.4% lower food waste rate compared to walk-in dominant days.',
                      style: TextStyle(fontSize: 12, color: AppColors.textPrimary, height: 1.3),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildAttendanceRow(String day, int expected, int actual, double fidelity) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(width: 40, child: Text(day, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13))),
        Text('Expected: $expected', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
        Text('Actual: $actual', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: fidelity >= 95 ? AppColors.chipBackground : const Color(0xFFFFF8E1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            '${fidelity.toStringAsFixed(1)}% RSVP',
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: fidelity >= 95 ? AppColors.primary : Colors.orange[900]),
          ),
        ),
      ],
    );
  }
}
