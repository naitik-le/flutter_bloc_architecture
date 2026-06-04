import 'package:flutter/material.dart';

/// Border radius constants for consistent corner rounding.
class AppRadius {
  AppRadius._();

  /// No radius — sharp corners.
  static const double none = 0.0;

  /// Extra small radius: 4px.
  static const double xs = 4.0;

  /// Small radius: 8px.
  static const double sm = 8.0;

  /// Medium radius: 12px.
  static const double md = 12.0;

  /// Large radius: 16px.
  static const double lg = 16.0;

  /// Extra large radius: 20px.
  static const double xl = 20.0;

  /// Extra extra large radius: 24px.
  static const double xxl = 24.0;

  /// Full/pill radius: 999px.
  static const double full = 999.0;

  // ── Pre-built BorderRadius ──

  /// Circular border radius: extra small.
  static BorderRadius get circularXs => BorderRadius.circular(xs);

  /// Circular border radius: small.
  static BorderRadius get circularSm => BorderRadius.circular(sm);

  /// Circular border radius: medium.
  static BorderRadius get circularMd => BorderRadius.circular(md);

  /// Circular border radius: large.
  static BorderRadius get circularLg => BorderRadius.circular(lg);

  /// Circular border radius: extra large.
  static BorderRadius get circularXl => BorderRadius.circular(xl);

  /// Circular border radius: pill shape.
  static BorderRadius get circularFull => BorderRadius.circular(full);
}
