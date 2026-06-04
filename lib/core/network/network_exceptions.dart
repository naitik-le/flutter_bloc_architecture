import 'package:dio/dio.dart';

/// Typed network exception handling.
///
/// Maps [DioException] types to human-readable, categorized exceptions
/// for clean error handling throughout the app.
class NetworkExceptions implements Exception {
  /// Human-readable error message.
  final String message;

  /// The type of network error.
  final NetworkExceptionType type;

  /// Creates a [NetworkExceptions] with the given [message] and [type].
  const NetworkExceptions({
    required this.message,
    required this.type,
  });

  /// Factory that maps a [DioException] to a typed [NetworkExceptions].
  factory NetworkExceptions.fromDioException(DioException exception) {
    switch (exception.type) {
      case DioExceptionType.connectionTimeout:
        return const NetworkExceptions(
          message: 'Connection timed out',
          type: NetworkExceptionType.timeout,
        );
      case DioExceptionType.sendTimeout:
        return const NetworkExceptions(
          message: 'Send timeout',
          type: NetworkExceptionType.timeout,
        );
      case DioExceptionType.receiveTimeout:
        return const NetworkExceptions(
          message: 'Receive timeout',
          type: NetworkExceptionType.timeout,
        );
      case DioExceptionType.badResponse:
        return NetworkExceptions._fromStatusCode(
          exception.response?.statusCode,
          exception.response?.data,
        );
      case DioExceptionType.cancel:
        return const NetworkExceptions(
          message: 'Request cancelled',
          type: NetworkExceptionType.cancel,
        );
      case DioExceptionType.connectionError:
        return const NetworkExceptions(
          message: 'No internet connection',
          type: NetworkExceptionType.noInternet,
        );
      case DioExceptionType.unknown:
      default:
        return const NetworkExceptions(
          message: 'An unexpected error occurred',
          type: NetworkExceptionType.unknown,
        );
    }
  }

  /// Maps HTTP status codes to specific exceptions.
  factory NetworkExceptions._fromStatusCode(int? statusCode, dynamic data) {
    final String message = _extractMessage(data);

    switch (statusCode) {
      case 400:
        return NetworkExceptions(
          message: message.isNotEmpty ? message : 'Bad request',
          type: NetworkExceptionType.badRequest,
        );
      case 401:
        return NetworkExceptions(
          message: message.isNotEmpty ? message : 'Unauthorized',
          type: NetworkExceptionType.unauthorized,
        );
      case 403:
        return NetworkExceptions(
          message: message.isNotEmpty ? message : 'Forbidden',
          type: NetworkExceptionType.forbidden,
        );
      case 404:
        return NetworkExceptions(
          message: message.isNotEmpty ? message : 'Not found',
          type: NetworkExceptionType.notFound,
        );
      case 409:
        return NetworkExceptions(
          message: message.isNotEmpty ? message : 'Conflict',
          type: NetworkExceptionType.conflict,
        );
      case 500:
        return NetworkExceptions(
          message: message.isNotEmpty ? message : 'Internal server error',
          type: NetworkExceptionType.internalServerError,
        );
      case 503:
        return NetworkExceptions(
          message: message.isNotEmpty ? message : 'Service unavailable',
          type: NetworkExceptionType.serviceUnavailable,
        );
      default:
        return NetworkExceptions(
          message: message.isNotEmpty ? message : 'Something went wrong',
          type: NetworkExceptionType.unknown,
        );
    }
  }

  /// Extracts a human-readable message from response data.
  static String _extractMessage(dynamic data) {
    if (data is Map<String, dynamic>) {
      return (data['error'] ?? data['message'] ?? '').toString();
    }
    return '';
  }

  @override
  String toString() => 'NetworkExceptions($type): $message';
}

/// Categorized network exception types.
enum NetworkExceptionType {
  /// Request timed out.
  timeout,

  /// No internet connectivity.
  noInternet,

  /// Bad request (400).
  badRequest,

  /// Unauthorized (401).
  unauthorized,

  /// Forbidden (403).
  forbidden,

  /// Resource not found (404).
  notFound,

  /// Conflict (409).
  conflict,

  /// Internal server error (500).
  internalServerError,

  /// Service unavailable (503).
  serviceUnavailable,

  /// Request was cancelled.
  cancel,

  /// Unknown/unclassified error.
  unknown,
}
