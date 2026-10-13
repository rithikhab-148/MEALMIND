import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_constants.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../student/student_main_screen.dart';
import '../staff/staff_main_screen.dart';
import '../admin/admin_main_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _institutionController = TextEditingController(text: 'ABC Engineering College');
  final _studentIdController = TextEditingController();

  String _selectedRole = AppConstants.roleStudent;
  bool _isLoading = false;

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    final success = await authProvider.register(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
      role: _selectedRole,
      institutionId: _institutionController.text.trim(),
      studentIdNumber: _selectedRole == AppConstants.roleStudent ? _studentIdController.text.trim() : null,
    );

    setState(() => _isLoading = false);

    if (success && mounted) {
      if (_selectedRole == AppConstants.roleAdmin) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const AdminMainScreen()));
      } else if (_selectedRole == AppConstants.roleStaff) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const StaffMainScreen()));
      } else {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const StudentMainScreen()));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Account')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Join MealMind',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                ),
                const Text(
                  'Set up your profile to optimize food planning',
                  style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                ),
                const SizedBox(height: 20),

                const Text('Select Your Role:', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _buildRoleOption('Student', AppConstants.roleStudent),
                    const SizedBox(width: 8),
                    _buildRoleOption('Kitchen Staff', AppConstants.roleStaff),
                    const SizedBox(width: 8),
                    _buildRoleOption('Admin', AppConstants.roleAdmin),
                  ],
                ),
                const SizedBox(height: 20),

                CustomTextField(
                  label: 'Full Name',
                  hint: 'e.g. Aditya Verma',
                  controller: _nameController,
                  prefixIcon: const Icon(Icons.person_outline, size: 20),
                  validator: (v) => v == null || v.isEmpty ? 'Name is required' : null,
                ),
                const SizedBox(height: 16),

                CustomTextField(
                  label: 'Institutional Email',
                  hint: 'e.g. name@college.edu',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: const Icon(Icons.email_outlined, size: 20),
                  validator: (v) => v == null || !v.contains('@') ? 'Valid email required' : null,
                ),
                const SizedBox(height: 16),

                if (_selectedRole == AppConstants.roleStudent) ...[
                  CustomTextField(
                    label: 'Student Roll / ID Number',
                    hint: 'e.g. 2024CS1042',
                    controller: _studentIdController,
                    prefixIcon: const Icon(Icons.badge_outlined, size: 20),
                    validator: (v) => v == null || v.isEmpty ? 'Student ID required' : null,
                  ),
                  const SizedBox(height: 16),
                ],

                CustomTextField(
                  label: 'Institution / Campus',
                  hint: 'e.g. ABC College of Engineering',
                  controller: _institutionController,
                  prefixIcon: const Icon(Icons.account_balance_outlined, size: 20),
                  validator: (v) => v == null || v.isEmpty ? 'Institution required' : null,
                ),
                const SizedBox(height: 16),

                CustomTextField(
                  label: 'Password',
                  hint: 'Create password',
                  controller: _passwordController,
                  obscureText: true,
                  prefixIcon: const Icon(Icons.lock_outline, size: 20),
                  validator: (v) => v == null || v.length < 6 ? 'Minimum 6 characters' : null,
                ),
                const SizedBox(height: 24),

                CustomButton(
                  text: 'Register Account',
                  onPressed: _handleRegister,
                  isLoading: _isLoading,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoleOption(String title, String role) {
    final isSelected = _selectedRole == role;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _selectedRole = role),
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: isSelected ? AppColors.primary : AppColors.border),
          ),
          alignment: Alignment.center,
          child: Text(
            title,
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
