"""
MealMind - ML & API Test Suite
Validates dataset generation, model training, explainable inference, and FastAPI endpoints.
"""

import os
import pytest
from fastapi.testclient import TestClient
from data_generator import generate_dataset
from train_models import train_and_evaluate
from predictor import MealMindPredictor
from recommendation_engine import RecommendationEngine
from app import app

client = TestClient(app)

def test_dataset_generation():
    df = generate_dataset(num_days=10)
    assert len(df) > 0
    assert "consumed_quantity" in df.columns
    assert "waste_risk" in df.columns
    assert "meal_confirmations" in df.columns
    assert df["waste_quantity"].min() >= 0.0

def test_model_training_and_serialization(tmp_path):
    metrics = train_and_evaluate(output_dir=str(tmp_path))
    assert "demand_prediction" in metrics
    assert "waste_risk_classification" in metrics
    assert os.path.exists(os.path.join(tmp_path, "demand_model.joblib"))
    assert os.path.exists(os.path.join(tmp_path, "waste_model.joblib"))
    assert metrics["demand_prediction"]["selected_metrics"]["R2"] > 0.60
    assert metrics["waste_risk_classification"]["selected_metrics"]["F1_Score"] > 0.60

def test_predictor_demand():
    predictor = MealMindPredictor()
    input_data = {
        "day_of_week": "Monday",
        "meal_type": "Lunch",
        "food_item": "Steamed Rice",
        "unit": "kg",
        "expected_attendance": 520,
        "meal_confirmations": 490,
        "food_rating": 4.2,
        "food_cost": 45.0,
        "holiday": 0,
        "exam_period": 0,
        "event_day": 0,
        "historical_waste": 6.0,
    }
    result = predictor.predict_demand(input_data)
    assert "recommended_preparation" in result
    assert result["recommended_preparation"] > 0
    assert "explainable_factors" in result
    assert len(result["explainable_factors"]) > 0

def test_predictor_waste():
    predictor = MealMindPredictor()
    input_data = {
        "day_of_week": "Tuesday",
        "meal_type": "Lunch",
        "food_item": "Mixed Vegetable Curry",
        "expected_attendance": 500,
        "meal_confirmations": 450,
        "food_rating": 2.8,
        "target_threshold_percent": 15.0,
    }
    result = predictor.predict_waste_risk(input_data)
    assert "predicted_risk_level" in result
    assert "predicted_waste_percentage" in result
    assert "alert_message" in result

def test_recommendation_engine():
    recs = RecommendationEngine.generate_recommendations()
    assert len(recs) >= 4
    matrix = RecommendationEngine.get_menu_optimization_matrix()
    assert "stars" in matrix
    assert "re_evaluations" in matrix

def test_api_health_endpoint():
    response = client.get("/health")
    assert response.status_code == 200
    data = response.json()
    assert data["status"] == "healthy"

def test_api_predict_demand_endpoint():
    payload = {
        "day_of_week": "Wednesday",
        "meal_type": "Lunch",
        "food_item": "Steamed Rice",
        "expected_attendance": 500,
        "meal_confirmations": 480
    }
    response = client.post("/predict/demand", json=payload)
    assert response.status_code == 200
    data = response.json()
    assert "recommended_preparation" in data
    assert data["is_ai_estimate"] is True

def test_api_iot_event():
    payload = {
        "device_id": "ESP32_TEST_SCALE",
        "dining_hall_id": "hall_main",
        "meal_type": "Dinner",
        "food_item": "Plate Scrapings",
        "waste_weight_kg": 8.75,
        "waste_type": "Plate waste"
    }
    response = client.post("/iot/waste-event", json=payload)
    assert response.status_code == 200
    data = response.json()
    assert data["status"] == "accepted"
