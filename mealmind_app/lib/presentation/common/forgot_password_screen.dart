import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  bool _isLoading = false;
  bool _sent = false;

  void _handleReset() async {
    if (_emailController.text.isEmpty) return;
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 700));
    setState(() {
      _isLoading = false;
      _sent = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reset Password')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Forgot Password',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 6),
            const Text(
              'Enter your institutional email and we will send you a password reset verification link.',
              style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 24),
            if (_sent) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.chipBackground,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.check_circle, color: AppColors.normalGreen),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Password reset instructions sent! Please check your campus inbox.',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.normalGreen),
                      ),
                    ),
                  ],
                ),
              ),
            ] else ...[
              CustomTextField(
                label: 'Institutional Email',
                hint: 'name@college.edu',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                prefixIcon: const Icon(Icons.email_outlined, size: 20),
              ),
              const SizedBox(height: 20),
              CustomButton(
                text: 'Send Reset Link',
                onPressed: _handleReset,
                isLoading: _isLoading,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
