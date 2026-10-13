# MealMind: REST API Documentation

The MealMind AI/ML Engine is served via **FastAPI** with automatic Swagger interactive documentation (`/docs`) and ReDoc (`/redoc`).

Base URL: `http://127.0.0.1:8000`

---

## 1. System Health & Metadata

### `GET /health`
Checks whether the ML engine is active and returns loaded model metrics.

**Response (200 OK):**
```json
{
  "status": "healthy",
  "models_loaded": true,
  "metrics": {
    "demand_prediction": {
      "champion_model": "GradientBoostingRegressor",
      "selected_metrics": { "MAE": 2.37, "RMSE": 3.20, "R2": 0.9879 }
    },
    "waste_risk_classification": {
      "champion_model": "LogisticRegression",
      "selected_metrics": { "Accuracy": 0.807, "Precision": 0.845, "Recall": 0.807, "F1_Score": 0.7374 }
    }
  }
}
```

---

## 2. Food Demand Prediction

### `POST /predict/demand`
Predicts consumption quantity and generates explainable preparation targets.

**Request Body:**
```json
{
  "day_of_week": "Monday",
  "meal_type": "Lunch",
  "food_item": "Steamed Rice",
  "unit": "kg",
  "expected_attendance": 520,
  "meal_confirmations": 490,
  "food_rating": 4.1,
  "food_cost": 45.0,
  "holiday": 0,
  "exam_period": 0,
  "event_day": 0,
  "historical_waste": 5.5
}
```

**Response (200 OK):**
```json
{
  "food_item": "Steamed Rice",
  "meal_type": "Lunch",
  "expected_attendance": 520,
  "meal_confirmations": 490,
  "predicted_consumption": 147.2,
  "recommended_preparation": 153.1,
  "unit": "kg",
  "confidence_score": 92.5,
  "explainable_factors": [
    { "factor": "Expected Attendance", "value": "520 students", "impact": "Primary baseline (+85%)" },
    { "factor": "Meal Confirmations (RSVP)", "value": "490 confirmations", "impact": "High confidence (94.2% RSVP rate)" },
    { "factor": "Student Food Rating", "value": "4.1 / 5.0", "impact": "Positive consumption multiplier" },
    { "factor": "Calendar Flags", "value": "Holiday: False, Exam: False, Event: False", "impact": "Modulated for schedule variation" },
    { "factor": "Recent Historical Waste", "value": "5.5 kg", "impact": "Trimmed overproduction buffer to 4%" }
  ],
  "model_type": "RandomForestRegressor / GradientBoosting Ensemble",
  "is_ai_estimate": true
}
```

---

## 3. Waste Risk Prediction & Threshold Alert

### `POST /predict/waste`
Evaluates whether a food item is predicted to generate `Low`, `Medium`, or `High` waste risk.

**Request Body:**
```json
{
  "day_of_week": "Tuesday",
  "meal_type": "Lunch",
  "food_item": "Mixed Vegetable Poriyal",
  "expected_attendance": 500,
  "meal_confirmations": 450,
  "food_rating": 2.8,
  "food_cost": 55.0,
  "target_threshold_percent": 15.0
}
```

**Response (200 OK):**
```json
{
  "food_item": "Mixed Vegetable Poriyal",
  "meal_type": "Lunch",
  "predicted_risk_level": "High",
  "predicted_waste_percentage": 26.4,
  "risk_probabilities": {
    "Low": 0.08,
    "Medium": 0.22,
    "High": 0.70
  },
  "target_threshold_percent": 15.0,
  "exceeds_threshold": true,
  "alert_message": "Mixed Vegetable Poriyal waste is predicted at 26.4%, exceeding your target threshold of 15.0% by 11.4%.",
  "actionable_suggestion": "Consider reducing preparation quantity by approximately 10-15% or preparing in staggered batches.",
  "is_ai_estimate": true
}
```

---

## 4. Prescriptive Recommendations

### `GET /recommendations`
Returns actionable kitchen and administrative interventions with projected monthly savings.

**Response (200 OK):**
```json
{
  "total_recommendations": 5,
  "recommendations": [
    {
      "id": "rec-1",
      "category": "Preparation Batching",
      "title": "Implement 2-Stage Staggered Cooking for Rice & Sambar",
      "description": "Historical logs indicate 18% of lunchtime food waste occurs due to initial over-preparation. Prepare 70% of estimated quantity at 11:30 AM and the remaining 30% only after 1:00 PM if RSVP attendance peaks.",
      "impact_level": "High",
      "estimated_savings_monthly": "₹14,500",
      "target_role": "Kitchen Staff",
      "icon": "soup_kitchen"
    }
  ]
}
```

---

## 5. Strategic Menu Matrix

### `GET /menu/optimization-matrix`
Returns the 4-quadrant food item classification (*Stars*, *Workhorses*, *Portion Mismatches*, *Re-evaluations*).

---

## 6. Smart IoT Scale Event Ingestion

### `POST /iot/waste-event`
Receives automatic weight measurements from ESP32 smart weighing scales.

**Request Body:**
```json
{
  "device_id": "ESP32_MESS_BIN_01",
  "dining_hall_id": "hall_a",
  "meal_type": "Lunch",
  "food_item": "Mixed Plate Waste",
  "waste_weight_kg": 12.45,
  "waste_type": "Plate waste"
}
```

**Response (200 OK):**
```json
{
  "status": "accepted",
  "message": "Successfully logged 12.45 kg from device ESP32_MESS_BIN_01",
  "received_event": { ... }
}
```
