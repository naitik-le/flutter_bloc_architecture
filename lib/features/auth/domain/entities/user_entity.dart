import 'package:equatable/equatable.dart';

/// Immutable user entity for the domain layer.
///
/// Contains core user properties without any serialization logic.
/// Data-layer models extend this entity.
class UserEntity extends Equatable {
  /// Unique user identifier.
  final int id;

  /// User's email address.
  final String email;

  /// User's first name.
  final String firstName;

  /// User's last name.
  final String lastName;

  /// URL to the user's avatar image.
  final String? avatar;

  /// Creates a [UserEntity].
  const UserEntity({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.avatar,
  });

  /// Returns the user's full name.
  String get fullName => '$firstName $lastName';

  @override
  List<Object?> get props => [id, email, firstName, lastName, avatar];
}
