import 'package:intl/intl.dart';
import '../models/user_model.dart';
import '../models/menu_item_model.dart';
import '../models/meal_response_model.dart';
import '../models/food_prep_model.dart';
import '../models/food_consumption_model.dart';
import '../models/food_waste_model.dart';
import '../models/feedback_model.dart';
import '../models/prediction_model.dart';
import '../models/recommendation_model.dart';
import '../models/alert_model.dart';

/// Pre-populated realistic institutional dataset for "ABC College" (500+ students, 30-day logs)
class DemoDataService {
  static final String todayStr = DateFormat('yyyy-MM-dd').format(DateTime.now());

  // Demo Accounts
  static final UserModel demoAdmin = UserModel(
    id: 'usr_admin_01',
    name: 'Dr. Rajesh Sharma (Mess Warden)',
    email: 'admin@abccollege.edu',
    role: 'admin',
    institutionId: 'inst_abc_college',
    diningHallId: 'hall_central',
    mealsConfirmedCount: 120,
    personalFoodSavedKg: 18.5,
  );

  static final UserModel demoStaff = UserModel(
    id: 'usr_staff_01',
    name: 'Chef Ramesh Kumar (Head Cook)',
    email: 'kitchen@abccollege.edu',
    role: 'staff',
    institutionId: 'inst_abc_college',
    diningHallId: 'hall_central',
    mealsConfirmedCount: 210,
    personalFoodSavedKg: 34.0,
  );

  static final UserModel demoStudent = UserModel(
    id: 'usr_student_01',
    name: 'Aditya Verma (CSE - Year 3)',
    email: 'aditya.v@abccollege.edu',
    role: 'student',
    institutionId: 'inst_abc_college',
    diningHallId: 'hall_central',
    studentIdNumber: '2024CS1042',
    mealsConfirmedCount: 48,
    personalFoodSavedKg: 7.2,
  );

  // Today's Menu
  static List<MenuItemModel> getTodayMenu() {
    return [
      // Breakfast
      MenuItemModel(
        id: 'menu_bk_1',
        date: todayStr,
        mealType: 'Breakfast',
        foodItem: 'Idli & Sambar',
        quantityPlanned: 110.0,
        servingSizeGrams: 220.0,
        costPerUnit: 40.0,
        unit: 'kg',
        averageRating: 4.3,
        ratingCount: 142,
      ),
      MenuItemModel(
        id: 'menu_bk_2',
        date: todayStr,
        mealType: 'Breakfast',
        foodItem: 'Poha with Mint Chutney',
        quantityPlanned: 85.0,
        servingSizeGrams: 180.0,
        costPerUnit: 35.0,
        unit: 'kg',
        averageRating: 3.9,
        ratingCount: 98,
      ),
      // Lunch
      MenuItemModel(
        id: 'menu_ln_1',
        date: todayStr,
        mealType: 'Lunch',
        foodItem: 'Steamed Basmati Rice',
        quantityPlanned: 155.0,
        servingSizeGrams: 280.0,
        costPerUnit: 45.0,
        unit: 'kg',
        averageRating: 4.2,
        ratingCount: 220,
      ),
      MenuItemModel(
        id: 'menu_ln_2',
        date: todayStr,
        mealType: 'Lunch',
        foodItem: 'South Indian Sambar',
        quantityPlanned: 90.0,
        servingSizeGrams: 180.0,
        costPerUnit: 35.0,
        unit: 'L',
        averageRating: 4.0,
        ratingCount: 210,
      ),
      MenuItemModel(
        id: 'menu_ln_3',
        date: todayStr,
        mealType: 'Lunch',
        foodItem: 'Paneer Butter Masala',
        quantityPlanned: 80.0,
        servingSizeGrams: 150.0,
        costPerUnit: 190.0,
        unit: 'kg',
        averageRating: 4.8,
        ratingCount: 280,
        isSpecialItem: true,
      ),
      MenuItemModel(
        id: 'menu_ln_4',
        date: todayStr,
        mealType: 'Lunch',
        foodItem: 'Mixed Vegetable Poriyal',
        quantityPlanned: 65.0,
        servingSizeGrams: 130.0,
        costPerUnit: 55.0,
        unit: 'kg',
        averageRating: 2.8,
        ratingCount: 185,
      ),
      MenuItemModel(
        id: 'menu_ln_5',
        date: todayStr,
        mealType: 'Lunch',
        foodItem: 'Fresh Set Curd',
        quantityPlanned: 55.0,
        servingSizeGrams: 100.0,
        costPerUnit: 45.0,
        unit: 'L',
        averageRating: 4.5,
        ratingCount: 190,
      ),
      // Snacks
      MenuItemModel(
        id: 'menu_sn_1',
        date: todayStr,
        mealType: 'Snacks',
        foodItem: 'Samosa & Green Chutney',
        quantityPlanned: 70.0,
        servingSizeGrams: 150.0,
        costPerUnit: 60.0,
        unit: 'kg',
        averageRating: 4.6,
        ratingCount: 205,
      ),
      MenuItemModel(
        id: 'menu_sn_2',
        date: todayStr,
        mealType: 'Snacks',
        foodItem: 'Masala Chai',
        quantityPlanned: 60.0,
        servingSizeGrams: 120.0,
        costPerUnit: 25.0,
        unit: 'L',
        averageRating: 4.4,
        ratingCount: 215,
      ),
      // Dinner
      MenuItemModel(
        id: 'menu_dn_1',
        date: todayStr,
        mealType: 'Dinner',
        foodItem: 'Jeera Rice & Dal Makhani',
        quantityPlanned: 135.0,
        servingSizeGrams: 260.0,
        costPerUnit: 60.0,
        unit: 'kg',
        averageRating: 4.4,
        ratingCount: 195,
      ),
      MenuItemModel(
        id: 'menu_dn_2',
        date: todayStr,
        mealType: 'Dinner',
        foodItem: 'Tawa Roti / Phulka',
        quantityPlanned: 65.0,
        servingSizeGrams: 120.0,
        costPerUnit: 40.0,
        unit: 'kg',
        averageRating: 4.2,
        ratingCount: 180,
      ),
    ];
  }

