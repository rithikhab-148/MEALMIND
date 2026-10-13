import 'dart:convert';
import 'package:intl/intl.dart';
import '../models/report_model.dart';
import '../models/food_waste_model.dart';
import '../../core/utils/formatters.dart';

class ReportExportService {
  static ReportModel generateReportSummary({
    required String period, // 'Daily', 'Weekly', 'Monthly'
    required List<FoodWasteModel> wasteLogs,
    double totalPreparedKg = 460.0,
    double totalConsumedKg = 398.0,
  }) {
    double totalWasteKg = 0.0;
    double totalCost = 0.0;
    final Map<String, double> itemWasteMap = {};
    final Map<String, double> reasonMap = {};
    final Map<String, double> mealWasteMap = {};

    for (var log in wasteLogs) {
      totalWasteKg += log.wasteQuantity;
      totalCost += log.wasteCost;

      itemWasteMap[log.foodItem] = (itemWasteMap[log.foodItem] ?? 0.0) + log.wasteQuantity;
      reasonMap[log.wasteReason] = (reasonMap[log.wasteReason] ?? 0.0) + log.wasteQuantity;
      mealWasteMap[log.mealType] = (mealWasteMap[log.mealType] ?? 0.0) + log.wasteQuantity;
    }

    if (totalWasteKg == 0.0) {
      totalWasteKg = totalPreparedKg - totalConsumedKg;
      totalCost = totalWasteKg * 45.0;
    }

    final wastePct = totalPreparedKg > 0 ? (totalWasteKg / totalPreparedKg) * 100.0 : 0.0;

    String topWasted = 'Mixed Vegetable Poriyal';
    if (itemWasteMap.isNotEmpty) {
      topWasted = itemWasteMap.entries.reduce((a, b) => a.value > b.value ? a : b).key;
    }

    String topReason = 'Excess preparation';
    if (reasonMap.isNotEmpty) {
      topReason = reasonMap.entries.reduce((a, b) => a.value > b.value ? a : b).key;
    }

    String topMeal = 'Lunch';
    if (mealWasteMap.isNotEmpty) {
      topMeal = mealWasteMap.entries.reduce((a, b) => a.value > b.value ? a : b).key;
    }

    final co2 = totalWasteKg * 2.5;
    final water = totalWasteKg * 1000.0;

    final breakdown = [
      {'food_item': 'Mixed Vegetable Poriyal', 'waste_kg': 19.0, 'waste_cost': 1045.0, 'reason': 'Poor taste'},
      {'food_item': 'South Indian Sambar', 'waste_kg': 18.0, 'waste_cost': 630.0, 'reason': 'Excess preparation'},
      {'food_item': 'Steamed Basmati Rice', 'waste_kg': 15.5, 'waste_cost': 697.5, 'reason': 'Low attendance'},
      {'food_item': 'Paneer Butter Masala', 'waste_kg': 3.5, 'waste_cost': 665.0, 'reason': 'Large portion size'},
    ];

    final recommendations = [
      'Implement 2-stage staggered cooking for Lunch Rice & Sambar to trim over-prep by 15%.',
      'Reformulate Mixed Vegetable Poriyal recipe or substitute with high-acceptance curry.',
      'Calibrate serving ladle size for liquid dishes to reduce plate residue.',
    ];

    return ReportModel(
      title: '$period Food Waste Audit & Prevention Report',
      period: period,
      generatedAt: DateTime.now(),
      totalPreparedKg: totalPreparedKg,
      totalConsumedKg: totalConsumedKg,
      totalWasteKg: double.parse(totalWasteKg.toStringAsFixed(1)),
      wastePercentage: double.parse(wastePct.toStringAsFixed(1)),
      totalFinancialLoss: double.parse(totalCost.toStringAsFixed(0)),
      topWastedItem: topWasted,
      highestWasteMeal: topMeal,
      primaryWasteReason: topReason,
      co2AvoidedKg: double.parse(co2.toStringAsFixed(1)),
      waterSavedLitres: double.parse(water.toStringAsFixed(0)),
      foodBreakdown: breakdown,
      topRecommendations: recommendations,
    );
  }

  static String generateCsv(ReportModel report) {
    final buffer = StringBuffer();
    buffer.writeln('MealMind - Food Waste & Financial Loss Report');
    buffer.writeln('Period,${report.period}');
    buffer.writeln('Generated At,${DateFormat('yyyy-MM-dd HH:mm').format(report.generatedAt)}');
    buffer.writeln('Total Prepared (kg),${report.totalPreparedKg}');
    buffer.writeln('Total Consumed (kg),${report.totalConsumedKg}');
    buffer.writeln('Total Waste (kg),${report.totalWasteKg}');
    buffer.writeln('Waste Percentage,${report.wastePercentage}%');
    buffer.writeln('Financial Loss (INR),${report.totalFinancialLoss}');
    buffer.writeln('Top Wasted Item,${report.topWastedItem}');
    buffer.writeln('Highest Waste Meal,${report.highestWasteMeal}');
    buffer.writeln('Primary Waste Reason,${report.primaryWasteReason}');
    buffer.writeln('CO2e Impact (kg),${report.co2AvoidedKg}');
    buffer.writeln('Water Footprint (L),${report.waterSavedLitres}');
    buffer.writeln('');
    buffer.writeln('Food Item Breakdown:');
    buffer.writeln('Food Item,Waste Quantity (kg),Waste Cost (INR),Primary Reason');
    for (var item in report.foodBreakdown) {
      buffer.writeln('${item['food_item']},${item['waste_kg']},${item['waste_cost']},${item['reason']}');
    }
    return buffer.toString();
  }
}
