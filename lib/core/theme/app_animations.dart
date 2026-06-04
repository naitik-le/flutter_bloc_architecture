import 'package:flutter/material.dart';

/// Animation duration and curve constants for consistent motion design.
class AppAnimations {
  AppAnimations._();

  // ── Durations ──

  /// Instant — 0ms.
  static const Duration instant = Duration.zero;

  /// Fast — 150ms.
  static const Duration fast = Duration(milliseconds: 150);

  /// Normal — 300ms.
  static const Duration normal = Duration(milliseconds: 300);

  /// Slow — 500ms.
  static const Duration slow = Duration(milliseconds: 500);

  /// Very slow — 800ms.
  static const Duration verySlow = Duration(milliseconds: 800);

  // ── Curves ──

  /// Standard ease-in-out curve.
  static const Curve standard = Curves.easeInOut;

  /// Emphasized curve for entrances.
  static const Curve emphasized = Curves.easeOutCubic;

  /// Deceleration curve for exits.
  static const Curve decelerate = Curves.easeInCubic;

  /// Overshoot curve for playful interactions.
  static const Curve overshoot = Curves.elasticOut;

  /// Fast out, slow in curve for transitions.
  static const Curve fastOutSlowIn = Curves.fastOutSlowIn;
}
