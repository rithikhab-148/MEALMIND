# MealMind: Database Schema & Entity Design

This document details the Cloud Firestore collection structures, document schemas, fields, data types, and indexing strategy for the MealMind system.

---

## 1. Firestore Collections Overview

| # | Collection Name | Purpose | Primary Document Key |
| :--- | :--- | :--- | :--- |
| 1 | `users` | User profiles with roles (`admin`, `staff`, `student`) | `uid` (Firebase Auth UID) |
| 2 | `institutions` | College, school, hospital, or corporate campus details | `institution_id` |
| 3 | `dining_halls` | Mess facilities and cafeterias | `hall_id` |
| 4 | `food_items` | Master catalogue of institutional food items & raw costs | `item_id` |
| 5 | `menus` | Planned daily meal menus by date and meal session | `menu_id` |
| 6 | `meal_sessions` | Operational timing slots (Breakfast, Lunch, Snacks, Dinner) | `session_id` |
| 7 | `meal_responses` | Student RSVP intention toggles (`YES`, `NO`) | `response_id` |
| 8 | `food_preparation` | Kitchen cooking batch logs with timestamps | `prep_id` |
| 9 | `food_consumption` | Post-meal prepared vs consumed tracking | `consumption_id` |
| 10 | `food_waste` | Granular waste records with reasons, types, and loss cost | `waste_id` |
| 11 | `waste_reasons` | Standard taxonomy of 9 waste root causes | `reason_id` |
| 12 | `feedback` | Student 5-star multi-factor meal reviews & portion issues | `feedback_id` |
| 13 | `predictions` | AI demand forecasts with explainable factors | `pred_id` |
| 14 | `recommendations`| AI prescriptive kitchen optimization interventions | `rec_id` |
| 15 | `notifications` | FCM and in-app threshold alerts | `notif_id` |
| 16 | `reports` | Daily, weekly, monthly food audit summaries | `report_id` |
| 17 | `settings` | Institution threshold targets and system parameters | `setting_id` |

---

## 2. Collection Schemas in Detail

### 1. `users`
```json
{
  "id": "String (UID)",
  "name": "String",
  "email": "String",
  "role": "String ('admin' | 'staff' | 'student')",
  "institution_id": "String (ref: institutions.id)",
  "dining_hall_id": "String? (ref: dining_halls.id)",
  "student_id_number": "String?",
  "meals_confirmed_count": "Integer",
  "personal_food_saved_kg": "Double",
  "created_at": "Timestamp"
}
```

### 2. `menus`
```json
{
  "id": "String",
  "date": "String (YYYY-MM-DD)",
  "meal_type": "String ('Breakfast' | 'Lunch' | 'Snacks' | 'Dinner')",
  "food_item": "String",
  "quantity_planned": "Double",
  "serving_size_grams": "Double",
  "cost_per_unit": "Double",
  "unit": "String ('kg' | 'L' | 'portions')",
  "average_rating": "Double",
  "rating_count": "Integer",
  "is_special_item": "Boolean"
}
```

### 3. `meal_responses` (Student RSVPs)
```json
{
  "id": "String",
  "student_id": "String (ref: users.id)",
  "student_name": "String",
  "date": "String (YYYY-MM-DD)",
  "meal_type": "String",
  "response": "String ('YES' | 'NO')",
  "timestamp": "Timestamp",
  "dining_hall_id": "String?"
}
```

### 4. `food_preparation`
```json
{
  "id": "String",
  "food_item": "String",
  "quantity_prepared": "Double",
  "unit": "String",
  "date": "String (YYYY-MM-DD)",
  "meal_type": "String",
  "prep_time": "Timestamp",
  "staff_name": "String",
  "batch_number": "String?",
  "notes": "String?"
}
```

### 5. `food_consumption`
```json
{
  "id": "String",
  "food_item": "String",
  "prepared_quantity": "Double",
  "consumed_quantity": "Double",
  "remaining_quantity": "Double",
  "waste_quantity": "Double (prepared - consumed)",
  "waste_percentage": "Double ((waste / prepared) * 100)",
  "unit": "String",
  "date": "String (YYYY-MM-DD)",
  "meal_type": "String",
  "recorded_at": "Timestamp"
}
```

### 6. `food_waste`
```json
{
  "id": "String",
  "food_item": "String",
  "waste_quantity": "Double",
  "unit": "String",
  "waste_type": "String ('Preparation waste' | 'Plate waste' | 'Leftover food' | 'Spoiled food' | ...)",
  "waste_reason": "String ('Excess preparation' | 'Low attendance' | 'Poor taste' | 'Large portion size' | ...)",
  "date": "String (YYYY-MM-DD)",
  "meal_type": "String",
  "cost_per_unit": "Double",
  "waste_cost": "Double (waste_quantity * cost_per_unit)",
  "notes": "String?",
  "staff_name": "String",
  "recorded_at": "Timestamp"
}
```

### 7. `feedback`
```json
{
  "id": "String",
  "student_id": "String (ref: users.id)",
  "student_name": "String",
  "food_item": "String",
  "date": "String (YYYY-MM-DD)",
  "meal_type": "String",
  "taste_rating": "Double (1.0 to 5.0)",
  "quality_rating": "Double (1.0 to 5.0)",
  "portion_rating": "Double (1.0 to 5.0)",
  "overall_rating": "Double (1.0 to 5.0)",
  "comments": "String?",
  "portion_issue_reported": "String? ('too_large' | 'too_small' | 'optimal')",
  "created_at": "Timestamp"
}
```

### 8. `predictions`
```json
{
  "id": "String",
  "food_item": "String",
  "meal_type": "String",
  "expected_attendance": "Integer",
  "meal_confirmations": "Integer",
  "predicted_consumption": "Double",
  "recommended_preparation": "Double",
  "unit": "String",
  "confidence_score": "Double (e.g. 94.2)",
  "predicted_risk_level": "String ('Low' | 'Medium' | 'High')",
  "predicted_waste_percentage": "Double",
  "exceeds_threshold": "Boolean",
  "alert_message": "String?",
  "actionable_suggestion": "String?",
  "explainable_factors": [
    {
      "factor": "String",
      "value": "String",
      "impact": "String"
    }
  ],
  "is_ai_estimate": "Boolean"
}
```

### 9. `recommendations`
```json
{
  "id": "String",
  "category": "String ('Preparation Batching' | 'Menu Optimization' | 'Portion Sizing' | ...)",
  "title": "String",
  "description": "String",
  "impact_level": "String ('Critical' | 'High' | 'Medium' | 'Low')",
  "estimated_savings_monthly": "String (e.g. '₹18,200')",
  "target_role": "String ('Kitchen Staff' | 'Admin' | 'All')",
  "icon": "String",
  "is_applied": "Boolean"
}
```

### 10. `settings`
```json
{
  "institution_id": "String",
  "target_waste_threshold_percent": "Double (default 15.0)",
  "co2_conversion_factor": "Double (default 2.5)",
  "water_conversion_factor": "Double (default 1000.0)",
  "api_base_url": "String",
  "updated_at": "Timestamp"
}
```
