# MealMind: Testing Documentation & Test Matrix

This document provides a comprehensive test plan, automated verification procedures, and manual validation checklists for MealMind.

---

## 1. Automated Test Suites

### 1.1 Python ML & API Test Suite (`mealmind_ml/test_ml.py`)
Run via:
```bash
cd mealmind_ml
python -m pytest test_ml.py -v
```

| Test Case Name | Target Module | Pass Condition | Result |
| :--- | :--- | :--- | :--- |
| `test_dataset_generation` | `data_generator.py` | Generates 100+ rows with valid physical ranges ($\ge 0$ kg) | ✅ **PASSED** |
| `test_model_training_and_serialization` | `train_models.py` | Trains regressor ($R^2 > 0.60$) and classifier ($F_1 > 0.60$), saves `.joblib` | ✅ **PASSED** |
| `test_predictor_demand` | `predictor.py` | Returns positive prep target with explainable factors array | ✅ **PASSED** |
| `test_predictor_waste` | `predictor.py` | Returns predicted waste risk (`Low`/`Med`/`High`) and alert text | ✅ **PASSED** |
| `test_recommendation_engine` | `recommendation_engine.py` | Returns $\ge 4$ interventions and 4-quadrant menu matrix | ✅ **PASSED** |
| `test_api_health_endpoint` | `app.py` | `GET /health` returns status `healthy` and metrics dictionary | ✅ **PASSED** |
| `test_api_predict_demand_endpoint`| `app.py` | `POST /predict/demand` returns explainable forecast | ✅ **PASSED** |
| `test_api_iot_event` | `app.py` | `POST /iot/waste-event` accepts and stores load cell weight | ✅ **PASSED** |

### 1.2 Flutter Unit Tests (`mealmind_app/test/`)
- `test/calculations_test.dart`: Validates waste quantity, percentage formulas, currency cost multiplication, savings delta, and zero-division protection.
- `test/models_test.dart`: Validates JSON map serialization and deserialization across all data models.

---

## 2. Manual Verification Checklist (30 Screens)

### Common Flow:
- [x] **Splash Screen**: Loads app branding, verifies auth state, and redirects to appropriate role shell.
- [x] **Login Screen**: Quick Demo Role Selector buttons allow 1-tap switching between Student, Staff, and Admin.
- [x] **Register Screen**: Validates student ID, institution name, email, and password.
- [x] **Forgot Password**: Submits recovery link.

### Student Role:
- [x] **Student Dashboard**: Live lunch menu card, immediate RSVP toggle, eco impact badge.
- [x] **Today's Menu**: Filter by Breakfast, Lunch, Snacks, Dinner with portion sizes (grams) and rating stars.
- [x] **Meal Confirmation (RSVP)**: Interactive YES/NO attendance toggles across 4 daily meal slots.
- [x] **Feedback & Rating Screen**: Multi-factor 5-star ratings (Taste, Quality, Portion satisfaction, Overall) + portion issue reporting.
- [x] **My Impact**: Personal food saved, $\text{CO}_2\text{e}$ avoided, water footprint saved, assumptions disclaimer.
- [x] **Student Notifications**: Push reminders to confirm upcoming meals.
- [x] **Student Profile**: Roll number, institution, role switch drawer.

### Kitchen Staff Role:
- [x] **Staff Dashboard**: Today's prep vs consumed progress bars, live waste %, critical threshold alert banner.
- [x] **Menu Management**: Add, edit, delete menu items with planned quantities and raw costs per unit.
- [x] **Food Preparation Log**: Enter cooking batch quantity, batch ID, and chef notes.
- [x] **Food Consumption**: Enter consumed quantity; real-time automatic calculation of waste quantity and waste percentage.
- [x] **Record Food Waste**: 7 waste types, 9 waste reasons, financial loss calculation, staff attribution.
- [x] **Waste History**: Searchable and filterable table by meal and waste type.
- [x] **AI Demand Forecast**: View recommended preparation targets, turnout forecast, and explainable AI attribution factors.
- [x] **Kitchen Alerts**: Threshold over-run notices.

### Admin Role:
- [x] **Admin Dashboard**: Executive KPI cards, weekly waste trend line chart, upcoming demand forecasts, priority recommendations.
- [x] **Analytics Screen**: Segmented Daily/Weekly/Monthly waste volume charts and attendance correlation table.
- [x] **Waste Breakdown Screen**: Donut chart of primary waste reasons and item-wise waste distribution bar list.
- [x] **Cost Analysis Screen**: Daily, weekly, monthly financial loss summaries and projected monthly savings.
- [x] **AI Predictions Admin**: Rerun ML models and inspect confidence scores.
- [x] **Recommendations & Matrix**: 4-quadrant menu performance matrix (*Stars*, *Workhorses*, *Portion Mismatches*, *Re-evaluations*).
- [x] **User Management**: Roster of students and kitchen staff.
- [x] **Institution Dining Halls**: Mess capacities, active diners, and staff allocation.
- [x] **Reports Screen**: Generate audit summaries and export formatted CSV data or printable PDF reports.
- [x] **Settings Screen**: Adjust acceptable waste threshold slider (e.g. 15.0%) and Python FastAPI URL.

---

## 3. Error Handling & Edge Case Resilience

1. **FastAPI ML Server Offline**: The Flutter client includes a built-in heuristic predictor with explainability attributes, ensuring the mobile app never crashes or hangs when the Python server is offline.
2. **Zero/Negative Quantities**: All calculation methods in `Calculations.dart` safely clamp outputs to $\ge 0.0$ and return $0.0$ for empty or zero denominators.
3. **Double RSVP Prevention**: Duplicate student RSVP toggles update the existing record rather than appending duplicate rows.
