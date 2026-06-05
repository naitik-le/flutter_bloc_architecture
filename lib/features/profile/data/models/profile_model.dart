import 'package:flutter_bloc_architecture/features/profile/domain/entities/profile_entity.dart';

/// Data layer model extending [ProfileEntity] with JSON serialization.
class ProfileModel extends ProfileEntity {
  /// Creates a [ProfileModel].
  const ProfileModel({
    required super.firstName,
    required super.lastName,
    required super.email,
    required super.avatarUrl,
    required super.favoriteRocket,
    required super.notificationsEnabled,
    required super.biometricEnabled,
    required super.explorerXp,
    required super.rank,
  });

  /// Factory constructor to parse JSON into a [ProfileModel].
  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      firstName: json['first_name'] as String? ?? '',
      lastName: json['last_name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      avatarUrl: json['avatar_url'] as String? ?? '',
      favoriteRocket: json['favorite_rocket'] as String? ?? 'Falcon 9',
      notificationsEnabled: json['notifications_enabled'] as bool? ?? true,
      biometricEnabled: json['biometric_enabled'] as bool? ?? false,
      explorerXp: json['explorer_xp'] as int? ?? 350,
      rank: json['rank'] as String? ?? 'Space Cadet',
    );
  }

  /// Converts this model instance into a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'avatar_url': avatarUrl,
      'favorite_rocket': favoriteRocket,
      'notifications_enabled': notificationsEnabled,
      'biometric_enabled': biometricEnabled,
      'explorer_xp': explorerXp,
      'rank': rank,
    };
  }

  /// Create a copied instance with overridden fields.
  ProfileModel copyWith({
    String? firstName,
    String? lastName,
    String? email,
    String? avatarUrl,
    String? favoriteRocket,
    bool? notificationsEnabled,
    bool? biometricEnabled,
    int? explorerXp,
    String? rank,
  }) {
    return ProfileModel(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      favoriteRocket: favoriteRocket ?? this.favoriteRocket,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      biometricEnabled: biometricEnabled ?? this.biometricEnabled,
      explorerXp: explorerXp ?? this.explorerXp,
      rank: rank ?? this.rank,
    );
  }
}
