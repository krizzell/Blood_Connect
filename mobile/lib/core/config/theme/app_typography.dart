import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTypography {
  AppTypography._();

  static TextStyle get displayLarge => GoogleFonts.beVietnamPro(
        fontSize: 57,
        fontWeight: FontWeight.w700,
        height: 64 / 57,
        letterSpacing: -0.25,
      );

  static TextStyle get headlineLargeMobile => GoogleFonts.beVietnamPro(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        height: 36 / 28,
      );

  static TextStyle get headlineLarge => GoogleFonts.beVietnamPro(
        fontSize: 32,
        fontWeight: FontWeight.w600,
        height: 40 / 32,
      );

  static TextStyle get headingLarge => GoogleFonts.beVietnamPro(
        fontSize: 32,
        fontWeight: FontWeight.w600,
        height: 40 / 32,
      );

  static TextStyle get headingMedium => GoogleFonts.beVietnamPro(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        height: 36 / 28,
      );

  static TextStyle get headingSmall => GoogleFonts.beVietnamPro(
        fontSize: 22,
        fontWeight: FontWeight.w500,
        height: 28 / 22,
      );

  static TextStyle get titleLarge => GoogleFonts.beVietnamPro(
        fontSize: 22,
        fontWeight: FontWeight.w500,
        height: 28 / 22,
      );

  static TextStyle get bodyLarge => GoogleFonts.beVietnamPro(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 24 / 16,
        letterSpacing: 0.5,
      );

  static TextStyle get bodyMedium => GoogleFonts.beVietnamPro(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 20 / 14,
        letterSpacing: 0.25,
      );

  static TextStyle get bodySmall => GoogleFonts.beVietnamPro(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 16 / 12,
        letterSpacing: 0.4,
      );

  static TextStyle get labelLarge => GoogleFonts.beVietnamPro(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        height: 20 / 14,
        letterSpacing: 0.1,
      );

  static TextStyle get labelSmall => GoogleFonts.beVietnamPro(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        height: 16 / 11,
        letterSpacing: 0.5,
      );

  static TextStyle get labelMedium => GoogleFonts.beVietnamPro(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        height: 16 / 12,
        letterSpacing: 0.5,
      );
}
