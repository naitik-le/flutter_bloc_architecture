import 'package:flutter_bloc_architecture/features/auth/domain/entities/user_entity.dart';

/// Data-layer user model with JSON serialization.
///
/// Extends [UserEntity] and adds `fromJson` / `toJson` methods
/// for API communication. Keep models immutable where possible.
class UserModel extends UserEntity {
  /// Creates a [UserModel].
  const UserModel({
    required super.id,
    required super.email,
    required super.firstName,
    required super.lastName,
    super.avatar,
  });

  /// Creates a [UserModel] from a JSON [Map].
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int? ?? 0,
      email: json['email'] as String? ?? '',
      firstName: json['first_name'] as String? ?? '',
      lastName: json['last_name'] as String? ?? '',
      avatar: json['avatar'] as String?,
    );
  }

  /// Converts this [UserModel] to a JSON [Map].
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'avatar': avatar,
    };
  }

  /// Creates a copy with optional field overrides.
  UserModel copyWith({
    int? id,
    String? email,
    String? firstName,
    String? lastName,
    String? avatar,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      avatar: avatar ?? this.avatar,
    );
  }
}
