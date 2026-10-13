import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/environmental_factors.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/kpi_card.dart';

class ImpactScreen extends StatelessWidget {
  const ImpactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.currentUser;

    final foodSavedKg = user?.personalFoodSavedKg ?? 7.2;
    final metrics = EnvironmentalMetrics.fromFoodSaved(foodSavedKg);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Sustainability Impact', style: TextStyle(fontWeight: FontWeight.w800)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Eco Impact Hero Banner
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF004D40), Color(0xFF00796B)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.eco, color: Colors.white, size: 14),
                            SizedBox(width: 4),
                            Text(
                              'ECO CHAMPION',
                              style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      const Text(
                        'Level 3 • Green Saver',
                        style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '${metrics.foodSavedKg} kg',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const Text(
                    'Estimated Food Saved From Overproduction',
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    '“You helped reduce unnecessary food waste by confirming your meal attendance regularly.”',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Detailed Environmental Estimates
            const Text(
              'Estimated Environmental Savings',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: KpiCard(
                    title: 'CO₂e Avoided',
                    value: '${metrics.co2AvoidedKg} kg',
                    subtitle: '≈ 2.5 kg CO₂e / kg food',
                    icon: Icons.cloud_outlined,
                    iconColor: Colors.teal[700],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: KpiCard(
                    title: 'Water Footprint',
                    value: '${metrics.waterSavedLitres.toInt()} L',
                    subtitle: '≈ 1,000 L / kg food',
                    icon: Icons.water_drop_outlined,
                    iconColor: Colors.blue[700],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: KpiCard(
                    title: 'RSVP Streaks',
                    value: '${user?.mealsConfirmedCount ?? 48}',
                    subtitle: 'Consecutive confirmations',
                    icon: Icons.local_fire_department_outlined,
                    iconColor: Colors.orange[800],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: KpiCard(
                    title: 'Campus Rank',
                    value: '#14',
                    subtitle: 'Top 5% Eco Student',
                    icon: Icons.military_tech_outlined,
                    iconColor: Colors.amber[800],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Assumptions Note Card
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.backgroundLight,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.info_outline, size: 16, color: AppColors.textSecondary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      metrics.assumptionNote,
                      style: const TextStyle(fontSize: 11, color: AppColors.textSecondary, height: 1.4),
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
}
