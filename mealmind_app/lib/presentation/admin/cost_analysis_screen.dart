import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/formatters.dart';
import '../../core/utils/calculations.dart';
import '../../providers/analytics_provider.dart';
import '../../widgets/kpi_card.dart';
import '../../widgets/section_header.dart';

class CostAnalysisScreen extends StatelessWidget {
  const CostAnalysisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final analytics = Provider.of<AnalyticsProvider>(context);
    final dailyLoss = analytics.getTotalFinancialLoss();
    final weeklyLoss = dailyLoss * 6.5;
    final monthlyLoss = dailyLoss * 26.0;

    final potentialMonthlySavings = Calculations.calculatePotentialSavings(monthlyLoss, monthlyLoss * 0.45);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Food Cost & Financial Loss', style: TextStyle(fontWeight: FontWeight.w800)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Projected Financial Savings Hero
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFE65100), Color(0xFFF57C00)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'PROJECTED MONTHLY SAVINGS POTENTIAL',
                        style: TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                      Icon(Icons.trending_up, color: Colors.white, size: 20),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    Formatters.formatCurrency(potentialMonthlySavings),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Achievable by adhering to AI batching and reducing average institutional waste to ≤12%.',
                    style: TextStyle(color: Colors.white, fontSize: 12, height: 1.3),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Time Horizon Loss Cards
            Row(
              children: [
                Expanded(
                  child: KpiCard(
                    title: 'Daily Waste Loss',
                    value: Formatters.formatCurrency(dailyLoss),
                    subtitle: 'Today\'s 4 sessions',
                    icon: Icons.today,
                    iconColor: AppColors.criticalRed,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: KpiCard(
                    title: 'Weekly Loss',
                    value: Formatters.formatCurrency(weeklyLoss),
                    subtitle: 'Last 7 days total',
                    icon: Icons.calendar_view_week,
                    iconColor: Colors.orange[800],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            KpiCard(
              title: 'Monthly Cumulative Loss',
              value: Formatters.formatCurrency(monthlyLoss),
              subtitle: 'Estimated ₹9.4 Lakhs annual food wastage if unaddressed',
              icon: Icons.account_balance_wallet_outlined,
              iconColor: AppColors.criticalRed,
            ),
            const SizedBox(height: 20),

            // Food-Wise Financial Loss Table
            SectionHeader(
              title: 'Item-Wise Financial Waste Breakdown',
              subtitle: 'Waste quantity multiplied by unit procurement cost',
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
                children: const [
                  _CostRow('Mixed Vegetable Poriyal', '19.0 kg', '₹55 / kg', '₹1,045', true),
                  Divider(height: 20),
                  _CostRow('Steamed Basmati Rice', '15.5 kg', '₹45 / kg', '₹697', false),
                  Divider(height: 20),
                  _CostRow('Paneer Butter Masala', '3.5 kg', '₹190 / kg', '₹665', false),
                  Divider(height: 20),
                  _CostRow('South Indian Sambar', '18.0 L', '₹35 / L', '₹630', false),
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

class _CostRow extends StatelessWidget {
  final String item;
  final String qty;
  final String rate;
  final String cost;
  final bool isHighest;

  const _CostRow(this.item, this.qty, this.rate, this.cost, this.isHighest);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(item, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
              const SizedBox(height: 2),
              Text('$qty @ $rate', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: isHighest ? const Color(0xFFFFEBEE) : AppColors.backgroundLight,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            cost,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: isHighest ? AppColors.criticalRed : AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }
}
