import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/auth_provider.dart';
import '../common/login_screen.dart';
import '../staff/staff_main_screen.dart';
import '../admin/admin_main_screen.dart';

class StudentProfileScreen extends StatelessWidget {
  const StudentProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile', style: TextStyle(fontWeight: FontWeight.w800)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: AppColors.primary,
                    child: Text(
                      user?.name.isNotEmpty == true ? user!.name[0] : 'S',
                      style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    user?.name ?? 'Student',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                  ),
                  Text(
                    user?.email ?? '',
                    style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.chipBackground,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'STUDENT ROLE • ${user?.studentIdNumber ?? "2024CS1042"}',
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primary),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Profile info card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  _buildProfileRow(Icons.account_balance, 'Institution', 'ABC Engineering College'),
                  const Divider(height: 20),
                  _buildProfileRow(Icons.restaurant, 'Assigned Dining Hall', 'Central Mess (Hall A)'),
                  const Divider(height: 20),
                  _buildProfileRow(Icons.badge, 'Student ID', user?.studentIdNumber ?? '2024CS1042'),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Role Switcher for Test / Demo
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
                            await authProvider.switchRole('staff');
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (_) => const StaffMainScreen()),
                            );
                          },
                          child: const Text('Kitchen Staff'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () async {
                            await authProvider.switchRole('admin');
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (_) => const AdminMainScreen()),
                            );
                          },
                          child: const Text('Admin'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Logout Button
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
          ],
        ),
      ),
    );
  }

  Widget _buildProfileRow(IconData icon, String title, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.primary),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
            Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
          ],
        ),
      ],
    );
  }
}
