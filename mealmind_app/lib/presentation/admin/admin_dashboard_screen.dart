import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/formatters.dart';
import '../../providers/auth_provider.dart';
import '../../providers/analytics_provider.dart';
import '../../providers/prediction_provider.dart';
import '../../providers/settings_provider.dart';
import '../../widgets/kpi_card.dart';
import '../../widgets/custom_chart.dart';
import '../../widgets/section_header.dart';
import '../../widgets/recommendation_card.dart';
import 'settings_screen.dart';
import 'user_management_screen.dart';
import 'institution_management_screen.dart';
import 'ai_predictions_admin_screen.dart';
import 'waste_analysis_screen.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final analyticsProvider = Provider.of<AnalyticsProvider>(context);
    final predProvider = Provider.of<PredictionProvider>(context);
    final settingsProvider = Provider.of<SettingsProvider>(context);
    final user = authProvider.currentUser;

    final totalPrep = analyticsProvider.getTotalPrepared();
    final totalCons = analyticsProvider.getTotalConsumed();
    final totalWaste = analyticsProvider.getTotalWaste();
    final wastePct = analyticsProvider.getWastePercentage();
    final totalLoss = analyticsProvider.getTotalFinancialLoss();
    final threshold = settingsProvider.targetWasteThreshold;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              user?.name.split(' ').first != null ? 'Warden: ${user!.name.split(' ').first}' : 'Admin Dashboard',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
            Text(
              settingsProvider.institutionName,
              style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.people_outline),
            tooltip: 'User Roster',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const UserManagementScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.account_balance_outlined),
            tooltip: 'Institution Messes',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const InstitutionManagementScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.tune_outlined),
            tooltip: 'Threshold Settings',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => Future.delayed(const Duration(milliseconds: 500)),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // High Waste Alert Card if wastePct > threshold
              if (wastePct > threshold) ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFEBEE),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.criticalRed.withOpacity(0.4)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.warning_amber_rounded, color: AppColors.criticalRed, size: 28),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '🔴 High Food Waste Threshold Alert',
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.criticalRed),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Today\'s total waste reached ${wastePct.toStringAsFixed(1)}%, exceeding your target of ${threshold.toStringAsFixed(1)}% by ${(wastePct - threshold).toStringAsFixed(1)}%.',
                              style: const TextStyle(fontSize: 12, color: AppColors.textPrimary),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // Today's Executive KPIs
              Row(
                children: [
                  Expanded(
                    child: KpiCard(
                      title: 'Food Prepared',
                      value: '${totalPrep.toInt()} kg',
                      subtitle: 'Breakfast, Lunch, Dinner',
                      icon: Icons.soup_kitchen,
                      iconColor: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: KpiCard(
                      title: 'Food Consumed',
                      value: '${totalCons.toInt()} kg',
                      subtitle: '${((totalCons / totalPrep) * 100).toStringAsFixed(0)}% overall intake',
                      icon: Icons.dining,
                      iconColor: AppColors.secondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: KpiCard(
                      title: 'Food Wasted',
                      value: '${totalWaste.toStringAsFixed(1)} kg',
                      subtitle: '${wastePct.toStringAsFixed(1)}% of preparation',
                      icon: Icons.delete_outline,
                      iconColor: wastePct > threshold ? AppColors.criticalRed : AppColors.normalGreen,
                      trendText: wastePct > threshold ? '+3.4%' : '-1.8%',
                      isPositiveTrend: wastePct <= threshold,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: KpiCard(
                      title: 'Financial Loss',
                      value: Formatters.formatCurrency(totalLoss),
                      subtitle: 'Raw ingredient cost',
                      icon: Icons.currency_rupee,
                      iconColor: Colors.orange[900],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: KpiCard(
                      title: 'Attendance (Expected)',
                      value: '${analyticsProvider.getExpectedAttendance()}',
                      subtitle: 'Based on student RSVPs',
                      icon: Icons.event_available,
                      iconColor: Colors.blue[700],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: KpiCard(
                      title: 'Actual Turnout',
                      value: '${analyticsProvider.getActualAttendance()}',
                      subtitle: '94.3% RSVP fidelity rate',
                      icon: Icons.groups,
                      iconColor: Colors.indigo[700],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Weekly Waste Trend Chart
              SectionHeader(
                title: 'Weekly Food Waste Trend',
                subtitle: 'Daily kilograms of food waste across 7 days',
                actionText: 'Deep Analysis',
                onActionTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const WasteAnalysisScreen()),
                  );
                },
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
                  dataPoints: analyticsProvider.getDailyWasteTrend(),
                  labels: const ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
                  unit: 'kg',
                ),
              ),
              const SizedBox(height: 20),

              // AI Demand Predictions Overview
              SectionHeader(
                title: 'Upcoming AI Demand Forecasts',
                subtitle: 'Tomorrow Lunch Preparation Targets',
                actionText: 'All Forecasts',
                onActionTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AiPredictionsAdminScreen()),
                  );
                },
              ),
              const SizedBox(height: 8),

              ...predProvider.predictions.take(2).map((pred) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(pred.foodItem, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                          const SizedBox(height: 2),
                          Text('Target: ${pred.recommendedPreparation} ${pred.unit} (Confidence: ${pred.confidenceScore}%)', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: pred.predictedRiskLevel == 'High' ? const Color(0xFFFFEBEE) : AppColors.chipBackground,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '${pred.predictedRiskLevel} Risk',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: pred.predictedRiskLevel == 'High' ? AppColors.criticalRed : AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 16),

              // Priority Recommendation
              SectionHeader(
                title: 'High Impact Recommendation',
                subtitle: 'AI prescriptive optimization',
              ),
              const SizedBox(height: 8),

              if (predProvider.recommendations.isNotEmpty)
                RecommendationCard(
                  recommendation: predProvider.recommendations.first,
                  onToggleApplied: () => predProvider.toggleRecommendation(predProvider.recommendations.first.id),
                ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
