import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/formatters.dart';
import '../../providers/waste_provider.dart';

class StudentNotificationsScreen extends StatelessWidget {
  const StudentNotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final wasteProvider = Provider.of<WasteProvider>(context);
    final alerts = wasteProvider.getAlerts(role: 'student');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications & Reminders', style: TextStyle(fontWeight: FontWeight.w800)),
      ),
      body: alerts.isEmpty
          ? const Center(child: Text('No new notifications', style: TextStyle(color: AppColors.textSecondary)))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: alerts.length,
              itemBuilder: (context, index) {
                final alert = alerts[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: alert.isRead ? Colors.white : const Color(0xFFF1F8E9),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: alert.isRead ? AppColors.border : AppColors.primary.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.notifications_active, color: AppColors.primary, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              alert.title,
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              alert.message,
                              style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, height: 1.3),
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
