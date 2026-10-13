import 'package:flutter/material.dart';
import '../data/models/food_waste_model.dart';
import '../data/models/report_model.dart';
import '../data/services/firestore_service.dart';
import '../data/services/report_export_service.dart';

class AnalyticsProvider with ChangeNotifier {
  final FirestoreService _firestore = FirestoreService();

  String _timeRange = 'Weekly'; // 'Daily', 'Weekly', 'Monthly'
  String get timeRange => _timeRange;

  void setTimeRange(String range) {
    _timeRange = range;
    notifyListeners();
  }

  // Aggregate Metrics for Today / Current Period
  double getTotalPrepared() => 460.0;
  double getTotalConsumed() => 398.0;
  double getTotalWaste() {
    final logs = _firestore.getWasteLogs();
    if (logs.isNotEmpty) {
      return logs.fold(0.0, (sum, item) => sum + item.wasteQuantity);
    }
    return 62.0;
  }

  double getWastePercentage() {
    final prep = getTotalPrepared();
    final waste = getTotalWaste();
    return prep > 0 ? (waste / prep) * 100.0 : 0.0;
  }

  double getTotalFinancialLoss() {
    final logs = _firestore.getWasteLogs();
    if (logs.isNotEmpty) {
      return logs.fold(0.0, (sum, item) => sum + item.wasteCost);
    }
    return 3037.5;
  }

  int getExpectedAttendance() => 525;
  int getActualAttendance() => 495;

  // Chart data feeds
  List<double> getDailyWasteTrend() {
    if (_timeRange == 'Daily') {
      // Breakfast, Lunch, Snacks, Dinner
      return [12.0, 36.5, 8.0, 15.5];
    } else if (_timeRange == 'Weekly') {
      // Mon, Tue, Wed, Thu, Fri, Sat, Sun
      return [58.0, 64.0, 62.0, 48.0, 70.0, 32.0, 28.0];
    } else {
      // 4 Weeks
      return [380.0, 345.0, 310.0, 285.0];
    }
  }

  Map<String, double> getWasteReasonDistribution() {
    return {
      'Excess prep': 32.0,
      'Poor taste': 28.0,
      'Low turnout': 22.0,
      'Large portion': 12.0,
      'Spoilage': 6.0,
    };
  }

  Map<String, double> getFoodWiseWaste() {
    return {
      'Mixed Veg': 19.0,
      'Sambar': 18.0,
      'Rice': 15.5,
      'Paneer': 3.5,
      'Others': 6.0,
    };
  }

  ReportModel generateReport(String period) {
    return ReportExportService.generateReportSummary(
      period: period,
      wasteLogs: _firestore.getWasteLogs(),
      totalPreparedKg: getTotalPrepared(),
      totalConsumedKg: getTotalConsumed(),
    );
  }
}
