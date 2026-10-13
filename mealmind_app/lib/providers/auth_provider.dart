import 'package:flutter/material.dart';
import '../data/models/user_model.dart';
import '../data/services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  UserModel? _currentUser;
  bool _isLoading = false;

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _currentUser != null;
  String get userRole => _currentUser?.role ?? 'student';

  Future<void> init() async {
    _isLoading = true;
    notifyListeners();
    await _authService.init();
    _currentUser = _authService.currentUser;
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> login({
    required String email,
    required String password,
    String? preferredRole,
  }) async {
    _isLoading = true;
    notifyListeners();
    try {
      _currentUser = await _authService.login(
        email: email,
        password: password,
        preferredRole: preferredRole,
      );
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (_) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register({
    required String name,
    required String email,
    required String password,
    required String role,
    required String institutionId,
    String? studentIdNumber,
  }) async {
    _isLoading = true;
    notifyListeners();
    try {
      _currentUser = await _authService.register(
        name: name,
        email: email,
        password: password,
        role: role,
        institutionId: institutionId,
        studentIdNumber: studentIdNumber,
      );
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (_) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> switchRole(String role) async {
    _isLoading = true;
    notifyListeners();
    await _authService.switchRole(role);
    _currentUser = _authService.currentUser;
    _isLoading = false;
    notifyListeners();
  }

  Future<void> logout() async {
    await _authService.logout();
    _currentUser = null;
    notifyListeners();
  }
}
