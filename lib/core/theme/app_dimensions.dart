import 'package:flutter/material.dart';

/// Responsive dimension helpers for adaptive layouts.
///
/// Provides screen size breakpoints and utility methods for
/// building responsive UIs across different device sizes.
class AppDimensions {
  AppDimensions._();

  // ── Breakpoints ──

  /// Mobile breakpoint: 600px.
  static const double mobileBreakpoint = 600;

  /// Tablet breakpoint: 900px.
  static const double tabletBreakpoint = 900;

  /// Desktop breakpoint: 1200px.
  static const double desktopBreakpoint = 1200;

  // ── Common Dimensions ──

  /// App bar height.
  static const double appBarHeight = 56.0;

  /// Bottom navigation bar height.
  static const double bottomNavHeight = 64.0;

  /// Standard icon size.
  static const double iconSize = 24.0;

  /// Small icon size.
  static const double iconSizeSmall = 16.0;

  /// Large icon size.
  static const double iconSizeLarge = 32.0;

  /// Standard avatar size.
  static const double avatarSize = 40.0;

  /// Large avatar size.
  static const double avatarSizeLarge = 64.0;

  /// Button height.
  static const double buttonHeight = 48.0;

  /// Input field height.
  static const double inputHeight = 52.0;

  /// Maximum content width for centered layouts.
  static const double maxContentWidth = 600.0;

  // ── Carousel Fractions ──
  static const double _carouselMobile  = 0.30;
  static const double _carouselTablet  = 0.38;
  static const double _carouselDesktop = 0.45;

  // ── Utility Methods ──

  /// Returns `true` if the current screen width is mobile-sized.
  static bool isMobile(BuildContext context) => MediaQuery.sizeOf(context).width < mobileBreakpoint;

  /// Returns `true` if the current screen width is tablet-sized.
  static bool isTablet(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return width >= mobileBreakpoint && width < desktopBreakpoint;
  }

  /// Returns `true` if the current screen width is desktop-sized.
  static bool isDesktop(BuildContext context) => MediaQuery.sizeOf(context).width >= desktopBreakpoint;

  /// Returns responsive carousel height based on screen size.
  static double carouselHeight(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    if (isDesktop(context)) return size.height * _carouselDesktop;
    if (isTablet(context))  return size.height * _carouselTablet;
    return size.height * _carouselMobile;
  }
}
