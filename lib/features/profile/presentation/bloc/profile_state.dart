import 'package:equatable/equatable.dart';
import 'package:flutter_bloc_architecture/features/profile/domain/entities/profile_entity.dart';

/// Enum representing the status of profile operations.
enum ProfileStatus {
  /// Initial state.
  initial,

  /// Action is in progress.
  loading,

  /// Action succeeded.
  success,

  /// Action failed.
  failure,
}

/// State representing user profile screen details and processes.
class ProfileState extends Equatable {
  /// Operational status.
  final ProfileStatus status;

  /// User profile entity details.
  final ProfileEntity? profile;

  /// Optional error message.
  final String? errorMsg;

  /// Creates a [ProfileState].
  const ProfileState({
    this.status = ProfileStatus.initial,
    this.profile,
    this.errorMsg,
  });

  /// Creates a copy with optional field overrides.
  ProfileState copyWith({
    ProfileStatus? status,
    ProfileEntity? profile,
    String? errorMsg,
  }) {
    return ProfileState(
      status: status ?? this.status,
      profile: profile ?? this.profile,
      errorMsg: errorMsg ?? this.errorMsg,
    );
  }

  @override
  List<Object?> get props => [status, profile, errorMsg];
}
