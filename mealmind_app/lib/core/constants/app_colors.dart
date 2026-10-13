import 'package:flutter/material.dart';

class AppColors {
  // Brand Palette
  static const Color primary = Color(0xFF1B5E20); // Deep Forest Green
  static const Color primaryLight = Color(0xFF4C8C4A);
  static const Color primaryDark = Color(0xFF003300);
  
  static const Color secondary = Color(0xFF00796B); // Teal Sustainability Accent
  static const Color secondaryLight = Color(0xFF48A999);
  
  static const Color tertiary = Color(0xFFE65100); // Warm Accent

  // Severity / Alert Colors
  static const Color normalGreen = Color(0xFF2E7D32); // Safe / Target met
  static const Color warningYellow = Color(0xFFF57F17); // Caution / Nearing threshold
  static const Color criticalRed = Color(0xFFC62828); // Critical / Exceeded threshold
  
  // Backgrounds & Surfaces
  static const Color backgroundLight = Color(0xFFF8FBF8);
  static const Color surfaceLight = Colors.white;
  static const Color cardLight = Colors.white;

  static const Color backgroundDark = Color(0xFF121814);
  static const Color surfaceDark = Color(0xFF1E2620);
  static const Color cardDark = Color(0xFF242E27);

  // Text Colors
  static const Color textPrimary = Color(0xFF1C2826);
  static const Color textSecondary = Color(0xFF607274);
  static const Color textMuted = Color(0xFF8D99AE);
  
  // Accents
  static const Color chipBackground = Color(0xFFE8F5E9);
  static const Color divider = Color(0xFFE0E5E0);
  static const Color border = Color(0xFFD3DDD3);
}
