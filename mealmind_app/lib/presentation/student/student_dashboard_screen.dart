import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/formatters.dart';
import '../../providers/auth_provider.dart';
import '../../providers/meal_provider.dart';
import '../../widgets/kpi_card.dart';
import '../../widgets/section_header.dart';
import 'feedback_screen.dart';
import 'student_notifications_screen.dart';

class StudentDashboardScreen extends StatelessWidget {
  const StudentDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final mealProvider = Provider.of<MealProvider>(context);
    final user = authProvider.currentUser;

    final todayLunchItems = mealProvider.getMenus(mealType: 'Lunch');
    final responses = user != null ? mealProvider.getStudentResponses(user.id) : [];
    final lunchResponse = responses.where((r) => r.mealType == 'Lunch').firstOrNull;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hi, ${user?.name.split(' ').first ?? 'Student'} 👋',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
            const Text(
              'Central Dining Hall • ABC College',
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const StudentNotificationsScreen()),
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => Future.delayed(const Duration(milliseconds: 500)),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Next Meal RSVP Action Card
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primary, AppColors.secondary],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 6),
                    ),
                  ],
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
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.restaurant, size: 14, color: Colors.white),
                              SizedBox(width: 4),
                              Text(
                                "TODAY'S LUNCH (12:30 PM - 2:30 PM)",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (lunchResponse != null)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: lunchResponse.willAttend ? AppColors.normalGreen : Colors.orange[800],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              lunchResponse.willAttend ? "RSVP: EATING" : "RSVP: SKIPPING",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'Will you eat lunch today?',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Your response helps the kitchen prepare exact quantities and prevents food wastage.',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              if (user != null) {
                                mealProvider.setStudentResponse(
                                  studentId: user.id,
                                  studentName: user.name,
                                  mealType: 'Lunch',
                                  response: 'YES',
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Confirmed: YES, I'LL EAT Lunch 🎉"),
                                    backgroundColor: AppColors.normalGreen,
                                  ),
                                );
                              }
                            },
                            icon: const Icon(Icons.check, size: 18),
                            label: const Text("YES, I'LL EAT"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: AppColors.primary,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              if (user != null) {
                                mealProvider.setStudentResponse(
                                  studentId: user.id,
                                  studentName: user.name,
                                  mealType: 'Lunch',
                                  response: 'NO',
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Recorded: NO, I'LL SKIP Lunch"),
                                    backgroundColor: Colors.orange,
                                  ),
                                );
                              }
                            },
                            icon: const Icon(Icons.close, size: 18, color: Colors.white),
                            label: const Text("NO, I'LL SKIP", style: TextStyle(color: Colors.white)),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Colors.white70, width: 1.5),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Sustainability Impact Summary Cards
              Row(
                children: [
                  Expanded(
                    child: KpiCard(
                      title: 'Meals Confirmed',
                      value: '${user?.mealsConfirmedCount ?? 48}',
                      subtitle: 'Active attendance helper',
                      icon: Icons.check_circle,
                      iconColor: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: KpiCard(
                      title: 'Food Saved (Est.)',
                      value: '${user?.personalFoodSavedKg ?? 7.2} kg',
                      subtitle: '≈ 18 kg CO₂e avoided',
                      icon: Icons.eco,
                      iconColor: AppColors.secondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Today's Lunch Menu Section
              SectionHeader(
                title: "Today's Lunch Menu",
                subtitle: Formatters.formatDate(DateTime.now()),
                actionText: 'View All',
                onActionTap: () {
                  // Jump to Menu tab
                },
              ),
              const SizedBox(height: 8),

              ...todayLunchItems.map((item) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.chipBackground,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          item.isSpecialItem ? Icons.star : Icons.restaurant,
                          color: item.isSpecialItem ? Colors.amber[800] : AppColors.primary,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  item.foodItem,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                if (item.isSpecialItem) ...[
                                  const SizedBox(width: 6),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: Colors.amber[100],
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      'SPECIAL',
                                      style: TextStyle(
                                        fontSize: 9,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.amber[900],
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Standard Serving: ${item.servingSizeGrams.toInt()}g • Rating: ${item.averageRating} ★ (${item.ratingCount})',
                              style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }),

              const SizedBox(height: 16),

              // Rate Last Meal Button
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const FeedbackScreen()),
                  );
                },
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF8E1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.amber[300]!),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.amber[700],
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.star, color: Colors.white, size: 20),
                      ),
                      const SizedBox(width: 14),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Rate Today\'s Meal & Give Feedback',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Help kitchen adjust portion sizes and recipe taste.',
                              style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.textSecondary),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
