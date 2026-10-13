import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_constants.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import 'register_screen.dart';
import 'forgot_password_screen.dart';
import '../student/student_main_screen.dart';
import '../staff/staff_main_screen.dart';
import '../admin/admin_main_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController(text: 'student@abccollege.edu');
  final _passwordController = TextEditingController(text: 'password123');
  String _selectedRole = AppConstants.roleStudent;
  bool _isLoading = false;

  void _handleQuickDemoSwitch(String role) {
    setState(() {
      _selectedRole = role;
      if (role == AppConstants.roleAdmin) {
        _emailController.text = 'admin@abccollege.edu';
      } else if (role == AppConstants.roleStaff) {
        _emailController.text = 'kitchen@abccollege.edu';
      } else {
        _emailController.text = 'student@abccollege.edu';
      }
    });
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    final success = await authProvider.login(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
      preferredRole: _selectedRole,
    );

    setState(() => _isLoading = false);

    if (success && mounted) {
      final role = authProvider.userRole;
      if (role == AppConstants.roleAdmin) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const AdminMainScreen()),
        );
      } else if (role == AppConstants.roleStaff) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const StaffMainScreen()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const StudentMainScreen()),
        );
      }
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Login failed. Please check credentials.'),
          backgroundColor: AppColors.criticalRed,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Center(
                  child: Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.restaurant_rounded,
                      size: 38,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Center(
                  child: Text(
                    'Welcome to MealMind',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                const Center(
                  child: Text(
                    'Track, predict, and eliminate food waste',
                    style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                  ),
                ),
                const SizedBox(height: 28),

                // Quick Demo Account Selector
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.chipBackground,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.primary.withOpacity(0.2)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.bolt, size: 16, color: AppColors.primary),
                          SizedBox(width: 4),
                          Text(
                            'Quick Demo Mode Selector:',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          _buildRoleButton('Student', AppConstants.roleStudent),
                          const SizedBox(width: 8),
                          _buildRoleButton('Staff', AppConstants.roleStaff),
                          const SizedBox(width: 8),
                          _buildRoleButton('Admin', AppConstants.roleAdmin),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                CustomTextField(
                  label: 'Email Address',
                  hint: 'Enter your institutional email',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: const Icon(Icons.email_outlined, size: 20),
                  validator: (val) => val == null || val.isEmpty ? 'Email is required' : null,
                ),
                const SizedBox(height: 16),

                CustomTextField(
                  label: 'Password',
                  hint: 'Enter password',
                  controller: _passwordController,
                  obscureText: true,
                  prefixIcon: const Icon(Icons.lock_outline, size: 20),
                  validator: (val) => val == null || val.length < 6 ? 'Minimum 6 characters' : null,
                ),
                const SizedBox(height: 8),

                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const ForgotPasswordScreen()),
                      );
                    },
                    child: const Text(
                      'Forgot Password?',
                      style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600, fontSize: 13),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                CustomButton(
                  text: 'Sign In as ${_selectedRole.toUpperCase()}',
                  onPressed: _handleLogin,
                  isLoading: _isLoading,
                ),
                const SizedBox(height: 16),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('New user? ', style: TextStyle(color: AppColors.textSecondary)),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const RegisterScreen()),
                        );
                      },
                      child: const Text(
                        'Register Institution / Profile',
                        style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoleButton(String label, String role) {
    final isSelected = _selectedRole == role;
    return Expanded(
      child: InkWell(
        onTap: () => _handleQuickDemoSwitch(role),
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.border,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: isSelected ? Colors.white : AppColors.textPrimary,
            ),
          ),
        ),
      ),
    );
  }
}
