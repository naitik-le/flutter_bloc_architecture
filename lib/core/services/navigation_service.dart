import 'package:flutter/material.dart';

/// Global navigation service providing navigator access without [BuildContext].
///
/// Useful for navigating from BLoCs, services, and interceptors where
/// a BuildContext is not available.
///
/// Register via get_it and pass [navigatorKey] to [MaterialApp].
class NavigationService {
  /// Global navigator key to be used by [MaterialApp].
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  /// Current navigator state.
  NavigatorState? get navigator => navigatorKey.currentState;

  /// Current build context.
  BuildContext? get context => navigatorKey.currentContext;

  /// Push a named route.
  Future<T?>? pushNamed<T>(String routeName, {Object? arguments}) {
    return navigator?.pushNamed<T>(routeName, arguments: arguments);
  }

  /// Push a named route and replace the current one.
  Future<T?>? pushReplacementNamed<T>(
    String routeName, {
    Object? arguments,
  }) {
    return navigator?.pushReplacementNamed<T, dynamic>(
      routeName,
      arguments: arguments,
    );
  }

  /// Push a named route and remove all previous routes.
  Future<T?>? pushNamedAndRemoveUntil<T>(
    String routeName, {
    Object? arguments,
  }) {
    return navigator?.pushNamedAndRemoveUntil<T>(
      routeName,
      (_) => false,
      arguments: arguments,
    );
  }

  /// Pop the current route.
  void pop<T>([T? result]) {
    navigator?.pop(result);
  }

  /// Whether the navigator can pop the current route.
  bool canPop() => navigator?.canPop() ?? false;
}