  // Active Student RSVPs
  static List<MealResponseModel> getInitialStudentResponses(String studentId) {
    return [
      MealResponseModel(
        id: 'rsp_1',
        studentId: studentId,
        studentName: 'Aditya Verma',
        date: todayStr,
        mealType: 'Breakfast',
        response: 'YES',
        timestamp: DateTime.now().subtract(const Duration(hours: 4)),
      ),
      MealResponseModel(
        id: 'rsp_2',
        studentId: studentId,
        studentName: 'Aditya Verma',
        date: todayStr,
        mealType: 'Lunch',
        response: 'YES',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      MealResponseModel(
        id: 'rsp_3',
        studentId: studentId,
        studentName: 'Aditya Verma',
        date: todayStr,
        mealType: 'Snacks',
        response: 'NO',
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      ),
      MealResponseModel(
        id: 'rsp_4',
        studentId: studentId,
        studentName: 'Aditya Verma',
        date: todayStr,
        mealType: 'Dinner',
        response: 'YES',
        timestamp: DateTime.now(),
      ),
    ];
  }

  // Active Kitchen Prep Logs
  static List<FoodPrepModel> getInitialPrepLogs() {
    return [
      FoodPrepModel(
        id: 'prep_1',
        foodItem: 'Steamed Basmati Rice',
        quantityPrepared: 160.0,
        unit: 'kg',
        date: todayStr,
        mealType: 'Lunch',
        prepTime: DateTime.now().subtract(const Duration(hours: 3)),
        staffName: 'Chef Ramesh Kumar',
        batchNumber: 'B1-LUNCH',
      ),
      FoodPrepModel(
        id: 'prep_2',
        foodItem: 'South Indian Sambar',
        quantityPrepared: 92.0,
        unit: 'L',
        date: todayStr,
        mealType: 'Lunch',
        prepTime: DateTime.now().subtract(const Duration(hours: 3)),
        staffName: 'Chef Ramesh Kumar',
        batchNumber: 'B1-LUNCH',
      ),
      FoodPrepModel(
        id: 'prep_3',
        foodItem: 'Paneer Butter Masala',
        quantityPrepared: 82.0,
        unit: 'kg',
        date: todayStr,
        mealType: 'Lunch',
        prepTime: DateTime.now().subtract(const Duration(hours: 2, minutes: 30)),
        staffName: 'Cook Murugan',
        batchNumber: 'B2-LUNCH',
      ),
      FoodPrepModel(
        id: 'prep_4',
        foodItem: 'Mixed Vegetable Poriyal',
        quantityPrepared: 68.0,
        unit: 'kg',
        date: todayStr,
        mealType: 'Lunch',
        prepTime: DateTime.now().subtract(const Duration(hours: 2, minutes: 40)),
        staffName: 'Cook Murugan',
        batchNumber: 'B1-LUNCH',
      ),
    ];
  }

  // Active Food Consumption Logs
  static List<FoodConsumptionModel> getInitialConsumptionLogs() {
    return [
      FoodConsumptionModel.create(
        id: 'cons_1',
        foodItem: 'Steamed Basmati Rice',
        preparedQuantity: 160.0,
        consumedQuantity: 144.5,
        unit: 'kg',
        date: todayStr,
        mealType: 'Lunch',
      ),
      FoodConsumptionModel.create(
        id: 'cons_2',
        foodItem: 'South Indian Sambar',
        preparedQuantity: 92.0,
        consumedQuantity: 74.0,
        unit: 'L',
        date: todayStr,
        mealType: 'Lunch',
      ),
      FoodConsumptionModel.create(
        id: 'cons_3',
        foodItem: 'Paneer Butter Masala',
        preparedQuantity: 82.0,
        consumedQuantity: 78.5,
        unit: 'kg',
        date: todayStr,
        mealType: 'Lunch',
      ),
      FoodConsumptionModel.create(
        id: 'cons_4',
        foodItem: 'Mixed Vegetable Poriyal',
        preparedQuantity: 68.0,
        consumedQuantity: 49.0,
        unit: 'kg',
        date: todayStr,
        mealType: 'Lunch',
      ),
    ];
  }

  // Waste Recording History
  static List<FoodWasteModel> getInitialWasteLogs() {
    return [
      FoodWasteModel.create(
        id: 'wst_1',
        foodItem: 'Mixed Vegetable Poriyal',
        wasteQuantity: 19.0,
        unit: 'kg',
        wasteType: 'Plate waste',
        wasteReason: 'Poor taste',
        date: todayStr,
        mealType: 'Lunch',
        costPerUnit: 55.0,
        notes: 'Vegetables undercooked and overly salty, high table leftovers',
        staffName: 'Chef Ramesh Kumar',
      ),
      FoodWasteModel.create(
        id: 'wst_2',
        foodItem: 'South Indian Sambar',
        wasteQuantity: 18.0,
        unit: 'L',
        wasteType: 'Leftover food',
        wasteReason: 'Excess preparation',
        date: todayStr,
        mealType: 'Lunch',
        costPerUnit: 35.0,
        notes: 'Excess prepared compared to actual turnout',
        staffName: 'Chef Ramesh Kumar',
      ),
      FoodWasteModel.create(
        id: 'wst_3',
        foodItem: 'Steamed Basmati Rice',
        wasteQuantity: 15.5,
        unit: 'kg',
        wasteType: 'Leftover food',
        wasteReason: 'Low attendance',
        date: todayStr,
        mealType: 'Lunch',
        costPerUnit: 45.0,
        notes: 'Student turnout was 480 vs 520 expected',
        staffName: 'Cook Murugan',
      ),
      FoodWasteModel.create(
        id: 'wst_4',
        foodItem: 'Paneer Butter Masala',
        wasteQuantity: 3.5,
        unit: 'kg',
        wasteType: 'Plate waste',
        wasteReason: 'Large portion size',
        date: todayStr,
        mealType: 'Lunch',
        costPerUnit: 190.0,
        notes: 'Very popular item, minimal residual waste',
        staffName: 'Chef Ramesh Kumar',
      ),
    ];
  }

  // AI Predictions for Upcoming Meals
  static List<PredictionModel> getInitialPredictions() {
    return [
      PredictionModel(
        foodItem: 'Steamed Basmati Rice',
        mealType: 'Lunch',
        expectedAttendance: 525,
        mealConfirmations: 495,
        predictedConsumption: 147.0,
        recommendedPreparation: 153.0,
        unit: 'kg',
        confidenceScore: 94.2,
        predictedRiskLevel: 'Low',
        predictedWastePercentage: 3.9,
        exceedsThreshold: false,
        alertMessage: 'Expected turnout high with strong RSVP confirmations. Normal prep buffer.',
        explainableFactors: [
          ExplainableFactor(factor: 'Expected Attendance', value: '525 students', impact: 'Primary base (+82%)'),
          ExplainableFactor(factor: 'Meal Confirmations (RSVP)', value: '495 students (94.2%)', impact: 'High confidence confirmation rate'),
          ExplainableFactor(factor: 'Rating Multiplier', value: '4.2 / 5.0', impact: 'Stable consumption rate'),
          ExplainableFactor(factor: 'Day of Week', value: 'Thursday', impact: 'Standard academic day schedule'),
        ],
      ),
      PredictionModel(
        foodItem: 'South Indian Sambar',
        mealType: 'Lunch',
        expectedAttendance: 525,
        mealConfirmations: 495,
        predictedConsumption: 78.0,
        recommendedPreparation: 82.0,
        unit: 'L',
        confidenceScore: 91.5,
        predictedRiskLevel: 'Medium',
        predictedWastePercentage: 11.2,
        exceedsThreshold: false,
        alertMessage: 'Sambar waste risk is moderate. Recommend 82L down from standard 95L.',
        explainableFactors: [
          ExplainableFactor(factor: 'Historical Waste', value: '18.0 L average', impact: 'Reduced prep target by 13%'),
          ExplainableFactor(factor: 'Portion Calibrations', value: '150 ml per student', impact: 'Reduced from 180 ml standard'),
        ],
      ),
      PredictionModel(
        foodItem: 'Mixed Vegetable Poriyal',
        mealType: 'Lunch',
        expectedAttendance: 525,
        mealConfirmations: 495,
        predictedConsumption: 48.0,
        recommendedPreparation: 52.0,
        unit: 'kg',
        confidenceScore: 88.0,
        predictedRiskLevel: 'High',
        predictedWastePercentage: 24.5,
        exceedsThreshold: true,
        alertMessage: 'Mixed Vegetable waste is predicted to exceed threshold (24.5% > 15.0%).',
        actionableSuggestion: 'Reduce preparation from 68 kg to 52 kg (-23%) and prepare in 2 staggered batches.',
        explainableFactors: [
          ExplainableFactor(factor: 'Low Student Satisfaction', value: '2.8 / 5.0 rating', impact: 'High plate scrapings correlation'),
          ExplainableFactor(factor: 'Recent Trend', value: '28% average waste over last 4 weeks', impact: 'Triggered Critical alert'),
        ],
      ),
    ];
  }

  // System Recommendations
  static List<RecommendationModel> getInitialRecommendations() {
    return [
      RecommendationModel(
        id: 'rec_1',
        category: 'Preparation Batching',
        title: 'Implement 2-Stage Staggered Cooking for Rice & Sambar',
        description: 'Historical logs indicate 18% of lunchtime food waste occurs due to initial over-preparation. Prepare 70% of estimated quantity at 11:30 AM and the remaining 30% only after 1:00 PM if RSVP attendance peaks.',
        impactLevel: 'High',
        estimatedSavingsMonthly: '₹14,500',
        targetRole: 'Kitchen Staff',
        icon: 'soup_kitchen',
      ),
      RecommendationModel(
        id: 'rec_2',
        category: 'Menu Optimization',
        title: 'Reformulate or Replace "Mixed Vegetable Poriyal"',
        description: 'Mixed Vegetable Poriyal has recorded an average student rating of 2.8/5.0 and an elevated waste rate of 26.4% over the last 4 weeks. Replacing with "Paneer Butter Masala" or "Aloo Gobi" reduces plate waste by up to 65%.',
        impactLevel: 'Critical',
        estimatedSavingsMonthly: '₹18,200',
        targetRole: 'Admin',
        icon: 'restaurant_menu',
      ),
      RecommendationModel(
        id: 'rec_3',
        category: 'Portion Sizing',
        title: 'Reduce Standard Serving Ladle Size for Sambar & Dal',
        description: 'Feedback analysis highlights 34% of students reported portion sizes are too large for dinner, resulting in significant plate waste despite positive food taste ratings (4.2/5). Standardize portion sizes to 150ml initial serving.',
        impactLevel: 'Medium',
        estimatedSavingsMonthly: '₹9,800',
        targetRole: 'Kitchen Staff',
        icon: 'straighten',
      ),
      RecommendationModel(
        id: 'rec_4',
        category: 'Student Engagement',
        title: 'Incentivize Student RSVP Confirmations Before 10:00 AM',
        description: 'On days when meal confirmations exceed 85%, preparation prediction error drops from 14.2% to 3.1%. Broadcast push notifications at 8:30 AM to encourage timely attendance toggling.',
        impactLevel: 'Medium',
        estimatedSavingsMonthly: '₹11,000',
        targetRole: 'Admin',
        icon: 'notifications_active',
      ),
    ];
  }

  // Recent Alerts
  static List<AlertModel> getInitialAlerts() {
    return [
      AlertModel(
        id: 'alt_1',
        title: '🔴 Critical: High Vegetable Waste Alert',
        message: "Today's lunch Vegetable Poriyal waste reached 27.9%, exceeding institution target threshold (15.0%) by 12.9%.",
        severity: 'critical',
        targetRole: 'admin',
        timestamp: DateTime.now().subtract(const Duration(minutes: 45)),
        relatedFoodItem: 'Mixed Vegetable Poriyal',
      ),
      AlertModel(
        id: 'alt_2',
        title: '⚠️ Warning: Sambar Waste Buffer Notice',
        message: 'Lunch South Indian Sambar remaining leftover was 18.0 L (19.5%). Consider reducing tomorrow batch prep.',
        severity: 'warning',
        targetRole: 'staff',
        timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 15)),
        relatedFoodItem: 'South Indian Sambar',
      ),
      AlertModel(
        id: 'alt_3',
        title: '🔔 Student Confirmation Reminder',
        message: 'Please confirm your dinner attendance by 5:00 PM to help the kitchen minimize over-preparation.',
        severity: 'normal',
        targetRole: 'student',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      ),
    ];
  }

  // Student Feedback Records
  static List<FeedbackModel> getInitialFeedback() {
    return [
      FeedbackModel(
        id: 'fb_1',
        studentId: 'usr_student_01',
        studentName: 'Aditya Verma',
        foodItem: 'Paneer Butter Masala',
        date: todayStr,
        mealType: 'Lunch',
        tasteRating: 5.0,
        qualityRating: 5.0,
        portionRating: 3.0,
        overallRating: 5.0,
        comments: 'Excellent quality and taste! Perfect serving size.',
        createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
      ),
      FeedbackModel(
        id: 'fb_2',
        studentId: 'usr_student_02',
        studentName: 'Sneha Patel',
        foodItem: 'Mixed Vegetable Poriyal',
        date: todayStr,
        mealType: 'Lunch',
        tasteRating: 2.0,
        qualityRating: 2.5,
        portionRating: 4.0,
        overallRating: 2.0,
        comments: 'Too salty and vegetables were hard to chew. Left half on plate.',
        portionIssueReported: 'too_large',
        createdAt: DateTime.now().subtract(const Duration(minutes: 40)),
      ),
      FeedbackModel(
        id: 'fb_3',
        studentId: 'usr_student_03',
        studentName: 'Karan Singh',
        foodItem: 'Steamed Basmati Rice',
        date: todayStr,
        mealType: 'Lunch',
        tasteRating: 4.0,
        qualityRating: 4.5,
        portionRating: 3.0,
        overallRating: 4.0,
        comments: 'Good, hot and fresh.',
        createdAt: DateTime.now().subtract(const Duration(minutes: 50)),
      ),
    ];
  }
}
