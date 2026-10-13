import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class InstitutionManagementScreen extends StatelessWidget {
  const InstitutionManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dining Halls & Mess Facilities', style: TextStyle(fontWeight: FontWeight.w800)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildHallCard(
            name: 'Central Mess (Hall A)',
            type: 'Primary Dining Facility',
            capacity: 650,
            activeStudents: 525,
            staffCount: 14,
            status: 'Active • Real-Time AI Connected',
            isPrimary: true,
          ),
          const SizedBox(height: 12),
          _buildHallCard(
            name: 'North Campus Mess (Hall B)',
            type: 'Hostel Dining Hall',
            capacity: 400,
            activeStudents: 310,
            staffCount: 8,
            status: 'Active • Batch Prep Mode',
            isPrimary: false,
          ),
          const SizedBox(height: 12),
          _buildHallCard(
            name: 'Staff & Executive Cafeteria',
            type: 'Buffet & Quick Service',
            capacity: 150,
            activeStudents: 85,
            staffCount: 4,
            status: 'Active',
            isPrimary: false,
          ),
        ],
      ),
    );
  }

  Widget _buildHallCard({
    required String name,
    required String type,
    required int capacity,
    required int activeStudents,
    required int staffCount,
    required String status,
    required bool isPrimary,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isPrimary ? AppColors.primary : AppColors.border, width: isPrimary ? 1.5 : 1.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.chipBackground,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text('Cap: $capacity', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primary)),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(type, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
          const SizedBox(height: 10),
          Row(
            children: [
              Text('Diners: $activeStudents', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
              const SizedBox(width: 16),
              Text('Kitchen Staff: $staffCount', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 8),
          Text('Status: $status', style: const TextStyle(fontSize: 11, color: AppColors.primary, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
