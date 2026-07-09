import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary Colors
  static const Color primary = Color(0xFFC62828);
  static const Color secondary = Color(0xFFE53935);
  static const Color accent = Color(0xFFEF5350);

  // Background & Surface
  static const Color background = Color(0xFFF8FAFC);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color card = Color(0xFFFFFFFF);
  static const Color border = Color(0xFFE5E7EB);

  // Status Colors
  static const Color success = Color(0xFF2E7D32);
  static const Color warning = Color(0xFFF9A825);
  static const Color error = Color(0xFFC62828);

  // Text Colors
  static const Color textPrimary = Color(0xFF111827);
  static const Color textSecondary = Color(0xFF6B7280);

  // Functional Colors
  static const Color divider = Color(0xFFE5E7EB);
  static const Color shadow = Color(0x0A000000);

  // Additional Utility Colors
  static const Color transparent = Colors.transparent;
  static const Color white = Colors.white;
  static const Color black = Colors.black;

  // Gradient Colors
  static const Gradient primaryGradient = LinearGradient(
    colors: [Color(0xFFC62828), Color(0xFFE53935)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
