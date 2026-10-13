"""
MealMind - Synthetic Dataset Generator
Generates realistic institutional historical data for food demand, consumption, and waste.
"""

import os
import random
import numpy as np
import pandas as pd
from datetime import datetime, timedelta

# Fix seed for reproducibility
np.random.seed(42)
random.seed(42)

FOOD_ITEMS = {
    "Breakfast": [
        {"name": "Idli & Sambar", "unit": "kg", "base_portion": 0.25, "cost": 40.0, "popularity": 4.2},
        {"name": "Poha", "unit": "kg", "base_portion": 0.20, "cost": 35.0, "popularity": 3.8},
        {"name": "Masala Dosa", "unit": "kg", "base_portion": 0.22, "cost": 50.0, "popularity": 4.6},
        {"name": "Upma", "unit": "kg", "base_portion": 0.20, "cost": 30.0, "popularity": 2.9},
    ],
    "Lunch": [
        {"name": "Steamed Rice", "unit": "kg", "base_portion": 0.30, "cost": 45.0, "popularity": 4.1},
        {"name": "South Indian Sambar", "unit": "L", "base_portion": 0.18, "cost": 35.0, "popularity": 4.0},
        {"name": "Paneer Butter Masala", "unit": "kg", "base_portion": 0.15, "cost": 190.0, "popularity": 4.7},
        {"name": "Mixed Vegetable Curry", "unit": "kg", "base_portion": 0.14, "cost": 55.0, "popularity": 3.2},
        {"name": "Chapati", "unit": "kg", "base_portion": 0.12, "cost": 40.0, "popularity": 4.3},
        {"name": "Fresh Curd", "unit": "L", "base_portion": 0.10, "cost": 45.0, "popularity": 4.4},
    ],
    "Snacks": [
        {"name": "Samosa with Chutney", "unit": "kg", "base_portion": 0.15, "cost": 60.0, "popularity": 4.5},
        {"name": "Vegetable Cutlet", "unit": "kg", "base_portion": 0.12, "cost": 50.0, "popularity": 3.6},
        {"name": "Tea & Biscuits", "unit": "L", "base_portion": 0.15, "cost": 25.0, "popularity": 4.0},
    ],
    "Dinner": [
        {"name": "Jeera Rice", "unit": "kg", "base_portion": 0.28, "cost": 50.0, "popularity": 4.3},
        {"name": "Dal Makhani", "unit": "kg", "base_portion": 0.18, "cost": 65.0, "popularity": 4.5},
        {"name": "Aloo Gobi Curry", "unit": "kg", "base_portion": 0.15, "cost": 45.0, "popularity": 3.4},
        {"name": "Tawa Roti", "unit": "kg", "base_portion": 0.12, "cost": 40.0, "popularity": 4.2},
        {"name": "Egg Curry", "unit": "kg", "base_portion": 0.16, "cost": 90.0, "popularity": 4.4},
        {"name": "Fruit Salad", "unit": "kg", "base_portion": 0.10, "cost": 75.0, "popularity": 4.1},
    ],
}

TOTAL_ENROLLED_STUDENTS = 550

