// ─────────────────────────────────────────────
//  TYPOGRAPHY — Inter + JetBrains Mono
// ─────────────────────────────────────────────
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:interview_preperation_buddy/app/themes/app_colors.dart';

class AppTextStyles {
  // Headline — Inter Bold
  static TextStyle get headline1 => GoogleFonts.inter(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    letterSpacing: -0.5,
    height: 1.2,
  );

  static TextStyle get headline2 => GoogleFonts.inter(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    letterSpacing: -0.3,
    height: 1.25,
  );

  static TextStyle get headline3 =>
      GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.textPrimary, height: 1.3);

  // Body — Inter Regular / Medium
  static TextStyle get bodyLarge =>
      GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w400, color: AppColors.textPrimary, height: 1.5);

  static TextStyle get bodyMedium =>
      GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.textSecondary, height: 1.5);

  static TextStyle get bodySmall =>
      GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w400, color: AppColors.textSecondary, height: 1.4);

  // Label — JetBrains Mono (for tags, chips, code)
  static TextStyle get labelLarge => GoogleFonts.jetBrainsMono(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    letterSpacing: 0.5,
  );

  static TextStyle get labelSmall => GoogleFonts.jetBrainsMono(
    fontSize: 11,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    letterSpacing: 0.8,
  );

  // Caption / overline (ALL CAPS tracking)
  static TextStyle get overline =>
      GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textSecondary, letterSpacing: 1.5);

  // Button
  static TextStyle get button =>
      GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textOnPrimary, letterSpacing: 0.3);
}
