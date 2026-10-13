import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'presentation/common/splash_screen.dart';

class MealMindApp extends StatelessWidget {
  const MealMindApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MealMind',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
    );
  }
}
