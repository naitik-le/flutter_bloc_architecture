import 'package:equatable/equatable.dart';

/// Base failure class for the domain layer.
///
/// All domain-layer failures extend this class to provide typed error handling
/// without exposing data-layer exceptions to the presentation layer.
abstract class Failure extends Equatable {
  /// Human-readable failure message.
  final String message;

  /// Optional error code for programmatic handling.
  final int? code;

  /// Creates a [Failure] with an optional [message] and [code].
  const Failure({
    this.message = 'An unexpected error occurred',
    this.code,
  });

  @override
  List<Object?> get props => [message, code];
}

/// Failure originating from a server/API error.
class ServerFailure extends Failure {
  /// Creates a [ServerFailure] with the given [message] and [code].
  const ServerFailure({
    super.message = 'Server error occurred',
    super.code,
  });
}

/// Failure due to network connectivity issues.
class NetworkFailure extends Failure {
  /// Creates a [NetworkFailure].
  const NetworkFailure({
    super.message = 'No internet connection',
  });
}

/// Failure from local cache or storage operations.
class CacheFailure extends Failure {
  /// Creates a [CacheFailure].
  const CacheFailure({
    super.message = 'Cache error occurred',
  });
}

/// Failure from authentication-related issues.
class AuthFailure extends Failure {
  /// Creates an [AuthFailure].
  const AuthFailure({
    super.message = 'Authentication failed',
    super.code,
  });
}

/// Failure from form validation.
class ValidationFailure extends Failure {
  /// Creates a [ValidationFailure].
  const ValidationFailure({
    super.message = 'Validation failed',
  });
}
