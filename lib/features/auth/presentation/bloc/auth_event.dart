part of 'auth_bloc.dart';

/// Events for the [AuthBloc].
///
/// Each event represents a user action related to authentication.
@immutable
abstract class AuthEvent extends Equatable {
  /// Creates an [AuthEvent].
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

/// Event dispatched when the user requests to log in.
class PerformLoginEvent extends AuthEvent {
  final String email;
  final String password;

  /// Creates a [PerformLoginEvent] event.
  const PerformLoginEvent({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}

/// Event dispatched when the user requests to register.
class PerformRegisterEvent extends AuthEvent {
  final String email;
  final String password;
  final String firstName;
  final String lastName;

  /// Creates a [PerformRegisterEvent] event.
  const PerformRegisterEvent({
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
  });

  @override
  List<Object?> get props => [email, password, firstName, lastName];
}

/// Event dispatched when the user requests to log out.
class PerformLogoutEvent extends AuthEvent {
  /// Creates a [PerformLogoutEvent] event.
  const PerformLogoutEvent();
}

/// Event dispatched to check if the user is already authenticated.
class CheckAuthStatusEvent extends AuthEvent {
  /// Creates a [CheckAuthStatusEvent] event.
  const CheckAuthStatusEvent();
}
