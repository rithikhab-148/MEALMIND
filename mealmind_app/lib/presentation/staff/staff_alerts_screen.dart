import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/formatters.dart';
import '../../providers/waste_provider.dart';

class StaffAlertsScreen extends StatelessWidget {
  const StaffAlertsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final wasteProvider = Provider.of<WasteProvider>(context);
    final alerts = wasteProvider.getAlerts(role: 'staff');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kitchen Alerts & Notices', style: TextStyle(fontWeight: FontWeight.w800)),
      ),
      body: alerts.isEmpty
          ? const Center(child: Text('No active kitchen alerts.', style: TextStyle(color: AppColors.textSecondary)))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: alerts.length,
              itemBuilder: (context, index) {
                final alert = alerts[index];
                Color severityColor = AppColors.primary;
                if (alert.severity == 'critical') severityColor = AppColors.criticalRed;
                if (alert.severity == 'warning') severityColor = AppColors.warningYellow;

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: severityColor.withOpacity(0.4)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: severityColor.withOpacity(0.12),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.warning_amber_rounded, color: severityColor, size: 22),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              alert.title,
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: severityColor),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              alert.message,
                              style: const TextStyle(fontSize: 12, color: AppColors.textPrimary, height: 1.3),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              Formatters.formatTime(alert.timestamp),
                              style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
