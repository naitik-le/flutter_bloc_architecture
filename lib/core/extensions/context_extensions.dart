import 'package:flutter/material.dart';

/// Convenience extensions on [BuildContext] for common operations.
///
/// Reduces boilerplate for accessing theme, media query, and navigation.
extension ContextExtensions on BuildContext {
  // ── Theme ──

  /// Access the current [ThemeData].
  ThemeData get theme => Theme.of(this);

  /// Access the current [ColorScheme].
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  /// Access the current [TextTheme].
  TextTheme get textTheme => Theme.of(this).textTheme;

  /// Whether the current theme is dark mode.
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;

  // ── Media Query ──

  /// Screen size.
  Size get screenSize => MediaQuery.sizeOf(this);

  /// Screen width.
  double get screenWidth => MediaQuery.sizeOf(this).width;

  /// Screen height.
  double get screenHeight => MediaQuery.sizeOf(this).height;

  /// Top padding (status bar height).
  double get topPadding => MediaQuery.paddingOf(this).top;

  /// Bottom padding (navigation bar / home indicator height).
  double get bottomPadding => MediaQuery.paddingOf(this).bottom;

  // ── Navigation ──

  /// Push a named route.
  Future<T?> pushNamed<T>(String routeName, {Object? arguments}) =>
      Navigator.of(this).pushNamed<T>(routeName, arguments: arguments);

  /// Push a named route and remove all previous routes.
  Future<T?> pushNamedAndRemoveAll<T>(String routeName, {Object? arguments}) =>
      Navigator.of(this).pushNamedAndRemoveUntil<T>(
        routeName,
        (_) => false,
        arguments: arguments,
      );

  /// Pop the current route.
  void pop<T>([T? result]) => Navigator.of(this).pop(result);

  /// Push a named route and replace the current route.
  Future<T?> pushReplacementNamed<T>(
    String routeName, {
    Object? arguments,
  }) =>
      Navigator.of(this).pushReplacementNamed<T, dynamic>(
        routeName,
        arguments: arguments,
      );

  // ── Snackbar ──

  /// Show a premium styled custom [SnackBar] with [message].
  void showSnackBar(
    String message, {
    SnackBarType type = SnackBarType.info,
    Duration? duration,
  }) {
    final theme = Theme.of(this);
    Color backgroundColor;
    IconData icon;

    switch (type) {
      case SnackBarType.success:
        backgroundColor = const Color(0xFF527E5A);
        icon = Icons.check_circle_rounded;
        break;
      case SnackBarType.error:
        backgroundColor = const Color(0xFFBC4A3C);
        icon = Icons.cancel_rounded;
        break;
      case SnackBarType.warning:
        backgroundColor = const Color(0xFFD4A373);
        icon = Icons.warning_rounded;
        break;
      case SnackBarType.info:
        backgroundColor = theme.colorScheme.primary;
        icon = Icons.info_rounded;
        break;
    }

    ScaffoldMessenger.of(this).removeCurrentSnackBar();
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        duration: duration ?? const Duration(seconds: 3),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        padding: EdgeInsets.zero,
        content: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: backgroundColor.withValues(alpha: 0.35),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(icon, color: Colors.white, size: 22),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Focus ──

  /// Unfocus any currently focused input field.
  void unfocus() => FocusScope.of(this).unfocus();
}

/// Custom SnackBar types for visual styling.
enum SnackBarType {
  /// Success notification.
  success,

  /// Error notification.
  error,

  /// Warning notification.
  warning,

  /// General info notification.
  info,
}
