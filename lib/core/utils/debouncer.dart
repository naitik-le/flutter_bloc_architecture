import 'dart:async';

/// Debounces rapid function calls by delaying execution.
///
/// Useful for search inputs, form validation, and other scenarios
/// where you want to wait for the user to stop typing before acting.
///
/// Usage:
/// ```dart
/// final debouncer = Debouncer(milliseconds: 300);
/// debouncer.run(() => performSearch(query));
/// ```
class Debouncer {
  /// The delay duration in milliseconds.
  final int milliseconds;

  Timer? _timer;

  /// Creates a [Debouncer] with the given delay in [milliseconds].
  Debouncer({this.milliseconds = 300});

  /// Runs the [action] after the debounce delay.
  ///
  /// If called again before the delay expires, the previous call is cancelled.
  void run(void Function() action) {
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }

  /// Cancels any pending debounced action.
  void cancel() {
    _timer?.cancel();
  }

  /// Disposes the debouncer and cancels any pending action.
  void dispose() {
    _timer?.cancel();
    _timer = null;
  }
}
