"""
MealMind - ML Model Training Pipeline
Trains, evaluates, and selects best-in-class models for Food Demand Prediction and Waste Risk Classification.
"""

import os
import json
import joblib
import numpy as np
import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import OneHotEncoder, StandardScaler
from sklearn.compose import ColumnTransformer
from sklearn.pipeline import Pipeline
from sklearn.linear_model import LinearRegression, LogisticRegression
from sklearn.ensemble import RandomForestRegressor, GradientBoostingRegressor, RandomForestClassifier
from sklearn.metrics import (
    mean_absolute_error, mean_squared_error, r2_score,
    accuracy_score, precision_score, recall_score, f1_score, classification_report
)

def train_and_evaluate(dataset_path=None, output_dir=None):
    if dataset_path is None:
        dataset_path = os.path.join(os.path.dirname(os.path.abspath(__file__)), "mealmind_dataset.csv")
    if output_dir is None:
        output_dir = os.path.join(os.path.dirname(os.path.abspath(__file__)), "models")
    
    os.makedirs(output_dir, exist_ok=True)

    if not os.path.exists(dataset_path):
        from data_generator import generate_dataset
        df = generate_dataset()
        df.to_csv(dataset_path, index=False)
    else:
        df = pd.read_csv(dataset_path)

    print(f"Loaded dataset with {len(df)} rows and {len(df.columns)} columns.")

    # Categorical & Numerical feature definitions
    cat_features = ["day_of_week", "meal_type", "food_item"]
    num_features = [
        "is_weekend", "expected_attendance", "meal_confirmations", 
        "food_rating", "food_cost", "holiday", "exam_period", 
        "event_day", "historical_waste"
    ]

    # ==========================================
    # 1. DEMAND PREDICTION (REGRESSION)
    # Target: consumed_quantity
    # ==========================================
    X_reg = df[cat_features + num_features]
    y_reg = df["consumed_quantity"]

    X_train_reg, X_test_reg, y_train_reg, y_test_reg = train_test_split(
        X_reg, y_reg, test_size=0.2, random_state=42
    )

    reg_preprocessor = ColumnTransformer(
        transformers=[
            ("cat", OneHotEncoder(handle_unknown="ignore", sparse_output=False), cat_features),
            ("num", StandardScaler(), num_features),
        ]
    )

    reg_candidates = {
        "LinearRegression": LinearRegression(),
        "RandomForestRegressor": RandomForestRegressor(n_estimators=100, max_depth=12, random_state=42),
        "GradientBoostingRegressor": GradientBoostingRegressor(n_estimators=120, learning_rate=0.08, max_depth=5, random_state=42),
    }

    reg_results = {}
    best_reg_name = None
    best_reg_r2 = -float("inf")
    best_reg_pipe = None

    print("\n--- Training Demand Prediction Regressors ---")
    for name, model in reg_candidates.items():
        pipe = Pipeline(steps=[("preprocessor", reg_preprocessor), ("model", model)])
        pipe.fit(X_train_reg, y_train_reg)
        y_pred = pipe.predict(X_test_reg)

        mae = mean_absolute_error(y_test_reg, y_pred)
        rmse = np.sqrt(mean_squared_error(y_test_reg, y_pred))
        r2 = r2_score(y_test_reg, y_pred)

        reg_results[name] = {"MAE": round(mae, 3), "RMSE": round(rmse, 3), "R2": round(r2, 4)}
        print(f"[{name}] -> MAE: {mae:.3f} | RMSE: {rmse:.3f} | R2: {r2:.4f}")

        if r2 > best_reg_r2:
            best_reg_r2 = r2
            best_reg_name = name
            best_reg_pipe = pipe

    print(f"\nChampion Demand Model Selected: {best_reg_name} (R2: {best_reg_r2:.4f})")

    # ==========================================
    # 2. WASTE RISK PREDICTION (CLASSIFICATION)
    # Target: waste_risk ("Low", "Medium", "High")
    # ==========================================
    X_cls = df[cat_features + num_features]
    y_cls = df["waste_risk"]

    X_train_cls, X_test_cls, y_train_cls, y_test_cls = train_test_split(
        X_cls, y_cls, test_size=0.2, random_state=42, stratify=y_cls
    )

    cls_preprocessor = ColumnTransformer(
        transformers=[
            ("cat", OneHotEncoder(handle_unknown="ignore", sparse_output=False), cat_features),
            ("num", StandardScaler(), num_features),
        ]
    )

    cls_candidates = {
        "LogisticRegression": LogisticRegression(max_iter=1000, random_state=42),
        "RandomForestClassifier": RandomForestClassifier(n_estimators=100, max_depth=10, random_state=42),
    }

    cls_results = {}
    best_cls_name = None
    best_cls_f1 = -float("inf")
    best_cls_pipe = None

    print("\n--- Training Waste Risk Classifiers ---")
    for name, model in cls_candidates.items():
        pipe = Pipeline(steps=[("preprocessor", cls_preprocessor), ("model", model)])
        pipe.fit(X_train_cls, y_train_cls)
        y_pred = pipe.predict(X_test_cls)

        acc = accuracy_score(y_test_cls, y_pred)
        prec = precision_score(y_test_cls, y_pred, average="weighted", zero_division=0)
        rec = recall_score(y_test_cls, y_pred, average="weighted", zero_division=0)
        f1 = f1_score(y_test_cls, y_pred, average="weighted", zero_division=0)

        cls_results[name] = {
            "Accuracy": round(acc, 4),
            "Precision": round(prec, 4),
            "Recall": round(rec, 4),
            "F1_Score": round(f1, 4),
        }
        print(f"[{name}] -> Accuracy: {acc:.4f} | Precision: {prec:.4f} | Recall: {rec:.4f} | F1: {f1:.4f}")

        if f1 > best_cls_f1:
            best_cls_f1 = f1
            best_cls_name = name
            best_cls_pipe = pipe

    print(f"\nChampion Waste Classifier Selected: {best_cls_name} (F1: {best_cls_f1:.4f})")

    # ==========================================
    # 3. SAVE MODELS & METADATA
    # ==========================================
    demand_model_path = os.path.join(output_dir, "demand_model.joblib")
    waste_model_path = os.path.join(output_dir, "waste_model.joblib")

    joblib.dump(best_reg_pipe, demand_model_path)
    joblib.dump(best_cls_pipe, waste_model_path)

    metrics_payload = {
        "demand_prediction": {
            "champion_model": best_reg_name,
            "all_models": reg_results,
            "selected_metrics": reg_results[best_reg_name],
        },
        "waste_risk_classification": {
            "champion_model": best_cls_name,
            "all_models": cls_results,
            "selected_metrics": cls_results[best_cls_name],
        },
        "features": {
            "categorical": cat_features,
            "numerical": num_features,
        }
    }

    metrics_file = os.path.join(output_dir, "model_metrics.json")
    with open(metrics_file, "w") as f:
        json.dump(metrics_payload, f, indent=2)

    print(f"\nSaved models and metrics to {output_dir}")
    return metrics_payload

if __name__ == "__main__":
    train_and_evaluate()