def generate_dataset(start_date="2026-05-01", num_days=90):
    start = datetime.strptime(start_date, "%Y-%m-%d")
    records = []

    # Historical moving average tracker
    item_waste_history = {}

    for d in range(num_days):
        current_date = start + timedelta(days=d)
        date_str = current_date.strftime("%Y-%m-%d")
        day_of_week = current_date.strftime("%A")
        is_weekend = 1 if current_date.weekday() >= 5 else 0

        # Special institutional flags
        is_holiday = 1 if (d in [15, 45, 75] or (is_weekend and random.random() < 0.2)) else 0
        is_exam = 1 if (40 <= d <= 55) else 0
        is_event = 1 if (d in [10, 28, 65, 82]) else 0

        for meal_type, items in FOOD_ITEMS.items():
            # Base attendance modulation
            base_attendance = TOTAL_ENROLLED_STUDENTS
            if is_holiday:
                base_attendance *= random.uniform(0.40, 0.55)
            elif is_weekend:
                base_attendance *= random.uniform(0.60, 0.75)
            elif is_exam:
                base_attendance *= random.uniform(0.88, 0.96)
            elif is_event:
                base_attendance *= random.uniform(0.95, 1.05)
            else:
                base_attendance *= random.uniform(0.82, 0.94)

            actual_attendance = int(base_attendance)

            # Confirmations (usually 85-98% of students who will attend confirm)
            confirm_ratio = random.uniform(0.88, 0.97)
            meal_confirmations = int(actual_attendance * confirm_ratio)
            # A few students confirm but miss out (no-show), a few walk in without confirming
            no_shows = int(meal_confirmations * random.uniform(0.02, 0.08))
            walk_ins = int((actual_attendance - (meal_confirmations - no_shows)))
            if walk_ins < 0:
                walk_ins = 0

            expected_attendance = int(meal_confirmations * 1.05 + random.randint(-5, 10))

            for item in items:
                food_name = item["name"]
                unit = item["unit"]
                cost_per_unit = item["cost"]
                base_portion = item["base_portion"]
                base_pop = item["popularity"]

                # Add noise to food rating
                rating = round(float(np.clip(np.random.normal(base_pop, 0.35), 1.0, 5.0)), 1)

                # Planned & Prepared calculation
                planned_qty = round(expected_attendance * base_portion, 2)
                
                # Kitchen prep variation (often kitchen prepares 5-15% extra to be safe)
                prep_buffer = random.uniform(1.02, 1.18)
                prepared_qty = round(planned_qty * prep_buffer, 2)

                # Consumption depends on actual attendance and food rating
                portion_eaten_factor = 1.0
                if rating < 3.0:
                    portion_eaten_factor *= 0.82  # Low satisfaction = high plate waste
                elif rating > 4.5:
                    portion_eaten_factor *= 1.06  # Highly liked

                consumed_qty = round(min(prepared_qty * 0.98, actual_attendance * base_portion * portion_eaten_factor), 2)
                if consumed_qty > prepared_qty:
                    consumed_qty = prepared_qty

                waste_qty = round(max(0.0, prepared_qty - consumed_qty), 2)
                waste_pct = round((waste_qty / prepared_qty) * 100.0, 2) if prepared_qty > 0 else 0.0
                waste_cost = round(waste_qty * cost_per_unit, 2)

                # Risk category
                if waste_pct < 10.0:
                    waste_risk = "Low"
                elif waste_pct <= 20.0:
                    waste_risk = "Medium"
                else:
                    waste_risk = "High"

                # Historical waste moving average
                hist_key = f"{meal_type}_{food_name}"
                if hist_key not in item_waste_history:
                    item_waste_history[hist_key] = []
                
                hist_avg = np.mean(item_waste_history[hist_key][-7:]) if item_waste_history[hist_key] else waste_qty
                item_waste_history[hist_key].append(waste_qty)

                records.append({
                    "date": date_str,
                    "day_of_week": day_of_week,
                    "is_weekend": is_weekend,
                    "meal_type": meal_type,
                    "food_item": food_name,
                    "unit": unit,
                    "planned_quantity": planned_qty,
                    "prepared_quantity": prepared_qty,
                    "expected_attendance": expected_attendance,
                    "actual_attendance": actual_attendance,
                    "meal_confirmations": meal_confirmations,
                    "consumed_quantity": consumed_qty,
                    "waste_quantity": waste_qty,
                    "waste_percentage": waste_pct,
                    "waste_risk": waste_risk,
                    "food_rating": rating,
                    "food_cost": cost_per_unit,
                    "waste_cost": waste_cost,
                    "holiday": is_holiday,
                    "exam_period": is_exam,
                    "event_day": is_event,
                    "historical_waste": round(float(hist_avg), 2),
                })

    df = pd.DataFrame(records)
    return df

if __name__ == "__main__":
    current_dir = os.path.dirname(os.path.abspath(__file__))
    output_path = os.path.join(current_dir, "mealmind_dataset.csv")
    df = generate_dataset()
    df.to_csv(output_path, index=False)
    print(f"Generated {len(df)} records across 90 days. Saved to: {output_path}")
    print(df.head(5))
