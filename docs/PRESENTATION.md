# MealMind: Presentation & Demonstration Deck Notes

---

## Slide 1: Title & Vision
- **Title**: MealMind – AI-Powered Institutional Food Waste Prevention System
- **Tagline**: Predict demand, eliminate overproduction, diagnose waste root causes, and optimize campus dining operations.
- **Presenter**: Engineering Project Team

---

## Slide 2: The Core Problem
- Large college hostels and cafeterias prepare food blindly for full enrolled capacity (~550 students).
- Turnout swings wildly (weekends, exams, weather, sports).
- Static 15–20% overproduction buffers lead to massive financial loss (₹35,000–₹60,000 monthly per hall) and tons of landfill methane emissions.

---

## Slide 3: The Complete MealMind Solution Loop
```
Student Meal RSVP  -->  AI Demand Forecast (GBR R²=0.9879)  -->  Optimized Kitchen Prep
       ^                                                                |
       |                                                                v
Prescriptive Actions  <--  4-Quadrant Menu Matrix  <--  Categorized Waste & Cost Audit
```

---

## Slide 4: Student Experience & RSVP Innovation
- 1-Tap Attendance confirmation (`YES, I'LL EAT` / `NO, I'LL SKIP`).
- View today's menu with serving sizes and dish popularity ratings.
- Multi-factor 5-star feedback rating (Taste, Quality, Portion size).
- Personal Eco Impact dashboard showing kilograms of food saved and $\text{CO}_2\text{e}$ avoided.

---

## Slide 5: Kitchen Staff Operational Workflow
- Real-time prep vs. consumption progress tracking.
- Automated instant waste quantity and percentage calculation.
- Granular waste logging (7 waste types, 9 root causes).
- AI Tomorrow's Preparation Targets with transparent factor explanations (RSVP count, ratings, calendar adjustments).

---

## Slide 6: Administrator Executive Control
- Live executive KPIs: Prepared, Consumed, Wasted, Waste %, Financial Loss.
- Daily / Weekly / Monthly interactive FL Chart trend lines.
- Root cause donut breakdown and food-wise waste volume ranking.
- Automated Audit Reports with 1-click **PDF and CSV Export**.
- Acceptable Waste Threshold Target configuration (e.g. 15.0%).

---

## Slide 7: AI/ML Engineering Excellence
- Tested against multiple models: Linear Regression, Random Forest, Gradient Boosting.
- Champion Regressor: **Gradient Boosting ($R^2 = 0.9879$, $\text{MAE} = 2.37\text{ kg}$)**.
- Champion Classifier: **Logistic Regression ($80.7\%$ Accuracy, $0.7374\text{ F1}$)**.
- Fully operational FastAPI REST microservice + offline deterministic fallback.

---

## Slide 8: Live Demonstration Highlights
1. **Show Demo Mode**: One-tap role switching on Login screen (Student $\leftrightarrow$ Staff $\leftrightarrow$ Admin).
2. **Student Flow**: Tap RSVP for Lunch $\rightarrow$ Submit 5-star review $\rightarrow$ Inspect eco impact badge.
3. **Staff Flow**: View recommended prep $\rightarrow$ Inspect AI factors $\rightarrow$ Log consumption $\rightarrow$ Trigger auto waste calc.
4. **Admin Flow**: View waste trend charts $\rightarrow$ Review Menu Matrix $\rightarrow$ Export CSV audit report.

---

## Slide 9: Impact & Potential
- **Financial**: Projected monthly savings of ₹15,000–₹25,000 per dining hall.
- **Environmental**: Avoids ~2.5 kg $\text{CO}_2\text{e}$ and saves ~1,000 L water per kg of food waste prevented.
- **Operational**: Eliminates kitchen guesswork and establishes transparent accountability.
