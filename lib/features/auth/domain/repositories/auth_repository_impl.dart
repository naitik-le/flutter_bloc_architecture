import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';

import 'package:flutter_bloc_architecture/core/constants/api_constants.dart';
import 'package:flutter_bloc_architecture/core/constants/storage_constants.dart';
import 'package:flutter_bloc_architecture/core/network/api_response.dart';
import 'package:flutter_bloc_architecture/core/storage/local_storage_service.dart';
import 'package:flutter_bloc_architecture/features/auth/data/models/user_model.dart';
import 'package:flutter_bloc_architecture/features/auth/domain/repositories/auth_repository.dart';

/// Concrete implementation of [AuthRepository].
///
/// Calls the endpoints directly via [Dio] obtained from [GetIt] and returns
/// [ApiResponse] wrappers.
class AuthRepositoryImpl extends AuthRepository {
  /// Creates an [AuthRepositoryImpl].
  AuthRepositoryImpl();

  @override
  Future<ApiResponse<UserModel>> login({
    required String email,
    required String password,
  }) async {
    final dio = GetIt.I<Dio>();
    try {
      final response = await dio.post(
        ApiConstants.login,
        data: {'email': email, 'password': password},
      );

      final data = response.data as Map<String, dynamic>? ?? {};
      final token = data['token'] as String?;
      if (token != null) {
        final localStorage = GetIt.I<LocalStorageService>();
        await localStorage.setString(StorageConstants.token, token);
        await localStorage.setBool(StorageConstants.isLoggedIn, value: true);
      }

      // Construct a UserModel representing the logged in user
      final user = UserModel(
        id: 0,
        email: email,
        firstName: '',
        lastName: '',
      );
      return ApiResponse.success(data: user);
    } on DioException catch (error) {
      final response = error.response;
      return ApiResponse.error(
        errorMsg: response == null
            ? 'Something went wrong'
            : (response.data is Map
                ? response.data['error'] ?? response.data['message']
                : 'Something went wrong'),
      );
    }
  }

  @override
  Future<ApiResponse<UserModel>> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  }) async {
    final dio = GetIt.I<Dio>();
    try {
      final response = await dio.post(
        ApiConstants.register,
        data: {'email': email, 'password': password},
      );
      final data = response.data as Map<String, dynamic>? ?? {};
      final token = data['token'] as String?;
      if (token != null) {
        final localStorage = GetIt.I<LocalStorageService>();
        await localStorage.setString(StorageConstants.token, token);
        await localStorage.setBool(StorageConstants.isLoggedIn, value: true);
      }

      final user = UserModel(
        id: data['id'] as int? ?? 0,
        email: email,
        firstName: firstName,
        lastName: lastName,
      );
      return ApiResponse.success(data: user);
    } on DioException catch (error) {
      final response = error.response;
      return ApiResponse.error(
        errorMsg: response == null
            ? 'Something went wrong'
            : (response.data is Map
                ? response.data['error'] ?? response.data['message']
                : 'Something went wrong'),
      );
    }
  }

  @override
  Future<ApiResponse> forgotPassword({
    required String email,
  }) async {
    final dio = GetIt.I<Dio>();
    try {
      final response = await dio.post(
        ApiConstants.forgotPassword,
        data: {'email': email},
      );
      return ApiResponse.success(data: response.data);
    } on DioException catch (error) {
      final response = error.response;
      return ApiResponse.error(
        errorMsg: response == null
            ? 'Something went wrong'
            : (response.data is Map
                ? response.data['error'] ?? response.data['message']
                : 'Something went wrong'),
      );
    }
  }

  @override
  Future<void> logout() async {
    final localStorage = GetIt.I<LocalStorageService>();
    await localStorage.remove(StorageConstants.token);
    await localStorage.setBool(StorageConstants.isLoggedIn, value: false);
    debugPrint('User logged out');
  }

  @override
  Future<bool> isLoggedIn() async {
    final localStorage = GetIt.I<LocalStorageService>();
    return localStorage.getBool(StorageConstants.isLoggedIn) ?? false;
  }
}
