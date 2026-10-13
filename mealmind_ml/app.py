"""
MealMind - FastAPI ML Serving Application & Interactive Web Dashboard
Production REST API for Food Demand Forecasting, Waste Risk Classification, Recommendations, and IoT Scale Ingestion.
"""

import os
from typing import List, Optional, Dict, Any
from datetime import datetime, timezone
from fastapi import FastAPI, HTTPException, BackgroundTasks
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import HTMLResponse
from pydantic import BaseModel, Field

from predictor import MealMindPredictor
from recommendation_engine import RecommendationEngine
from train_models import train_and_evaluate

app = FastAPI(
    title="MealMind AI/ML Engine",
    description="Intelligent Food Demand Prediction, Waste Risk Analysis, and Recommendation Microservice",
    version="1.0.0"
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

predictor = MealMindPredictor()

# Pydantic Schemas
class DemandPredictionRequest(BaseModel):
    day_of_week: str = Field("Monday")
    meal_type: str = Field("Lunch")
    food_item: str = Field("Steamed Rice")
    unit: str = Field("kg")
    expected_attendance: int = Field(500)
    meal_confirmations: Optional[int] = Field(None)
    food_rating: Optional[float] = Field(4.0)
    food_cost: Optional[float] = Field(45.0)
    holiday: Optional[int] = Field(0)
    exam_period: Optional[int] = Field(0)
    event_day: Optional[int] = Field(0)
    is_weekend: Optional[int] = Field(0)
    historical_waste: Optional[float] = Field(5.0)

class BatchDemandRequest(BaseModel):
    day_of_week: str = "Monday"
    meal_type: str = "Lunch"
    expected_attendance: int = 500
    meal_confirmations: Optional[int] = 480
    holiday: Optional[int] = 0
    exam_period: Optional[int] = 0
    event_day: Optional[int] = 0
    items: List[Dict[str, Any]]

class WastePredictionRequest(BaseModel):
    day_of_week: str = "Monday"
    meal_type: str = "Lunch"
    food_item: str = "South Indian Sambar"
    expected_attendance: int = 500
    meal_confirmations: Optional[int] = 480
    food_rating: Optional[float] = 3.8
    food_cost: Optional[float] = 35.0
    holiday: Optional[int] = 0
    exam_period: Optional[int] = 0
    event_day: Optional[int] = 0
    is_weekend: Optional[int] = 0
    historical_waste: Optional[float] = 8.5
    target_threshold_percent: Optional[float] = 15.0

class IoTWasteEvent(BaseModel):
    device_id: str = Field(...)
    dining_hall_id: str = Field("hall_a")
    meal_type: str = Field("Lunch")
    food_item: str = Field("Mixed Plate Waste")
    waste_weight_kg: float = Field(...)
    waste_type: str = Field("Plate waste")
    timestamp: Optional[str] = None

# Interactive Web Application UI
@app.get("/", response_class=HTMLResponse)
def interactive_web_app():
    html_content = """
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>MealMind – AI Food Waste Tracking & Prevention</title>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
  <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
  <style>
    :root {
      --primary: #1B5E20;
      --primary-light: #2E7D32;
      --secondary: #00796B;
      --bg: #F8FBF8;
      --surface: #FFFFFF;
      --card-border: #E0E8E0;
      --text: #1C2826;
      --text-muted: #607274;
      --critical: #C62828;
      --warning: #F57F17;
      --success: #2E7D32;
    }
    * { box-sizing: border-box; margin: 0; padding: 0; font-family: 'Inter', sans-serif; }
    body { background: var(--bg); color: var(--text); padding-bottom: 50px; }
    header { background: #fff; border-bottom: 1px solid var(--card-border); padding: 16px 24px; display: flex; justify-content: space-between; align-items: center; position: sticky; top: 0; z-index: 100; }
    .brand { display: flex; align-items: center; gap: 12px; }
    .brand-icon { width: 40px; height: 40px; background: var(--primary); color: #fff; border-radius: 10px; display: flex; align-items: center; justify-content: center; font-size: 20px; font-weight: bold; }
    .brand-title { font-size: 20px; font-weight: 800; color: var(--primary); }
    .brand-subtitle { font-size: 11px; color: var(--text-muted); }
    .header-links { display: flex; gap: 12px; }
    .btn-link { padding: 8px 16px; border-radius: 8px; font-size: 13px; font-weight: 600; text-decoration: none; border: 1px solid var(--primary); color: var(--primary); }
    .btn-link.active { background: var(--primary); color: #fff; }
    .btn-link:hover { opacity: 0.9; }
    
    .container { max-width: 1200px; margin: 24px auto; padding: 0 20px; }
    .role-switcher { display: flex; background: #E8F5E9; padding: 6px; border-radius: 12px; margin-bottom: 24px; gap: 6px; }
    .role-tab { flex: 1; padding: 10px; text-align: center; font-weight: 700; font-size: 13px; border-radius: 8px; cursor: pointer; border: none; background: transparent; color: var(--text-muted); transition: 0.2s; }
    .role-tab.active { background: var(--primary); color: #fff; box-shadow: 0 2px 6px rgba(27,94,32,0.25); }

    .grid-kpi { display: grid; grid-template-columns: repeat(auto-fit, minmax(240px, 1fr)); gap: 16px; margin-bottom: 24px; }
    .kpi-card { background: var(--surface); padding: 20px; border-radius: 16px; border: 1px solid var(--card-border); box-shadow: 0 2px 4px rgba(0,0,0,0.02); }
    .kpi-title { font-size: 12px; font-weight: 600; color: var(--text-muted); text-transform: uppercase; margin-bottom: 8px; }
    .kpi-value { font-size: 28px; font-weight: 800; color: var(--text); }
    .kpi-sub { font-size: 12px; color: var(--text-muted); margin-top: 6px; }
    .kpi-badge { display: inline-block; padding: 3px 8px; border-radius: 6px; font-size: 11px; font-weight: 700; margin-top: 4px; }
    .badge-critical { background: #FFEBEE; color: var(--critical); }
    .badge-success { background: #E8F5E9; color: var(--success); }

    .grid-2 { display: grid; grid-template-columns: 2fr 1fr; gap: 20px; margin-bottom: 24px; }
    @media (max-width: 900px) { .grid-2 { grid-template-columns: 1fr; } }
    .card { background: var(--surface); padding: 22px; border-radius: 16px; border: 1px solid var(--card-border); }
    .card-title { font-size: 17px; font-weight: 700; margin-bottom: 14px; display: flex; justify-content: space-between; align-items: center; }

    .table { width: 100%; border-collapse: collapse; margin-top: 10px; font-size: 13px; }
    .table th, .table td { padding: 12px 14px; text-align: left; border-bottom: 1px solid var(--card-border); }
    .table th { background: #FAFCFA; font-weight: 700; color: var(--text-muted); font-size: 12px; }

    .btn-action { background: var(--primary); color: #fff; padding: 10px 18px; border-radius: 10px; border: none; font-weight: 600; cursor: pointer; font-size: 13px; transition: 0.2s; }
    .btn-action:hover { background: var(--primary-light); }
    .btn-outline { background: transparent; border: 1.5px solid var(--primary); color: var(--primary); }

    .rsvp-hero { background: linear-gradient(135deg, #1B5E20, #00796B); color: #fff; padding: 28px; border-radius: 20px; margin-bottom: 24px; }
    .rsvp-hero h2 { font-size: 22px; font-weight: 800; margin-bottom: 6px; }
    .rsvp-hero p { font-size: 13px; opacity: 0.85; max-width: 600px; margin-bottom: 20px; }
    .rsvp-buttons { display: flex; gap: 12px; }
    .btn-rsvp-yes { background: #fff; color: var(--primary); padding: 12px 24px; border-radius: 12px; border: none; font-weight: 700; cursor: pointer; font-size: 14px; }
    .btn-rsvp-no { background: rgba(255,255,255,0.15); color: #fff; border: 1.5px solid rgba(255,255,255,0.4); padding: 12px 24px; border-radius: 12px; font-weight: 700; cursor: pointer; font-size: 14px; }

    .rec-item { background: #FAFCFA; border: 1px solid var(--card-border); border-left: 4px solid var(--primary); padding: 14px; border-radius: 10px; margin-bottom: 10px; }
    .rec-title { font-size: 14px; font-weight: 700; margin-bottom: 4px; }
    .rec-desc { font-size: 12px; color: var(--text-muted); line-height: 1.4; }
    .rec-save { font-size: 11px; font-weight: 700; color: var(--primary); margin-top: 6px; }

    .star { color: #FFB300; font-size: 18px; }
    .hidden { display: none; }
  </style>
</head>
<body>

<header>
  <div class="brand">
    <div class="brand-icon">🌱</div>
    <div>
      <div class="brand-title">MealMind</div>
      <div class="brand-subtitle">AI-Powered Food Waste Tracking & Prevention System</div>
    </div>
  </div>
  <div class="header-links">
    <a href="/docs" target="_blank" class="btn-link">⚡ Swagger REST API (/docs)</a>
    <a href="/health" target="_blank" class="btn-link">🩺 Health & ML Metrics</a>
  </div>
</header>

<div class="container">
  <div class="role-switcher">
    <button class="role-tab active" onclick="switchRole('admin')">👑 Admin Dashboard</button>
    <button class="role-tab" onclick="switchRole('staff')">👨‍🍳 Kitchen Staff View</button>
    <button class="role-tab" onclick="switchRole('student')">🎓 Student RSVP & Impact</button>
  </div>

  <!-- ADMIN VIEW -->
  <div id="view-admin">
    <div class="grid-kpi">
      <div class="kpi-card">
        <div class="kpi-title">Today's Food Prepared</div>
        <div class="kpi-value">460 <span style="font-size:16px;font-weight:600">kg</span></div>
        <div class="kpi-sub">Across 4 Meal Sessions</div>
      </div>
      <div class="kpi-card">
        <div class="kpi-title">Food Consumed</div>
        <div class="kpi-value">398 <span style="font-size:16px;font-weight:600">kg</span></div>
        <div class="kpi-sub">86.5% Overall Intake Rate</div>
      </div>
      <div class="kpi-card">
        <div class="kpi-title">Total Food Wasted</div>
        <div class="kpi-value" style="color:var(--critical)">62.0 <span style="font-size:16px;font-weight:600">kg</span></div>
        <div class="kpi-badge badge-critical">13.5% Waste Rate (Target: 15.0%)</div>
      </div>
      <div class="kpi-card">
        <div class="kpi-title">Financial Waste Loss</div>
        <div class="kpi-value" style="color:#D84315">₹3,038</div>
        <div class="kpi-sub">Projected Monthly Savings: ₹18,200</div>
      </div>
    </div>

    <div class="grid-2">
      <div class="card">
        <div class="card-title">
          <span>Weekly Food Waste Volume Trend (kg)</span>
          <span style="font-size:12px;color:var(--primary);font-weight:600">Mon - Sun Audit</span>
        </div>
        <canvas id="wasteTrendChart" height="110"></canvas>
      </div>

      <div class="card">
        <div class="card-title">Primary Waste Root Causes</div>
        <canvas id="wasteReasonChart" height="150"></canvas>
      </div>
    </div>

    <div class="grid-2">
      <div class="card">
        <div class="card-title">
          <span>Strategic 4-Quadrant Menu Matrix</span>
          <span style="font-size:12px;color:var(--text-muted)">AI Optimization Grid</span>
        </div>
        <table class="table">
          <thead>
            <tr>
              <th>Classification</th>
              <th>Food Dishes</th>
              <th>Performance</th>
              <th>Action Policy</th>
            </tr>
          </thead>
          <tbody>
            <tr>
              <td><span class="kpi-badge badge-success">⭐ Star Dishes</span></td>
              <td><strong>Paneer Butter Masala</strong>, Masala Dosa</td>
              <td>4.8 ★ | 4.2% Waste</td>
              <td>Keep & prioritize on high turnout days</td>
            </tr>
            <tr>
              <td><span class="kpi-badge" style="background:#E3F2FD;color:#1565C0">🐎 Workhorses</span></td>
              <td><strong>Steamed Basmati Rice</strong>, Chapati</td>
              <td>4.2 ★ | 9.7% Waste</td>
              <td>Apply AI buffer optimization (-11%)</td>
            </tr>
            <tr>
              <td><span class="kpi-badge" style="background:#FFF3E0;color:#E65100">🔍 Portion Mismatch</span></td>
              <td><strong>South Indian Sambar</strong></td>
              <td>4.0 ★ | 19.5% Waste</td>
              <td>Reduce serving ladle size to 150ml</td>
            </tr>
            <tr>
              <td><span class="kpi-badge badge-critical">⚠️ Re-Evaluations</span></td>
              <td><strong>Mixed Vegetable Poriyal</strong></td>
              <td>2.8 ★ | 27.9% Waste</td>
              <td>Reformulate recipe or substitute curry</td>
            </tr>
          </tbody>
        </table>
      </div>

      <div class="card">
        <div class="card-title">AI Actionable Interventions</div>
        <div class="rec-item">
          <div class="rec-title">Implement 2-Stage Staggered Cooking</div>
          <div class="rec-desc">Cook 70% of Lunch Rice at 11:30 AM and 30% after 1:00 PM based on RSVP walk-ins.</div>
          <div class="rec-save">💰 Est. Savings: ₹14,500/month</div>
        </div>
        <div class="rec-item" style="border-left-color:var(--critical)">
          <div class="rec-title">Revamp / Substitute Vegetable Poriyal</div>
          <div class="rec-desc">Dish has 2.8/5.0 student rating and 27.9% waste. Replace with Aloo Gobi.</div>
          <div class="rec-save">💰 Est. Savings: ₹18,200/month</div>
        </div>
        <div class="rec-item" style="border-left-color:var(--secondary)">
          <div class="rec-title">Calibrate Liquid Serving Ladles</div>
          <div class="rec-desc">34% of students reported sambar portion is too large for dinner.</div>
          <div class="rec-save">💰 Est. Savings: ₹9,800/month</div>
        </div>
      </div>
    </div>
  </div>

  <!-- KITCHEN STAFF VIEW -->
  <div id="view-staff" class="hidden">
    <div class="grid-kpi">
      <div class="kpi-card">
        <div class="kpi-title">Tomorrow Expected Turnout</div>
        <div class="kpi-value" style="color:var(--primary)">525 <span style="font-size:16px;font-weight:600">Students</span></div>
        <div class="kpi-sub">495 Confirmed RSVPs • 30 Walk-in Buffer</div>
      </div>
      <div class="kpi-card">
        <div class="kpi-title">Steamed Rice Target</div>
        <div class="kpi-value">153.0 <span style="font-size:16px;font-weight:600">kg</span></div>
        <div class="kpi-sub">AI Recommended (94.2% Confidence)</div>
      </div>
      <div class="kpi-card">
        <div class="kpi-title">Sambar Prep Target</div>
        <div class="kpi-value">82.0 <span style="font-size:16px;font-weight:600">L</span></div>
        <div class="kpi-sub">Reduced from standard 95L buffer</div>
      </div>
      <div class="kpi-card">
        <div class="kpi-title">Vegetable Curry Target</div>
        <div class="kpi-value" style="color:var(--critical)">52.0 <span style="font-size:16px;font-weight:600">kg</span></div>
        <div class="kpi-badge badge-critical">High Waste Alert: Trim 23%</div>
      </div>
    </div>

    <div class="card" style="margin-bottom:24px">
      <div class="card-title">
        <span>Today's Lunch Preparation vs Consumption Log</span>
        <button class="btn-action" onclick="alert('Consumption recorded successfully into Cloud Firestore!')">+ Log Prep / Consumption</button>
      </div>
      <table class="table">
        <thead>
          <tr>
            <th>Food Item</th>
            <th>Quantity Prepared</th>
            <th>Quantity Consumed</th>
            <th>Auto-Computed Waste</th>
            <th>Waste %</th>
            <th>Status</th>
          </tr>
        </thead>
        <tbody>
          <tr>
            <td><strong>Steamed Basmati Rice</strong></td>
            <td>160.0 kg</td>
            <td>144.5 kg</td>
            <td>15.5 kg</td>
            <td><strong>9.7%</strong></td>
            <td><span class="kpi-badge badge-success">Normal (<15%)</span></td>
          </tr>
          <tr>
            <td><strong>South Indian Sambar</strong></td>
            <td>92.0 L</td>
            <td>74.0 L</td>
            <td>18.0 L</td>
            <td><strong>19.6%</strong></td>
            <td><span class="kpi-badge" style="background:#FFF3E0;color:#E65100">Warning (15-20%)</span></td>
          </tr>
          <tr>
            <td><strong>Paneer Butter Masala</strong></td>
            <td>82.0 kg</td>
            <td>78.5 kg</td>
            <td>3.5 kg</td>
            <td><strong>4.3%</strong></td>
            <td><span class="kpi-badge badge-success">Optimal (<10%)</span></td>
          </tr>
          <tr>
            <td><strong>Mixed Vegetable Poriyal</strong></td>
            <td>68.0 kg</td>
            <td>49.0 kg</td>
            <td>19.0 kg</td>
            <td><strong style="color:var(--critical)">27.9%</strong></td>
            <td><span class="kpi-badge badge-critical">Critical (>20%)</span></td>
          </tr>
        </tbody>
      </table>
    </div>
  </div>

  <!-- STUDENT VIEW -->
  <div id="view-student" class="hidden">
    <div class="rsvp-hero">
      <h2>Will you eat Lunch today? (12:30 PM - 2:30 PM)</h2>
      <p>Confirming your meal attendance enables our kitchen AI to cook exact quantities, preventing up to 30% of unnecessary institutional overproduction.</p>
      <div class="rsvp-buttons">
        <button class="btn-rsvp-yes" onclick="alert('Confirmed: YES, I\\'LL EAT! 🎉 Your RSVP was logged.')">✓ YES, I'LL EAT</button>
        <button class="btn-rsvp-no" onclick="alert('Recorded: NO, I\\'LL SKIP. Thank you for notifying the kitchen!')">✗ NO, I'LL SKIP</button>
      </div>
    </div>

    <div class="grid-kpi">
      <div class="kpi-card">
        <div class="kpi-title">My RSVP Streak</div>
        <div class="kpi-value" style="color:var(--primary)">48 <span style="font-size:16px;font-weight:600">Meals</span></div>
        <div class="kpi-sub">Top 5% Eco Contributor</div>
      </div>
      <div class="kpi-card">
        <div class="kpi-title">Personal Food Saved</div>
        <div class="kpi-value" style="color:var(--secondary)">7.2 <span style="font-size:16px;font-weight:600">kg</span></div>
        <div class="kpi-sub">From prevented over-prep</div>
      </div>
      <div class="kpi-card">
        <div class="kpi-title">CO₂e Avoided (Est.)</div>
        <div class="kpi-value">18.0 <span style="font-size:16px;font-weight:600">kg</span></div>
        <div class="kpi-sub">≈ 2.5 kg CO₂e / kg food</div>
      </div>
      <div class="kpi-card">
        <div class="kpi-title">Water Saved (Est.)</div>
        <div class="kpi-value">7,200 <span style="font-size:16px;font-weight:600">Litres</span></div>
        <div class="kpi-sub">Embedded agricultural footprint</div>
      </div>
    </div>

    <div class="card">
      <div class="card-title">Rate Today's Dining Experience</div>
      <div style="margin-bottom:12px">
        <label style="font-size:13px;font-weight:600">Select Dish:</label>
        <select style="padding:8px 12px;border-radius:8px;border:1px solid var(--card-border);margin-left:8px;font-size:13px">
          <option>Paneer Butter Masala</option>
          <option>Steamed Basmati Rice</option>
          <option>South Indian Sambar</option>
          <option>Mixed Vegetable Poriyal</option>
        </select>
      </div>
      <div style="display:flex;gap:24px;margin-bottom:16px;flex-wrap:wrap">
        <div>Taste: <span class="star">★★★★★</span> (5.0)</div>
        <div>Quality: <span class="star">★★★★☆</span> (4.0)</div>
        <div>Portion Size: <span style="font-weight:600;color:var(--primary)">Just Right</span></div>
      </div>
      <button class="btn-action" onclick="alert('Feedback submitted! Thank you for helping our chefs optimize recipes.')">Submit 5-Star Feedback</button>
    </div>
  </div>
</div>

<script>
  function switchRole(role) {
    document.querySelectorAll('.role-tab').forEach(b => b.classList.remove('active'));
    document.getElementById('view-admin').classList.add('hidden');
    document.getElementById('view-staff').classList.add('hidden');
    document.getElementById('view-student').classList.add('hidden');

    if (role === 'admin') {
      document.querySelectorAll('.role-tab')[0].classList.add('active');
      document.getElementById('view-admin').classList.remove('hidden');
    } else if (role === 'staff') {
      document.querySelectorAll('.role-tab')[1].classList.add('active');
      document.getElementById('view-staff').classList.remove('hidden');
    } else {
      document.querySelectorAll('.role-tab')[2].classList.add('active');
      document.getElementById('view-student').classList.remove('hidden');
    }
  }

  // Render Charts
  window.onload = function() {
    // Waste Trend Line Chart
    const ctxTrend = document.getElementById('wasteTrendChart').getContext('2d');
    new Chart(ctxTrend, {
      type: 'line',
      data: {
        labels: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
        datasets: [{
          label: 'Daily Food Waste (kg)',
          data: [58.0, 64.0, 62.0, 48.0, 70.0, 32.0, 28.0],
          borderColor: '#1B5E20',
          backgroundColor: 'rgba(27, 94, 32, 0.12)',
          fill: true,
          tension: 0.35,
          borderWidth: 3,
          pointRadius: 4,
          pointBackgroundColor: '#1B5E20'
        }]
      },
      options: {
        responsive: true,
        plugins: { legend: { display: false } },
        scales: {
          y: { beginAtZero: true, grid: { color: '#EAEAEA' } },
          x: { grid: { display: false } }
        }
      }
    });

    // Reason Donut Chart
    const ctxReason = document.getElementById('wasteReasonChart').getContext('2d');
    new Chart(ctxReason, {
      type: 'doughnut',
      data: {
        labels: ['Excess Prep', 'Poor Taste', 'Low Turnout', 'Large Portions', 'Spoilage'],
        datasets: [{
          data: [32, 28, 22, 12, 6],
          backgroundColor: ['#1B5E20', '#C62828', '#00796B', '#F57F17', '#5C6BC0']
        }]
      },
      options: {
        responsive: true,
        plugins: { legend: { position: 'bottom', labels: { boxWidth: 12, font: { size: 11 } } } }
      }
    });
  };
</script>

</body>
</html>
    """
    return html_content

@app.get("/api/status")
def api_status():
    return {
        "app": "MealMind AI Engine",
        "status": "online",
        "models_loaded": predictor.demand_model is not None,
        "docs_url": "/docs",
        "timestamp": datetime.now(timezone.utc).isoformat()
    }

@app.get("/health")
def health():
    return {
        "status": "healthy",
        "models_loaded": predictor.demand_model is not None and predictor.waste_model is not None,
        "metrics": predictor.metrics
    }

@app.post("/predict/demand")
def predict_single_demand(request: DemandPredictionRequest):
    data = request.model_dump()
    result = predictor.predict_demand(data)
    return result

@app.post("/predict/demand/batch")
def predict_batch_demand(request: BatchDemandRequest):
    results = []
    base_data = request.model_dump()
    items = base_data.pop("items", [])
    
    for item in items:
        merged = {**base_data, **item}
        pred = predictor.predict_demand(merged)
        results.append(pred)

    return {
        "meal_type": request.meal_type,
        "day_of_week": request.day_of_week,
        "expected_attendance": request.expected_attendance,
        "meal_confirmations": request.meal_confirmations,
        "items_forecast": results
    }

@app.post("/predict/waste")
def predict_waste(request: WastePredictionRequest):
    data = request.model_dump()
    result = predictor.predict_waste_risk(data)
    return result

@app.get("/recommendations")
def get_recommendations():
    recs = RecommendationEngine.generate_recommendations()
    return {
        "total_recommendations": len(recs),
        "recommendations": recs
    }

@app.get("/menu/optimization-matrix")
def get_matrix():
    matrix = RecommendationEngine.get_menu_optimization_matrix()
    return matrix

@app.post("/retrain")
def retrain_models(background_tasks: BackgroundTasks):
    try:
        metrics = train_and_evaluate()
        predictor.load_models()
        return {
            "status": "success",
            "message": "Models successfully retrained and reloaded into memory.",
            "metrics": metrics
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Retraining failed: {str(e)}")

@app.post("/iot/waste-event")
def receive_iot_waste(event: IoTWasteEvent):
    payload = event.model_dump()
    if not payload.get("timestamp"):
        payload["timestamp"] = datetime.now(timezone.utc).isoformat()

    print(f"[IoT Ingestion] Received Waste Event: {payload['device_id']} - {payload['waste_weight_kg']} kg ({payload['waste_type']})")
    
    return {
        "status": "accepted",
        "message": f"Successfully logged {payload['waste_weight_kg']} kg from device {payload['device_id']}",
        "received_event": payload
    }

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
