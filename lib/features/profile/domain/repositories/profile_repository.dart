import 'package:flutter_bloc_architecture/features/profile/domain/entities/profile_entity.dart';

/// Repository interface handling profile data updates and caching.
abstract class ProfileRepository {
  /// Fetches the profile, either from network/local storage.
  Future<ProfileEntity> getProfile();

  /// Updates the profile data and persists changes.
  Future<ProfileEntity> updateProfile(ProfileEntity profile);

  /// Clears the cached profile details.
  Future<void> clearProfile();
}
