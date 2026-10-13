/// Core constants used across the MealMind application
class AppConstants {
  static const String appName = 'MealMind';
  static const String appTagline = 'AI-Powered Food Waste Tracking & Prevention';
  static const String appVersion = 'v1.0.0 (Production)';

  // Supported User Roles
  static const String roleAdmin = 'admin';
  static const String roleStaff = 'staff';
  static const String roleStudent = 'student';

  // Meal Types
  static const List<String> mealTypes = [
    'Breakfast',
    'Lunch',
    'Snacks',
    'Dinner',
  ];

  // Measurement Units
  static const List<String> units = [
    'kg',
    'L',
    'portions',
    'pieces',
  ];

  // Food Waste Types
  static const List<String> wasteTypes = [
    'Preparation waste',
    'Cooking waste',
    'Leftover food',
    'Plate waste',
    'Spoiled food',
    'Expired food',
    'Overproduction',
  ];

  // Food Waste Reasons
  static const List<String> wasteReasons = [
    'Excess preparation',
    'Low attendance',
    'Poor taste',
    'Poor quality',
    'Large portion size',
    'Menu not preferred',
    'Spoilage',
    'Expired',
    'Other',
  ];

  // Environmental Impact Factors (Documented scientific baselines)
  // 1 kg food waste ≈ 2.5 kg CO2 equivalent emissions (FAO / UNEP benchmark)
  static const double co2PerKgWaste = 2.5; 
  // 1 kg food waste ≈ 1,000 Litres embedded water footprint
  static const double waterLitresPerKgWaste = 1000.0;
  // Standard default waste threshold target percentage
  static const double defaultTargetWastePercent = 15.0;

  // Local Storage Keys
  static const String keyUserRole = 'mealmind_user_role';
  static const String keyUserId = 'mealmind_user_id';
  static const String keyUserName = 'mealmind_user_name';
  static const String keyUserEmail = 'mealmind_user_email';
  static const String keyInstitution = 'mealmind_institution';
  static const String keyTargetWasteThreshold = 'mealmind_waste_threshold';
  static const String keyApiUrl = 'mealmind_api_url';
  
  // Default API URL (FastAPI backend local/LAN default)
  static const String defaultApiBaseUrl = 'http://127.0.0.1:8000';
}
