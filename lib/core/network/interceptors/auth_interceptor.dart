import 'package:dio/dio.dart';
import 'package:flutter_bloc_architecture/core/config/app_config.dart';
import 'package:flutter_bloc_architecture/core/constants/storage_constants.dart';
import 'package:flutter_bloc_architecture/core/di/injection.dart';
import 'package:flutter_bloc_architecture/core/storage/local_storage_service.dart';
import 'package:flutter_bloc_architecture/core/utils/app_logger.dart';

/// Dio interceptor that injects the authentication token into request headers.
///
/// Automatically retrieves the stored auth token from [LocalStorageService]
/// and appends it as a Bearer token to every outgoing request.
class AuthInterceptor extends Interceptor {
  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      final localStorage = getIt<LocalStorageService>();
      final token = localStorage.getString(StorageConstants.token);

      options.headers['x-api-key'] = AppConfig.apiKey;
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    } catch (e) {
      AppLogger.warning('AuthInterceptor: Failed to inject token: $e');
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      AppLogger.warning('AuthInterceptor: Received 401 — token may be expired');
      // TODO: Implement token refresh logic here.
    }

    handler.next(err);
  }
}
