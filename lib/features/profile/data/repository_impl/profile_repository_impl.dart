import 'package:flutter_bloc_architecture/core/storage/local_storage_service.dart';
import 'package:flutter_bloc_architecture/features/profile/data/datasource/profile_local_data_source.dart';
import 'package:flutter_bloc_architecture/features/profile/data/models/profile_model.dart';
import 'package:flutter_bloc_architecture/features/profile/domain/entities/profile_entity.dart';
import 'package:flutter_bloc_architecture/features/profile/domain/repositories/profile_repository.dart';
import 'package:get_it/get_it.dart';

/// Concrete implementation of [ProfileRepository] using local data caching.
class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileLocalDataSource _localDataSource;
  final LocalStorageService _localStorage = GetIt.I<LocalStorageService>();

  /// Creates a [ProfileRepositoryImpl].
  ProfileRepositoryImpl(this._localDataSource);

  @override
  Future<ProfileEntity> getProfile() async {
    final cached = _localDataSource.getCachedProfile();
    if (cached != null) {
      return cached;
    }

    // Default values if no profile is cached yet.
    // Try to retrieve the email stored during authentication.
    final savedEmail =
        _localStorage.getString('auth_user_email') ?? 'explorer@spacex.com';

    final defaultProfile = ProfileModel(
      firstName: 'Stellar',
      lastName: 'Explorer',
      email: savedEmail,
      avatarUrl: 'astronaut', // Key identifier for preloaded avatar icon
      favoriteRocket: 'Falcon 9',
      notificationsEnabled: true,
      biometricEnabled: false,
      explorerXp: 750,
      rank: 'Mars Pioneer',
    );

    // Cache the default profile
    await _localDataSource.cacheProfile(defaultProfile);
    return defaultProfile;
  }

  @override
  Future<ProfileEntity> updateProfile(ProfileEntity profile) async {
    final model = ProfileModel(
      firstName: profile.firstName,
      lastName: profile.lastName,
      email: profile.email,
      avatarUrl: profile.avatarUrl,
      favoriteRocket: profile.favoriteRocket,
      notificationsEnabled: profile.notificationsEnabled,
      biometricEnabled: profile.biometricEnabled,
      explorerXp: profile.explorerXp,
      rank: profile.rank,
    );
    await _localDataSource.cacheProfile(model);
    return model;
  }

  @override
  Future<void> clearProfile() async {
    await _localDataSource.clearCachedProfile();
  }
}
