import 'dart:convert';
import 'package:flutter_bloc_architecture/core/storage/local_storage_service.dart';
import 'package:flutter_bloc_architecture/features/profile/data/models/profile_model.dart';

/// Local data source to persist user profile details.
class ProfileLocalDataSource {
  final LocalStorageService _storage;
  static const String _profileKey = 'cached_user_profile';

  /// Creates a [ProfileLocalDataSource].
  ProfileLocalDataSource(this._storage);

  /// Retrieves the saved profile or returns `null` if not present.
  ProfileModel? getCachedProfile() {
    final rawJson = _storage.getString(_profileKey);
    if (rawJson == null) return null;
    try {
      final decoded = jsonDecode(rawJson) as Map<String, dynamic>;
      return ProfileModel.fromJson(decoded);
    } catch (_) {
      return null;
    }
  }

  /// Caches the given [profile].
  Future<bool> cacheProfile(ProfileModel profile) {
    final rawJson = jsonEncode(profile.toJson());
    return _storage.setString(_profileKey, rawJson);
  }

  /// Removes the cached profile.
  Future<bool> clearCachedProfile() {
    return _storage.remove(_profileKey);
  }
}
