import 'package:flutter/material.dart';

/// Semantic color palette for the application.
///
/// Defines all colors used throughout the app in a centralized location.
/// Supports both light and dark theme variants.
class AppColors {
  AppColors._();

  // ── Primary Brand Colors ──

  /// Primary brand color - Muted Olive Green.
  static const Color primary = Color(0xFF5F6F52);

  /// Lighter primary variant - Sage Green.
  static const Color primaryLight = Color(0xFFA9B388);

  /// Darker primary variant - Deep Espresso/Dark Brown.
  static const Color primaryDark = Color(0xFF5B3E2B);

  /// Primary color with opacity for backgrounds.
  static const Color primaryBackground = Color(0xFFFAF6E9);

  // ── Secondary Colors ──

  /// Secondary accent color - Terracotta/Burnt Orange.
  static const Color secondary = Color(0xFFC87A24);

  /// Secondary light variant - Sand/Tan.
  static const Color secondaryLight = Color(0xFFB59A7C);

  /// Secondary dark variant - Deep Terracotta.
  static const Color secondaryDark = Color(0xFF9E5410);

  // ── Semantic Colors ──

  /// Success state color - Soft Sage/Forest Green.
  static const Color success = Color(0xFF527E5A);

  /// Warning state color - Sand/Warm Yellow-Orange.
  static const Color warning = Color(0xFFD4A373);

  /// Error/danger state color - Muted Warm Red.
  static const Color error = Color(0xFFBC4A3C);

  /// Informational state color - Muted Slate/Sage Blue.
  static const Color info = Color(0xFF5D7B93);

  // ── Neutral Colors ──

  /// Scaffold/page background (light mode) - Cozy Warm Cream.
  static const Color scaffoldLight = Color(0xFFFAF7EE);

  /// Scaffold/page background (dark mode) - Warm Charcoal.
  static const Color scaffoldDark = Color(0xFF1E1B18);

  /// Card/surface background (light mode) - Soft Warm White.
  static const Color surfaceLight = Color(0xFFFEFDFB);

  /// Card/surface background (dark mode) - Warm Dark Grey.
  static const Color surfaceDark = Color(0xFF2C2825);

  /// Divider/border color (light mode).
  static const Color dividerLight = Color(0xFFE8E3D9);

  /// Divider/border color (dark mode).
  static const Color dividerDark = Color(0xFF3E3935);

  // ── Text Colors ──

  /// Primary text color (light mode) - Deep Espresso Brown.
  static const Color textPrimaryLight = Color(0xFF2D241E);

  /// Secondary text color (light mode) - Muted Brownish Grey.
  static const Color textSecondaryLight = Color(0xFF63564D);

  /// Tertiary/hint text color (light mode) - Light Warm Sand/Grey.
  static const Color textTertiaryLight = Color(0xFF9E928A);

  /// Primary text color (dark mode) - Soft Cream/Off-white.
  static const Color textPrimaryDark = Color(0xFFFAF5ED);

  /// Secondary text color (dark mode) - Muted Warm Sand/Grey.
  static const Color textSecondaryDark = Color(0xFFC7BEB5);

  /// Tertiary/hint text color (dark mode) - Darker Warm Grey.
  static const Color textTertiaryDark = Color(0xFF8F847C);

  /// Text on primary-colored backgrounds.
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // ── Other ──

  /// Shadow color for elevation (warm/soft brown shadow).
  static const Color shadow = Color(0x122D241E);

  /// Transparent color.
  static const Color transparent = Colors.transparent;

  /// White color.
  static const Color white = Color(0xFFFFFFFF);

  /// Black color.
  static const Color black = Color(0xFF000000);
}
