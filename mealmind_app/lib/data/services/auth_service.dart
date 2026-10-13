import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/app_constants.dart';
import '../models/user_model.dart';
import 'demo_data_service.dart';

class AuthService {
  UserModel? _currentUser;
  bool _isDemoMode = true;

  UserModel? get currentUser => _currentUser;
  bool get isDemoMode => _isDemoMode;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final role = prefs.getString(AppConstants.keyUserRole);
    if (role != null) {
      if (role == AppConstants.roleAdmin) {
        _currentUser = DemoDataService.demoAdmin;
      } else if (role == AppConstants.roleStaff) {
        _currentUser = DemoDataService.demoStaff;
      } else {
        _currentUser = DemoDataService.demoStudent;
      }
    } else {
      // Default to Demo Student for immediate preview
      _currentUser = DemoDataService.demoStudent;
    }
  }

  Future<UserModel> login({
    required String email,
    required String password,
    String? preferredRole,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    if (email.contains('admin') || preferredRole == AppConstants.roleAdmin) {
      _currentUser = DemoDataService.demoAdmin;
    } else if (email.contains('kitchen') || email.contains('staff') || preferredRole == AppConstants.roleStaff) {
      _currentUser = DemoDataService.demoStaff;
    } else {
      _currentUser = DemoDataService.demoStudent;
    }

    await prefs.setString(AppConstants.keyUserRole, _currentUser!.role);
    await prefs.setString(AppConstants.keyUserId, _currentUser!.id);
    await prefs.setString(AppConstants.keyUserName, _currentUser!.name);
    await prefs.setString(AppConstants.keyUserEmail, _currentUser!.email);

    return _currentUser!;
  }

  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
    required String role,
    required String institutionId,
    String? studentIdNumber,
  }) async {
    final newUser = UserModel(
      id: 'usr_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      email: email,
      role: role,
      institutionId: institutionId,
      studentIdNumber: studentIdNumber,
    );

    _currentUser = newUser;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.keyUserRole, role);
    await prefs.setString(AppConstants.keyUserId, newUser.id);
    await prefs.setString(AppConstants.keyUserName, name);
    await prefs.setString(AppConstants.keyUserEmail, email);

    return newUser;
  }

  Future<void> switchRole(String role) async {
    final prefs = await SharedPreferences.getInstance();
    if (role == AppConstants.roleAdmin) {
      _currentUser = DemoDataService.demoAdmin;
    } else if (role == AppConstants.roleStaff) {
      _currentUser = DemoDataService.demoStaff;
    } else {
      _currentUser = DemoDataService.demoStudent;
    }
    await prefs.setString(AppConstants.keyUserRole, _currentUser!.role);
  }

  Future<bool> sendPasswordReset(String email) async {
    await Future.delayed(const Duration(milliseconds: 600));
    return true;
  }

  Future<void> logout() async {
    _currentUser = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.keyUserRole);
    await prefs.remove(AppConstants.keyUserId);
  }
}
