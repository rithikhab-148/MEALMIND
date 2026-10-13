import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../data/models/user_model.dart';
import '../../data/services/demo_data_service.dart';

class UserManagementScreen extends StatelessWidget {
  const UserManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final users = [
      DemoDataService.demoAdmin,
      DemoDataService.demoStaff,
      DemoDataService.demoStudent,
      UserModel(
        id: 'usr_staff_02',
        name: 'Cook Murugan S.',
        email: 'murugan@abccollege.edu',
        role: 'staff',
        institutionId: 'inst_abc_college',
        diningHallId: 'hall_central',
      ),
      UserModel(
        id: 'usr_student_02',
        name: 'Sneha Patel (ECE - Yr 2)',
        email: 'sneha.p@abccollege.edu',
        role: 'student',
        institutionId: 'inst_abc_college',
        studentIdNumber: '2025EC2015',
        mealsConfirmedCount: 32,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Institution User Roster', style: TextStyle(fontWeight: FontWeight.w800)),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: users.length,
        itemBuilder: (context, index) {
          final u = users[index];
          Color roleColor = AppColors.primary;
          if (u.isAdmin) roleColor = Colors.purple[700]!;
          if (u.isStaff) roleColor = Colors.orange[800]!;

          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: roleColor.withOpacity(0.12),
                  child: Icon(u.isAdmin ? Icons.admin_panel_settings : (u.isStaff ? Icons.soup_kitchen : Icons.school), color: roleColor, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(u.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                      Text(u.email, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: roleColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    u.role.toUpperCase(),
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: roleColor),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
