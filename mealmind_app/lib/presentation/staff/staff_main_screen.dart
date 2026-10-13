import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import 'staff_dashboard_screen.dart';
import 'food_prep_screen.dart';
import 'food_consumption_screen.dart';
import 'record_waste_screen.dart';
import 'staff_predictions_screen.dart';

class StaffMainScreen extends StatefulWidget {
  const StaffMainScreen({super.key});

  @override
  State<StaffMainScreen> createState() => _StaffMainScreenState();
}

class _StaffMainScreenState extends State<StaffMainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    StaffDashboardScreen(),
    FoodPrepScreen(),
    FoodConsumptionScreen(),
    RecordWasteScreen(),
    StaffPredictionsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (idx) => setState(() => _currentIndex = idx),
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            activeIcon: Icon(Icons.dashboard),
            label: 'Kitchen',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.soup_kitchen_outlined),
            activeIcon: Icon(Icons.soup_kitchen),
            label: 'Prep Log',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.dining_outlined),
            activeIcon: Icon(Icons.dining),
            label: 'Consumption',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.delete_sweep_outlined),
            activeIcon: Icon(Icons.delete_sweep),
            label: 'Waste',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.psychology_outlined),
            activeIcon: Icon(Icons.psychology),
            label: 'AI Forecast',
          ),
        ],
      ),
    );
  }
}
