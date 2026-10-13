import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/formatters.dart';
import '../../providers/auth_provider.dart';
import '../../providers/waste_provider.dart';
import '../../providers/meal_provider.dart';
import '../../widgets/kpi_card.dart';
import '../../widgets/section_header.dart';
import '../../widgets/waste_badge.dart';
import 'menu_management_screen.dart';
import 'waste_history_screen.dart';
import 'staff_alerts_screen.dart';
import 'staff_profile_screen.dart';

class StaffDashboardScreen extends StatelessWidget {
  const StaffDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final wasteProvider = Provider.of<WasteProvider>(context);
    final mealProvider = Provider.of<MealProvider>(context);
    final user = authProvider.currentUser;

    final prepLogs = wasteProvider.getPrepLogs(mealType: 'Lunch');
    final consumptionLogs = wasteProvider.getConsumptionLogs(mealType: 'Lunch');
    final alerts = wasteProvider.getAlerts(role: 'staff');

    double totalPrep = prepLogs.fold(0.0, (s, i) => s + i.quantityPrepared);
    double totalCons = consumptionLogs.fold(0.0, (s, i) => s + i.consumedQuantity);
    double totalWaste = totalPrep > totalCons ? totalPrep - totalCons : 0.0;
    double wastePct = totalPrep > 0 ? (totalWaste / totalPrep) * 100.0 : 0.0;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              user?.name.split(' ').first != null ? 'Kitchen: ${user!.name.split(' ').first}' : 'Kitchen Dashboard',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
            const Text(
              'Central Mess • Food Operations',
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu_book_outlined),
            tooltip: 'Manage Menu',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const MenuManagementScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.history_outlined),
            tooltip: 'Waste History',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const WasteHistoryScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            tooltip: 'Alerts',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const StaffAlertsScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.account_circle_outlined),
            tooltip: 'Profile',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const StaffProfileScreen()),
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
              // Active Alerts Banner if any
              if (alerts.isNotEmpty) ...[
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFEBEE),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.criticalRed.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.warning_amber_rounded, color: AppColors.criticalRed, size: 24),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              alerts.first.title,
                              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.criticalRed),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              alerts.first.message,
                              style: const TextStyle(fontSize: 11, color: AppColors.textPrimary),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // Today's Operational KPIs
              Row(
                children: [
                  Expanded(
                    child: KpiCard(
                      title: 'Lunch Prepared',
                      value: '${totalPrep.toStringAsFixed(0)} kg',
                      subtitle: '4 food items active',
                      icon: Icons.soup_kitchen,
                      iconColor: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: KpiCard(
                      title: 'Consumed',
                      value: '${totalCons.toStringAsFixed(0)} kg',
                      subtitle: '${((totalCons / (totalPrep > 0 ? totalPrep : 1)) * 100).toStringAsFixed(0)}% intake rate',
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
                      title: "Today's Waste %",
                      value: '${wastePct.toStringAsFixed(1)}%',
                      subtitle: wastePct > 15 ? 'Target 15% exceeded' : 'Within 15% target',
                      icon: Icons.delete_outline,
                      iconColor: wastePct > 15 ? AppColors.criticalRed : AppColors.normalGreen,
                      trendText: wastePct > 15 ? '+4.2%' : '-2.1%',
                      isPositiveTrend: wastePct <= 15,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: KpiCard(
                      title: 'Estimated Loss',
                      value: Formatters.formatCurrency(totalWaste * 45.0),
                      subtitle: 'Based on raw unit costs',
                      icon: Icons.currency_rupee,
                      iconColor: Colors.orange[800],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Live Item Progress Table
              SectionHeader(
                title: "Today's Lunch Items (Live)",
                subtitle: 'Preparation vs Consumption',
                actionText: 'Manage Menu',
                onActionTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const MenuManagementScreen()),
                  );
                },
              ),
              const SizedBox(height: 8),

              ...consumptionLogs.map((log) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
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
                            log.foodItem,
                            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                          ),
                          WasteBadge(
                            wastePercentage: log.wastePercentage,
                            targetThreshold: 15.0,
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Prepared: ${log.preparedQuantity} ${log.unit}',
                            style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                          ),
                          Text(
                            'Consumed: ${log.consumedQuantity} ${log.unit}',
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                          ),
                          Text(
                            'Waste: ${log.wasteQuantity} ${log.unit}',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: log.wastePercentage > 15 ? AppColors.criticalRed : AppColors.normalGreen,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: log.preparedQuantity > 0 ? (log.consumedQuantity / log.preparedQuantity).clamp(0.0, 1.0) : 0.0,
                          backgroundColor: Colors.grey[200],
                          valueColor: AlwaysStoppedAnimation<Color>(
                            log.wastePercentage > 15 ? AppColors.criticalRed : AppColors.primary,
                          ),
                          minHeight: 6,
                        ),
                      ),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
