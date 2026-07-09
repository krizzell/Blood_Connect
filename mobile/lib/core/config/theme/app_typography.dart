import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTypography {
  AppTypography._();

  static TextStyle get displayLarge => GoogleFonts.poppins(
        fontSize: 32,
        fontWeight: FontWeight.w600,
        height: 1.2,
      );

  static TextStyle get displayMedium => GoogleFonts.poppins(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        height: 1.2,
      );

  static TextStyle get displaySmall => GoogleFonts.poppins(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        height: 1.2,
      );

  static TextStyle get headingLarge => GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        height: 1.4,
      );

  static TextStyle get headingMedium => GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        height: 1.4,
      );

  static TextStyle get headingSmall => GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        height: 1.4,
      );

  static TextStyle get bodyLarge => GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.5,
      );

  static TextStyle get bodyMedium => GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.5,
      );

  static TextStyle get bodySmall => GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 1.5,
      );

  static TextStyle get labelLarge => GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        height: 1.4,
      );

  static TextStyle get labelMedium => GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        height: 1.4,
      );

  static TextStyle get labelSmall => GoogleFonts.poppins(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        height: 1.4,
      );

  static TextStyle get buttonLarge => GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        height: 1.5,
      );

  static TextStyle get buttonMedium => GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        height: 1.5,
      );

  static TextStyle get buttonSmall => GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        height: 1.5,
      );
}
