part of 'auth_bloc.dart';

/// State for the [AuthBloc].
///
/// Represents the authentication state of the application using status flags.
@immutable
class AuthState extends Equatable {
  /// Whether an authentication request is in progress.
  final bool isLoading;

  /// The error message, if authentication failed.
  final String? errorMsg;

  /// Whether the authentication operation succeeded.
  final bool isCompleted;

  /// Whether the authentication operation failed.
  final bool isFailed;

  /// Whether the user logged out.
  final bool isLoggedOut;

  /// The authenticated user entity.
  final UserEntity? user;

  /// Creates an [AuthState].
  const AuthState({
    this.isLoading = false,
    this.errorMsg = '',
    this.isCompleted = false,
    this.isFailed = false,
    this.isLoggedOut = false,
    this.user,
  });

  @override
  List<Object?> get props => [
        isLoading,
        errorMsg,
        isCompleted,
        isFailed,
        isLoggedOut,
        user,
      ];
}
