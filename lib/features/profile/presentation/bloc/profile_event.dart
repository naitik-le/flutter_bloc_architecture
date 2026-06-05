import 'package:equatable/equatable.dart';
import 'package:flutter_bloc_architecture/features/profile/domain/entities/profile_entity.dart';

/// Base class for profile feature events.
abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

/// Triggers loading of profile details.
class LoadProfileEvent extends ProfileEvent {
  const LoadProfileEvent();
}

/// Triggers updating of profile details.
class UpdateProfileEvent extends ProfileEvent {
  /// The updated profile details.
  final ProfileEntity profile;

  /// Creates an [UpdateProfileEvent].
  const UpdateProfileEvent(this.profile);

  @override
  List<Object?> get props => [profile];
}

/// Resets the cached profile.
class ResetProfileEvent extends ProfileEvent {
  const ResetProfileEvent();
}
