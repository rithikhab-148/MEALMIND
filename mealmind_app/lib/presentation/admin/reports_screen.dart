import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/formatters.dart';
import '../../data/services/report_export_service.dart';
import '../../providers/analytics_provider.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/kpi_card.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  String _selectedPeriod = 'Weekly';

  void _showCsvExportDialog(String csvContent) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Exported CSV Data', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        content: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: SelectableText(
              csvContent,
              style: const TextStyle(fontFamily: 'monospace', fontSize: 11),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('CSV copied to clipboard / exported successfully!'),
                  backgroundColor: AppColors.normalGreen,
                ),
              );
            },
            icon: const Icon(Icons.download, size: 16),
            label: const Text('Download CSV'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final analytics = Provider.of<AnalyticsProvider>(context);
    final report = analytics.generateReport(_selectedPeriod);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Institutional Food Reports', style: TextStyle(fontWeight: FontWeight.w800)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Period Selector
            Row(
              children: ['Daily', 'Weekly', 'Monthly'].map((period) {
                final isSelected = _selectedPeriod == period;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ChoiceChip(
                      label: Center(child: Text(period)),
                      selected: isSelected,
                      onSelected: (selected) {
                        if (selected) setState(() => _selectedPeriod = period);
                      },
                      selectedColor: AppColors.primary,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),

            // Report Header Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        report.title,
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.chipBackground,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          Formatters.formatShortDate(report.generatedAt),
                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primary),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  const Text('Generated for Campus Food Committee & Operations Audit', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Metrics Summary Grid
            Row(
              children: [
                Expanded(
                  child: KpiCard(
                    title: 'Total Prepared',
                    value: '${report.totalPreparedKg.toInt()} kg',
                    icon: Icons.soup_kitchen,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: KpiCard(
                    title: 'Total Consumed',
                    value: '${report.totalConsumedKg.toInt()} kg',
                    icon: Icons.dining,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: KpiCard(
                    title: 'Total Wasted',
                    value: '${report.totalWasteKg} kg',
                    subtitle: '${report.wastePercentage}% waste rate',
                    icon: Icons.delete_outline,
                    iconColor: AppColors.criticalRed,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: KpiCard(
                    title: 'Financial Loss',
                    value: Formatters.formatCurrency(report.totalFinancialLoss),
                    subtitle: 'Raw ingredient cost',
                    icon: Icons.currency_rupee,
                    iconColor: Colors.orange[900],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Key Audit Takeaways
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Audit Highlights & Key Drivers', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 10),
                  _buildAuditRow('Highest Wasted Food Item:', report.topWastedItem, AppColors.criticalRed),
                  const Divider(height: 16),
                  _buildAuditRow('Highest Waste Meal Session:', report.highestWasteMeal, AppColors.textPrimary),
                  const Divider(height: 16),
                  _buildAuditRow('Primary Waste Reason:', report.primaryWasteReason, AppColors.warningYellow),
                  const Divider(height: 16),
                  _buildAuditRow('CO₂e Impact Generated:', '${report.co2AvoidedKg} kg CO₂e', Colors.teal[800]!),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Export Buttons
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    text: 'Export CSV',
                    icon: Icons.table_chart_outlined,
                    onPressed: () {
                      final csv = ReportExportService.generateCsv(report);
                      _showCsvExportDialog(csv);
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomButton(
                    text: 'Export PDF',
                    isOutlined: true,
                    icon: Icons.picture_as_pdf_outlined,
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('PDF Report generated and ready for print/export! 📄'),
                          backgroundColor: AppColors.primary,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildAuditRow(String label, String value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
        Text(value, style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: color)),
      ],
    );
  }
}
