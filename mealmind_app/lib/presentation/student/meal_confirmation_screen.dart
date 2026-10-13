import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_constants.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/formatters.dart';
import '../../providers/auth_provider.dart';
import '../../providers/meal_provider.dart';

class MealConfirmationScreen extends StatelessWidget {
  const MealConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final mealProvider = Provider.of<MealProvider>(context);
    final user = authProvider.currentUser;

    final studentResponses = user != null ? mealProvider.getStudentResponses(user.id) : [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meal Intention (RSVP)', style: TextStyle(fontWeight: FontWeight.w800)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.chipBackground,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.primary.withOpacity(0.2)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.lightbulb_outline, color: AppColors.primary, size: 24),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Confirming your meal attendance before cut-off time enables the kitchen AI model to forecast exact demand and reduces food waste by up to 30%.',
                      style: TextStyle(fontSize: 12, color: AppColors.textPrimary, height: 1.4),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "Today's Schedule (${Formatters.formatDate(DateTime.now())})",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 12),

            ...AppConstants.mealTypes.map((mealType) {
              final resp = studentResponses.where((r) => r.mealType == mealType).firstOrNull;
              final isAttending = resp?.willAttend;

              String timing = '7:30 AM - 9:30 AM';
              if (mealType == 'Lunch') timing = '12:30 PM - 2:30 PM';
              if (mealType == 'Snacks') timing = '4:30 PM - 5:45 PM';
              if (mealType == 'Dinner') timing = '7:30 PM - 9:30 PM';

              return Container(
                margin: const EdgeInsets.only(bottom: 14),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isAttending == true
                        ? AppColors.normalGreen
                        : (isAttending == false ? Colors.orange[300]! : AppColors.border),
                    width: isAttending != null ? 1.5 : 1.0,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              mealType,
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                            ),
                            const SizedBox(height: 2),
                            Text(timing, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                          ],
                        ),
                        if (isAttending != null)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: isAttending ? AppColors.chipBackground : const Color(0xFFFFF3E0),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              isAttending ? 'CONFIRMED' : 'SKIPPED',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: isAttending ? AppColors.normalGreen : Colors.orange[900],
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              if (user != null) {
                                mealProvider.setStudentResponse(
                                  studentId: user.id,
                                  studentName: user.name,
                                  mealType: mealType,
                                  response: 'YES',
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isAttending == true ? AppColors.primary : AppColors.backgroundLight,
                              foregroundColor: isAttending == true ? Colors.white : AppColors.textPrimary,
                              elevation: 0,
                              side: BorderSide(
                                color: isAttending == true ? AppColors.primary : AppColors.border,
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.check, size: 16),
                                SizedBox(width: 6),
                                Text("YES, I'LL EAT", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              if (user != null) {
                                mealProvider.setStudentResponse(
                                  studentId: user.id,
                                  studentName: user.name,
                                  mealType: mealType,
                                  response: 'NO',
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isAttending == false ? Colors.orange[800] : AppColors.backgroundLight,
                              foregroundColor: isAttending == false ? Colors.white : AppColors.textPrimary,
                              elevation: 0,
                              side: BorderSide(
                                color: isAttending == false ? Colors.orange[800]! : AppColors.border,
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.close, size: 16),
                                SizedBox(width: 6),
                                Text("NO, I'LL SKIP", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
