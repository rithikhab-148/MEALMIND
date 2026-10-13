import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/auth_provider.dart';
import '../../providers/settings_provider.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../common/login_screen.dart';
import '../student/student_main_screen.dart';
import '../staff/staff_main_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late double _threshold;
  late TextEditingController _apiUrlController;
  late TextEditingController _instNameController;

  @override
  void initState() {
    super.initState();
    final settings = Provider.of<SettingsProvider>(context, listen: false);
    _threshold = settings.targetWasteThreshold;
    _apiUrlController = TextEditingController(text: settings.apiBaseUrl);
    _instNameController = TextEditingController(text: settings.institutionName);
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final settings = Provider.of<SettingsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings & Thresholds', style: TextStyle(fontWeight: FontWeight.w800)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Waste Threshold Configuration
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Acceptable Waste Threshold Target', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 4),
                  const Text(
                    'Sessions where waste % exceeds this value trigger Critical/Warning alerts.',
                    style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Target Percentage:', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                      Text(
                        '${_threshold.toStringAsFixed(1)}%',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: AppColors.primary),
                      ),
                    ],
                  ),
                  Slider(
                    value: _threshold,
                    min: 5.0,
                    max: 30.0,
                    divisions: 25,
                    activeColor: AppColors.primary,
                    onChanged: (val) {
                      setState(() => _threshold = val);
                      settings.updateWasteThreshold(val);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // AI/ML Backend Connection
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Python FastAPI ML Server Endpoint', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 4),
                  const Text('Address of the microservice serving scikit-learn predictions.', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                  const SizedBox(height: 12),
                  CustomTextField(
                    label: 'Base URL',
                    controller: _apiUrlController,
                    hint: 'http://127.0.0.1:8000',
                  ),
                  const SizedBox(height: 12),
                  CustomButton(
                    text: 'Update Endpoint URL',
                    isOutlined: true,
                    onPressed: () {
                      settings.updateApiUrl(_apiUrlController.text.trim());
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('API Server Endpoint updated!'), backgroundColor: AppColors.normalGreen),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Campus Details
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Institution Information', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 12),
                  CustomTextField(
                    label: 'Institution Name',
                    controller: _instNameController,
                  ),
                  const SizedBox(height: 12),
                  CustomButton(
                    text: 'Save Campus Profile',
                    onPressed: () {
                      settings.updateInstitutionDetails(_instNameController.text.trim(), settings.primaryDiningHall);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Institution details updated!'), backgroundColor: AppColors.primary),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Role Switcher for Demo
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Switch Demo Perspective:', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () async {
                            await authProvider.switchRole('student');
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (_) => const StudentMainScreen()),
                            );
                          },
                          child: const Text('Student View'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () async {
                            await authProvider.switchRole('staff');
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (_) => const StaffMainScreen()),
                            );
                          },
                          child: const Text('Kitchen Staff'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () async {
                  await authProvider.logout();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                  );
                },
                icon: const Icon(Icons.logout, color: AppColors.criticalRed),
                label: const Text('Sign Out', style: TextStyle(color: AppColors.criticalRed)),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.criticalRed),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
