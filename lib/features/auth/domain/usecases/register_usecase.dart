import 'package:flutter_bloc_architecture/core/network/api_response.dart';
import 'package:flutter_bloc_architecture/features/auth/data/models/user_model.dart';
import 'package:flutter_bloc_architecture/features/auth/domain/repositories/auth_repository.dart';

/// Use case for registering a new user.
///
/// Single-responsibility: delegates to [AuthRepository] and returns
/// a typed result.
class RegisterUsecase {
  final AuthRepository _repository;

  /// Creates a [RegisterUsecase] with the given [repository].
  RegisterUsecase({required AuthRepository repository})
      : _repository = repository;

  /// Executes the registration operation.
  ///
  /// Returns an [ApiResponse] containing the [UserModel].
  Future<ApiResponse<UserModel>> call({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  }) {
    return _repository.register(
      email: email,
      password: password,
      firstName: firstName,
      lastName: lastName,
    );
  }
}
