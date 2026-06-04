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

  /// Show a [SnackBar] with the given [message].
  void showSnackBar(String message, {Duration? duration}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: duration ?? const Duration(seconds: 3),
      ),
    );
  }

  // ── Focus ──

  /// Unfocus any currently focused input field.
  void unfocus() => FocusScope.of(this).unfocus();
}
