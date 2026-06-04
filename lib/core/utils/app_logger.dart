import 'package:logger/logger.dart';

/// Structured application logger built on the [Logger] package.
///
/// Provides categorized logging methods with consistent formatting.
/// Uses [Logger] internally for pretty-printed console output.
class AppLogger {
  AppLogger._();

  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 5,
      lineLength: 80,
      colors: true,
      printEmojis: true,
    ),
  );

  /// Log a debug message.
  static void debug(dynamic message) => _logger.d(message);

  /// Log an informational message.
  static void info(dynamic message) => _logger.i(message);

  /// Log a warning message.
  static void warning(dynamic message) => _logger.w(message);

  /// Log an error message with optional [error] and [stackTrace].
  static void error(
    dynamic message, {
    dynamic error,
    StackTrace? stackTrace,
  }) =>
      _logger.e(message, error: error, stackTrace: stackTrace);

  /// Log a fatal/critical error with optional [error] and [stackTrace].
  static void fatal(
    dynamic message, {
    dynamic error,
    StackTrace? stackTrace,
  }) =>
      _logger.f(message, error: error, stackTrace: stackTrace);
}
