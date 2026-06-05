import 'package:equatable/equatable.dart';

/// Domain entity representing a user's detailed profile, including preferences and experience details.
class ProfileEntity extends Equatable {
  /// User's first name.
  final String firstName;

  /// User's last name.
  final String lastName;

  /// User's email.
  final String email;

  /// Path or network URL for the user's avatar.
  final String avatarUrl;

  /// User's favorite SpaceX rocket.
  final String favoriteRocket;

  /// Status of push notifications setting.
  final bool notificationsEnabled;

  /// Status of biometric lock setting.
  final bool biometricEnabled;

  /// XP gathered by the user in the app.
  final int explorerXp;

  /// Explorer title or level.
  final String rank;

  /// Creates a [ProfileEntity].
  const ProfileEntity({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.avatarUrl,
    required this.favoriteRocket,
    required this.notificationsEnabled,
    required this.biometricEnabled,
    required this.explorerXp,
    required this.rank,
  });

  /// Helper to get the full name.
  String get fullName => '$firstName $lastName'.trim().isEmpty
      ? 'Space Cadet'
      : '$firstName $lastName';

  @override
  List<Object?> get props => [
        firstName,
        lastName,
        email,
        avatarUrl,
        favoriteRocket,
        notificationsEnabled,
        biometricEnabled,
        explorerXp,
        rank,
      ];
}
