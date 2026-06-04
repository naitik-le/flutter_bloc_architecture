import 'package:flutter_bloc_architecture/core/network/api_response.dart';
import 'package:flutter_bloc_architecture/features/auth/data/models/user_model.dart';
import 'package:flutter_bloc_architecture/features/auth/domain/repositories/auth_repository.dart';

/// Use case for authenticating a user with email and password.
///
/// Single-responsibility: delegates to [AuthRepository] and returns
/// a typed result.
class LoginUsecase {
  final AuthRepository _repository;

  /// Creates a [LoginUsecase] with the given [repository].
  LoginUsecase({required AuthRepository repository}) : _repository = repository;

  /// Executes the login operation.
  ///
  /// Returns an [ApiResponse] containing the [UserModel].
  Future<ApiResponse<UserModel>> call({
    required String email,
    required String password,
  }) {
    return _repository.login(email: email, password: password);
  }
}
