import 'package:flutter_bloc_architecture/core/constants/api_constants.dart';
import 'package:flutter_bloc_architecture/core/errors/exceptions.dart';
import 'package:flutter_bloc_architecture/core/network/api_client.dart';
import 'package:flutter_bloc_architecture/core/network/api_status.dart';
import 'package:flutter_bloc_architecture/features/auth/data/models/login_request_model.dart';
import 'package:flutter_bloc_architecture/features/auth/data/models/user_model.dart';

/// Remote data source for authentication API calls.
///
/// Handles raw HTTP communication via [ApiClient] and throws
/// data-layer exceptions on failure.
class AuthRemoteDatasource {
  final ApiClient _apiClient;

  /// Creates an [AuthRemoteDatasource] with the given [apiClient].
  AuthRemoteDatasource({required ApiClient apiClient}) : _apiClient = apiClient;

  /// Authenticates a user with [email] and [password].
  ///
  /// Returns a [UserModel] on success.
  /// Throws [ServerException] on failure.
  Future<UserModel> login(LoginRequestModel request) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      ApiConstants.login,
      data: request.toJson(),
    );

    if (response.status == ApiStatus.error) {
      throw ServerException(
        message: response.errorMsg ?? 'Something went wrong',
      );
    }

    final data = response.data;
    if (data == null) {
      throw const ServerException(message: 'No data received');
    }

    // reqres.in returns { "token": "..." } on login
    // We'll construct a minimal user model from the response
    return UserModel(
      id: 0,
      email: request.email,
      firstName: '',
      lastName: '',
    );
  }

  /// Registers a new user with the given details.
  ///
  /// Returns a [UserModel] on success.
  /// Throws [ServerException] on failure.
  Future<UserModel> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  }) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      ApiConstants.register,
      data: {
        'email': email,
        'password': password,
      },
    );

    if (response.status == ApiStatus.error) {
      throw ServerException(
        message: response.errorMsg ?? 'Something went wrong',
      );
    }

    final data = response.data;
    if (data == null) {
      throw const ServerException(message: 'No data received');
    }

    return UserModel(
      id: data['id'] as int? ?? 0,
      email: email,
      firstName: firstName,
      lastName: lastName,
    );
  }

  /// Sends a password reset request for the given [email].
  ///
  /// Returns `true` on success.
  /// Throws [ServerException] on failure.
  Future<bool> forgotPassword(String email) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      ApiConstants.forgotPassword,
      data: {'email': email},
    );

    if (response.status == ApiStatus.error) {
      throw ServerException(
        message: response.errorMsg ?? 'Something went wrong',
      );
    }

    return true;
  }
}
