import 'package:flutter/material.dart';

/// Spacing constants and convenience widgets.
///
/// Provides consistent spacing throughout the app using predefined values.
/// Includes [CustomSizedBox] and [CustomPadding] widgets for clean layouts.
class AppSpacing {
  AppSpacing._();

  /// 2.0
  static const double xxxs = 2.0;

  /// 4.0
  static const double xxs = 4.0;

  /// 8.0
  static const double xs = 8.0;

  /// 12.0
  static const double sm = 12.0;

  /// 16.0
  static const double md = 16.0;

  /// 20.0
  static const double lg = 20.0;

  /// 24.0
  static const double xl = 24.0;

  /// 32.0
  static const double xxl = 32.0;

  /// 40.0
  static const double xxxl = 40.0;

  /// 48.0
  static const double huge = 48.0;

  /// 64.0
  static const double massive = 64.0;
}

/// A convenience wrapper around [SizedBox] with predefined spacing sizes.
///
/// Use named constructors for consistent horizontal and vertical spacing:
/// ```dart
/// const CustomSizedBox.hSm(),  // horizontal 12px
/// const CustomSizedBox.vMd(),  // vertical 16px
/// ```
class CustomSizedBox extends SizedBox {
  /// Creates a [SizedBox] with custom [width] and [height].
  const CustomSizedBox({super.key, super.width, super.height});

  // ── Vertical Spacers ──

  /// Vertical spacer: 2px.
  const CustomSizedBox.vXxxs({super.key}) : super(height: AppSpacing.xxxs);

  /// Vertical spacer: 4px.
  const CustomSizedBox.vXxs({super.key}) : super(height: AppSpacing.xxs);

  /// Vertical spacer: 8px.
  const CustomSizedBox.vXs({super.key}) : super(height: AppSpacing.xs);

  /// Vertical spacer: 12px.
  const CustomSizedBox.vSm({super.key}) : super(height: AppSpacing.sm);

  /// Vertical spacer: 16px.
  const CustomSizedBox.vMd({super.key}) : super(height: AppSpacing.md);

  /// Vertical spacer: 20px.
  const CustomSizedBox.vLg({super.key}) : super(height: AppSpacing.lg);

  /// Vertical spacer: 24px.
  const CustomSizedBox.vXl({super.key}) : super(height: AppSpacing.xl);

  /// Vertical spacer: 32px.
  const CustomSizedBox.vXxl({super.key}) : super(height: AppSpacing.xxl);

  /// Vertical spacer: 40px.
  const CustomSizedBox.vXxxl({super.key}) : super(height: AppSpacing.xxxl);

  // ── Horizontal Spacers ──

  /// Horizontal spacer: 2px.
  const CustomSizedBox.hXxxs({super.key}) : super(width: AppSpacing.xxxs);

  /// Horizontal spacer: 4px.
  const CustomSizedBox.hXxs({super.key}) : super(width: AppSpacing.xxs);

  /// Horizontal spacer: 8px.
  const CustomSizedBox.hXs({super.key}) : super(width: AppSpacing.xs);

  /// Horizontal spacer: 12px.
  const CustomSizedBox.hSm({super.key}) : super(width: AppSpacing.sm);

  /// Horizontal spacer: 16px.
  const CustomSizedBox.hMd({super.key}) : super(width: AppSpacing.md);

  /// Horizontal spacer: 20px.
  const CustomSizedBox.hLg({super.key}) : super(width: AppSpacing.lg);

  /// Horizontal spacer: 24px.
  const CustomSizedBox.hXl({super.key}) : super(width: AppSpacing.xl);

  /// Horizontal spacer: 32px.
  const CustomSizedBox.hXxl({super.key}) : super(width: AppSpacing.xxl);
}

/// A convenience wrapper around [Padding] for consistent spacing.
class CustomPadding extends Padding {
  /// Creates a [CustomPadding] with the given [padding] and [child].
  const CustomPadding({
    super.key,
    required super.padding,
    super.child,
  });
}
