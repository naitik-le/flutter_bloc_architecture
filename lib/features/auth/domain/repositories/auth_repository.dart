import 'package:flutter_bloc_architecture/core/network/api_response.dart';
import 'package:flutter_bloc_architecture/features/auth/data/models/user_model.dart';

/// Abstract repository interface for authentication operations.
///
/// Defines the contract for the authentication repository.
abstract class AuthRepository {
  /// Authenticates a user with [email] and [password].
  Future<ApiResponse<UserModel>> login({
    required String email,
    required String password,
  });

  /// Registers a new user with [email] and [password].
  Future<ApiResponse<UserModel>> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  });

  /// Sends a password reset email to the given [email].
  Future<ApiResponse> forgotPassword({
    required String email,
  });

  /// Logs out the current user.
  Future<void> logout();

  /// Checks if the user is currently logged in.
  Future<bool> isLoggedIn();
}
