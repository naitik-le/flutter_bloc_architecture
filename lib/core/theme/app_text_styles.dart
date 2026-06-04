import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Application typography scale.
///
/// Uses Google Fonts (Inter) for a modern, clean look.
/// Call [AppTextStyles.init] at app startup to load the font.
class AppTextStyles {
  AppTextStyles._();

  static late TextStyle _baseStyle;

  /// Initializes the base text style with Google Fonts.
  ///
  /// Must be called before any text styles are accessed.
  static void init() {
    _baseStyle = GoogleFonts.inter();
  }

  // ── Display ──

  /// Display large — hero sections.
  static TextStyle get displayLarge => _baseStyle.copyWith(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        height: 1.2,
        letterSpacing: -0.5,
      );

  /// Display medium — page titles.
  static TextStyle get displayMedium => _baseStyle.copyWith(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        height: 1.25,
        letterSpacing: -0.25,
      );

  /// Display small — section headers.
  static TextStyle get displaySmall => _baseStyle.copyWith(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        height: 1.3,
      );

  // ── Headline ──

  /// Headline large.
  static TextStyle get headlineLarge => _baseStyle.copyWith(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        height: 1.3,
      );

  /// Headline medium.
  static TextStyle get headlineMedium => _baseStyle.copyWith(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        height: 1.35,
      );

  /// Headline small.
  static TextStyle get headlineSmall => _baseStyle.copyWith(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        height: 1.4,
      );

  // ── Title ──

  /// Title large.
  static TextStyle get titleLarge => _baseStyle.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        height: 1.4,
      );

  /// Title medium.
  static TextStyle get titleMedium => _baseStyle.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        height: 1.45,
      );

  /// Title small.
  static TextStyle get titleSmall => _baseStyle.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        height: 1.5,
      );

  // ── Body ──

  /// Body large — primary content text.
  static TextStyle get bodyLarge => _baseStyle.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.5,
      );

  /// Body medium — secondary content text.
  static TextStyle get bodyMedium => _baseStyle.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.5,
      );

  /// Body small — captions and fine print.
  static TextStyle get bodySmall => _baseStyle.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 1.5,
      );

  // ── Label ──

  /// Label large — buttons and inputs.
  static TextStyle get labelLarge => _baseStyle.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        height: 1.4,
        letterSpacing: 0.1,
      );

  /// Label medium — chips and tags.
  static TextStyle get labelMedium => _baseStyle.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        height: 1.4,
        letterSpacing: 0.5,
      );

  /// Label small — overlines.
  static TextStyle get labelSmall => _baseStyle.copyWith(
        fontSize: 10,
        fontWeight: FontWeight.w500,
        height: 1.6,
        letterSpacing: 0.5,
      );
}
