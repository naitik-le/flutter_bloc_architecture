/// Custom exception types for the data layer.
///
/// These exceptions are caught in repository implementations and
/// mapped to domain-layer [Failure] types.
library;

/// Exception thrown when a server/API call fails.
class ServerException implements Exception {
  /// Error message from the server.
  final String message;

  /// HTTP status code.
  final int? statusCode;

  /// Creates a [ServerException].
  const ServerException({
    this.message = 'Server error occurred',
    this.statusCode,
  });

  @override
  String toString() =>
      'ServerException(message: $message, statusCode: $statusCode)';
}

/// Exception thrown when a cache/storage operation fails.
class CacheException implements Exception {
  /// Error message.
  final String message;

  /// Creates a [CacheException].
  const CacheException({
    this.message = 'Cache error occurred',
  });

  @override
  String toString() => 'CacheException(message: $message)';
}

/// Exception thrown when there is no internet connectivity.
class NetworkException implements Exception {
  /// Error message.
  final String message;

  /// Creates a [NetworkException].
  const NetworkException({
    this.message = 'No internet connection',
  });

  @override
  String toString() => 'NetworkException(message: $message)';
}

/// Exception thrown for authentication failures.
class AuthException implements Exception {
  /// Error message.
  final String message;

  /// Creates an [AuthException].
  const AuthException({
    this.message = 'Authentication failed',
  });

  @override
  String toString() => 'AuthException(message: $message)';
}
