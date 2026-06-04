import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import 'package:flutter_bloc_architecture/core/network/api_status.dart';
import 'package:flutter_bloc_architecture/features/auth/domain/entities/user_entity.dart';
import 'package:flutter_bloc_architecture/features/auth/domain/repositories/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

/// BLoC for handling authentication events and state transitions.
///
/// Processes [AuthEvent]s through [AuthRepository] and emits [AuthState]s.
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final _repository = GetIt.I<AuthRepository>();

  /// Creates an [AuthBloc].
  AuthBloc() : super(const AuthState()) {
    on<PerformLoginEvent>(_onLoginRequested);
    on<PerformRegisterEvent>(_onRegisterRequested);
    on<PerformLogoutEvent>(_onLogoutRequested);
    on<CheckAuthStatusEvent>(_onCheckAuthStatus);
  }

  Future<void> _onLoginRequested(
    PerformLoginEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthState(isLoading: true));

    final response = await _repository.login(
      email: event.email,
      password: event.password,
    );

    if (response.status == ApiStatus.error) {
      emit(
        AuthState(
          isFailed: true,
          errorMsg: response.errorMsg,
        ),
      );
    } else if (response.data != null) {
      emit(
        AuthState(
          isCompleted: true,
          user: response.data,
        ),
      );
    } else {
      emit(
        const AuthState(
          isFailed: true,
          errorMsg: 'An unexpected error occurred',
        ),
      );
    }
  }

  Future<void> _onRegisterRequested(
    PerformRegisterEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthState(isLoading: true));

    final response = await _repository.register(
      email: event.email,
      password: event.password,
      firstName: event.firstName,
      lastName: event.lastName,
    );

    if (response.status == ApiStatus.error) {
      emit(
        AuthState(
          isFailed: true,
          errorMsg: response.errorMsg,
        ),
      );
    } else if (response.data != null) {
      emit(
        AuthState(
          isCompleted: true,
          user: response.data,
        ),
      );
    } else {
      emit(
        const AuthState(
          isFailed: true,
          errorMsg: 'An unexpected error occurred',
        ),
      );
    }
  }

  Future<void> _onLogoutRequested(
    PerformLogoutEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthState(isLoading: true));
    await _repository.logout();
    emit(const AuthState(isLoggedOut: true));
  }

  Future<void> _onCheckAuthStatus(
    CheckAuthStatusEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthState(isLoading: true));
    final hasToken = await _repository.isLoggedIn();
    if (hasToken) {
      emit(
        const AuthState(
          isCompleted: true,
        ),
      );
    } else {
      emit(
        const AuthState(
          isLoggedOut: true,
        ),
      );
    }
  }
}
