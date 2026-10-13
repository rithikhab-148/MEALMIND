import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/app_constants.dart';
import '../services/firestore_service.dart';

class SettingsProvider with ChangeNotifier {
  final FirestoreService _firestore = FirestoreService();

  double _targetWasteThreshold = 15.0;
  String _apiBaseUrl = AppConstants.defaultApiBaseUrl;
  String _institutionName = 'ABC Engineering College & Hostels';
  String _primaryDiningHall = 'Central Mess (Hall A)';
  bool _darkMode = false;

  double get targetWasteThreshold => _targetWasteThreshold;
  String get apiBaseUrl => _apiBaseUrl;
  String get institutionName => _institutionName;
  String get primaryDiningHall => _primaryDiningHall;
  bool get darkMode => _darkMode;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _targetWasteThreshold = prefs.getDouble(AppConstants.keyTargetWasteThreshold) ?? 15.0;
    _apiBaseUrl = prefs.getString(AppConstants.keyApiUrl) ?? AppConstants.defaultApiBaseUrl;
    _firestore.setTargetWasteThreshold(_targetWasteThreshold);
    notifyListeners();
  }

  Future<void> updateWasteThreshold(double threshold) async {
    _targetWasteThreshold = threshold;
    _firestore.setTargetWasteThreshold(threshold);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(AppConstants.keyTargetWasteThreshold, threshold);
    notifyListeners();
  }

  Future<void> updateApiUrl(String url) async {
    _apiBaseUrl = url;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.keyApiUrl, url);
    notifyListeners();
  }

  void updateInstitutionDetails(String name, String hall) {
    _institutionName = name;
    _primaryDiningHall = hall;
    notifyListeners();
  }
}
