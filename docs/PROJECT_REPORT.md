# MealMind: Project Report
**AI-Powered Food Waste Tracking, Prediction, and Prevention System**

---

## 1. Executive Abstract

Institutional food service facilities—including college hostel messes, school cafeterias, hospital dietary departments, and corporate dining halls—routinely grapple with substantial food waste. Traditional kitchen management relies predominantly on static rule-of-thumb overproduction margins (typically 10–20%), resulting in massive financial losses and environmental strain.

**MealMind** introduces an end-to-end intelligent platform that addresses the entire food lifecycle. By integrating a **Student Meal Intention System (RSVP)**, **Machine Learning Demand Prediction (Gradient Boosting Regressor, $R^2 = 0.9879$)**, **Granular Waste Recording (7 waste types, 9 root causes)**, **Financial Loss Analytics**, and a **Prescriptive AI Recommendation Engine**, MealMind transforms institutional cafeterias from reactive waste loggers into proactive waste prevention ecosystems.

---

## 2. Problem Statement

Large-scale institutional dining operations encounter four primary structural challenges:

1. **Unpredictable Attendance Fluctuations**: Student and staff turnout varies significantly due to weekends, exams, weather, sports events, and menu preferences. Cooking for full enrolled capacity inevitably generates massive leftovers.
2. **Lack of Root-Cause Visibility**: Kitchens rarely categorize why food was discarded (e.g., overproduction vs. poor taste vs. excessive portion size vs. spoilage), hindering targeted operational corrections.
3. **Hidden Financial Drain**: Waste is rarely quantified in monetary terms. Institutions fail to recognize that unconsumed food directly squanders raw ingredient budgets, labor, and utility costs.
4. **Substantial Ecological Footprint**: Uneaten food deposited in landfills generates methane ($\text{CH}_4$) and represents squandered agricultural water footprint.

---

## 3. Project Objectives

1. **Forecast Food Demand**: Predict exact meal consumption targets using student RSVPs, historical moving averages, satisfaction ratings, and academic calendar features.
2. **Eliminate Overproduction**: Replace arbitrary prep buffers with optimized $\approx 4\%$ safety margins, reducing kitchen leftovers by 15–30%.
3. **Categorize Waste & Identify Root Causes**: Enable kitchen staff to log waste rapidly with structured reason taxonomies.
4. **Quantify Financial Loss & Potential Savings**: Translate kilograms of food waste into localized currency ($\text{INR } ₹$) and compute actionable savings projections.
5. **Prescribe Practical Kitchen Interventions**: Deliver automated recommendations (e.g. 2-stage staggered cooking, ladle portion resizing, menu substitutions).
6. **Promote Campus Sustainability**: Provide students with personalized and institutional eco-impact indicators ($\text{CO}_2\text{e}$ and water footprint avoided).

---

## 4. Mathematical Models & Core Calculations

The application implements standard, robust, zero-division protected formulas:

### 4.1 Expected Attendance Estimation
$$E = (C \times \alpha) + \beta$$
Where:
- $E$ = Expected attendance
- $C$ = Student meal confirmations (RSVPs submitted via app)
- $\alpha$ = Historical confirmation-to-turnout multiplier ($\approx 1.05$)
- $\beta$ = Walk-in diner offset ($\approx 10$)

### 4.2 Food Waste Quantity
$$W = \max(0, P - Q_{\text{consumed}})$$
Where $P$ is prepared quantity and $Q_{\text{consumed}}$ is actual consumed quantity.

### 4.3 Waste Percentage
$$\text{Waste \%} = \left( \frac{W}{P} \right) \times 100 \quad (\text{for } P > 0)$$

### 4.4 Financial Waste Loss
$$\text{Cost}_{\text{waste}} = W \times \text{Cost}_{\text{unit}}$$

### 4.5 Environmental Indicators
$$\text{CO}_2\text{e Avoided (kg)} = W_{\text{saved}} \times 2.5\text{ kg CO}_2\text{e/kg}$$
$$\text{Water Saved (Litres)} = W_{\text{saved}} \times 1,000\text{ L/kg}$$

---

## 5. Machine Learning Methodology & Evaluation

### 5.1 Dataset
A 90-day synthetic institutional dataset containing 1,710 meal session records across 4 daily meals was synthesized (`mealmind_dataset.csv`) reflecting realistic calendar events, exam schedules, and satisfaction variations.

### 5.2 Model Comparison Results

#### Demand Regressor Evaluation (Target: Consumed Quantity):
| Model | MAE (kg) | RMSE (kg) | $R^2$ Score |
| :--- | :--- | :--- | :--- |
| Linear Regression | 4.302 | 6.061 | 0.9567 |
| Random Forest Regressor | 2.488 | 3.917 | 0.9819 |
| **Gradient Boosting Regressor** | **2.370** | **3.202** | **0.9879** (🏆 Champion) |

#### Waste Risk Classifier Evaluation (Target: Low / Medium / High Risk):
| Model | Accuracy | Weighted Precision | Weighted Recall | F1-Score |
| :--- | :--- | :--- | :--- | :--- |
| **Logistic Regression** | **80.70%** | **84.47%** | **80.70%** | **0.7374** (🏆 Champion) |
| Random Forest Classifier | 80.12% | 84.12% | 80.12% | 0.7209 |

---

## 6. Strategic Menu Matrix (4-Quadrant Classification)

| Quadrant | Criteria | Dishes Identified | Strategic Action |
| :--- | :--- | :--- | :--- |
| **Stars** | High Rating ($\ge 4.5$), Low Waste ($<8\%$) | Paneer Butter Masala, Masala Dosa, Dal Makhani | Maintain recipes; prioritize on high-turnout days |
| **Workhorses** | Moderate Rating ($4.0 - 4.4$), High Volume | Steamed Basmati Rice, Chapati | Apply ML buffer optimizations |
| **Portion Mismatch** | High Rating ($\ge 4.0$), High Plate Waste ($>18\%$) | South Indian Sambar | Reduce initial ladle serving volume |
| **Re-evaluations** | Low Rating ($<3.5$), High Waste ($>20\%$) | Mixed Vegetable Poriyal, Upma | Reformulate seasoning or replace with preferred curry |

---

## 7. Future Enhancements & Hardware Roadmap

1. **Full IoT Bin Deployment**: Physical fabrication of multi-cell strain gauge smart waste bins communicating over MQTT / ESP-NOW.
2. **Computer Vision Plate Scanner**: Edge camera integration (e.g. Raspberry Pi + YOLOv8) at plate drop-off counters to automatically detect unconsumed food categories without human tagging.
3. **Automated Procurement Integration**: Direct API connections to ERP and local vendor systems for automated raw ingredient ordering aligned with AI demand forecasts.
