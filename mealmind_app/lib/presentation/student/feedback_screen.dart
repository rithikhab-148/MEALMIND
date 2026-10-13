import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../core/constants/app_colors.dart';
import '../../data/models/feedback_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/meal_provider.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/feedback_star_rating.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  String _selectedFoodItem = 'Paneer Butter Masala';
  String _selectedMealType = 'Lunch';
  double _tasteRating = 4.0;
  double _qualityRating = 4.0;
  double _portionRating = 3.0;
  double _overallRating = 4.0;
  String _portionIssue = 'optimal'; // 'optimal', 'too_large', 'too_small'
  final _commentController = TextEditingController();
  bool _submitted = false;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final mealProvider = Provider.of<MealProvider>(context);
    final user = authProvider.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meal Feedback & Rating', style: TextStyle(fontWeight: FontWeight.w800)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_submitted) ...[
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.chipBackground,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.normalGreen),
                ),
                child: Column(
                  children: [
                    const Icon(Icons.check_circle, color: AppColors.normalGreen, size: 48),
                    const SizedBox(height: 12),
                    const Text(
                      'Thank You For Your Feedback!',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Your input directly helps our kitchen team refine recipes, adjust batch portion sizes, and eliminate plate wastage.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 16),
                    CustomButton(
                      text: 'Submit Another Rating',
                      onPressed: () => setState(() => _submitted = false),
                    ),
                  ],
                ),
              ),
            ] else ...[
              const Text(
                'Rate Your Dining Experience',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
              ),
              const Text(
                'Help kitchen chefs adjust cooking parameters.',
                style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 16),

              // Meal & Item Selector
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
                    const Text('Select Food Item:', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 6),
                    DropdownButtonFormField<String>(
                      value: _selectedFoodItem,
                      decoration: const InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10)),
                      items: [
                        'Paneer Butter Masala',
                        'Steamed Basmati Rice',
                        'South Indian Sambar',
                        'Mixed Vegetable Poriyal',
                        'Idli & Sambar',
                        'Jeera Rice & Dal Makhani',
                      ].map((item) => DropdownMenuItem(value: item, child: Text(item, style: const TextStyle(fontSize: 14)))).toList(),
                      onChanged: (val) => setState(() => _selectedFoodItem = val!),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // Multi-factor 5-star Ratings
              FeedbackStarRating(
                title: 'Taste & Flavor',
                rating: _tasteRating,
                onRatingChanged: (r) => setState(() => _tasteRating = r),
              ),
              const SizedBox(height: 12),

              FeedbackStarRating(
                title: 'Freshness & Quality',
                rating: _qualityRating,
                onRatingChanged: (r) => setState(() => _qualityRating = r),
              ),
              const SizedBox(height: 12),

              FeedbackStarRating(
                title: 'Overall Satisfaction',
                rating: _overallRating,
                onRatingChanged: (r) => setState(() => _overallRating = r),
              ),
              const SizedBox(height: 14),

              // Portion Size Evaluation
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
                    const Text('Portion Size Assessment:', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        _buildPortionOption('Too Small', 'too_small'),
                        const SizedBox(width: 8),
                        _buildPortionOption('Just Right', 'optimal'),
                        const SizedBox(width: 8),
                        _buildPortionOption('Too Large', 'too_large'),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              CustomTextField(
                label: 'Comments / Suggestions (Optional)',
                hint: 'e.g. Rice was well-cooked, but vegetables were slightly over-salted.',
                controller: _commentController,
                maxLines: 3,
              ),
              const SizedBox(height: 20),

              CustomButton(
                text: 'Submit Meal Feedback',
                icon: Icons.send_rounded,
                onPressed: () {
                  if (user != null) {
                    final feedback = FeedbackModel(
                      id: const Uuid().v4(),
                      studentId: user.id,
                      studentName: user.name,
                      foodItem: _selectedFoodItem,
                      date: DateTime.now().toIso8601String().substring(0, 10),
                      mealType: _selectedMealType,
                      tasteRating: _tasteRating,
                      qualityRating: _qualityRating,
                      portionRating: _portionRating,
                      overallRating: _overallRating,
                      comments: _commentController.text.trim().isNotEmpty ? _commentController.text.trim() : null,
                      portionIssueReported: _portionIssue,
                      createdAt: DateTime.now(),
                    );
                    mealProvider.submitFeedback(feedback);
                    setState(() => _submitted = true);
                  }
                },
              ),
              const SizedBox(height: 24),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPortionOption(String label, String value) {
    final isSelected = _portionIssue == value;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _portionIssue = value),
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : AppColors.backgroundLight,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: isSelected ? AppColors.primary : AppColors.border),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isSelected ? Colors.white : AppColors.textPrimary,
            ),
          ),
        ),
      ),
    );
  }
}
