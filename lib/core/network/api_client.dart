import 'package:dio/dio.dart';
import 'package:flutter_bloc_architecture/core/config/app_config.dart';
import 'package:flutter_bloc_architecture/core/constants/api_constants.dart';
import 'package:flutter_bloc_architecture/core/network/api_response.dart';
import 'package:flutter_bloc_architecture/core/network/interceptors/auth_interceptor.dart';
import 'package:flutter_bloc_architecture/core/network/interceptors/logging_interceptor.dart';
import 'package:flutter_bloc_architecture/core/network/network_exceptions.dart';

/// Centralized HTTP client built on top of [Dio].
///
/// Configures base options, interceptors, and provides typed request methods
/// for GET, POST, PUT, PATCH, and DELETE operations.
class ApiClient {
  late final Dio _dio;

  /// Creates an [ApiClient] and configures the underlying [Dio] instance.
  ApiClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.baseUrl,
        connectTimeout:
            const Duration(milliseconds: ApiConstants.connectionTimeout),
        receiveTimeout:
            const Duration(milliseconds: ApiConstants.receiveTimeout),
        sendTimeout: const Duration(milliseconds: ApiConstants.sendTimeout),
        headers: {
          'Content-Type': ApiConstants.contentType,
          'Accept': ApiConstants.accept,
        },
      ),
    );

    // ── Add Interceptors ──
    _dio.interceptors.addAll([
      AuthInterceptor(),
      LoggingInterceptor(),
    ]);
  }

  /// The underlying [Dio] instance for advanced usage.
  Dio get dio => _dio;

  /// Performs a GET request to the given [path].
  ///
  /// Optional [queryParameters] and [options] can be provided.
  Future<ApiResponse<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
      );
      return ApiResponse.success(
        data: response.data,
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      final message = NetworkExceptions.fromDioException(e).message;
      return ApiResponse.error(
        errorMsg: message,
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      return ApiResponse.error(
        errorMsg: e.toString(),
      );
    }
  }

  /// Performs a POST request to the given [path].
  ///
  /// Optional [data], [queryParameters], and [options] can be provided.
  Future<ApiResponse<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return ApiResponse.success(
        data: response.data,
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      final message = NetworkExceptions.fromDioException(e).message;
      return ApiResponse.error(
        errorMsg: message,
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      return ApiResponse.error(
        errorMsg: e.toString(),
      );
    }
  }

  /// Performs a PUT request to the given [path].
  Future<ApiResponse<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.put<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return ApiResponse.success(
        data: response.data,
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      final message = NetworkExceptions.fromDioException(e).message;
      return ApiResponse.error(
        errorMsg: message,
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      return ApiResponse.error(
        errorMsg: e.toString(),
      );
    }
  }

  /// Performs a PATCH request to the given [path].
  Future<ApiResponse<T>> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.patch<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return ApiResponse.success(
        data: response.data,
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      final message = NetworkExceptions.fromDioException(e).message;
      return ApiResponse.error(
        errorMsg: message,
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      return ApiResponse.error(
        errorMsg: e.toString(),
      );
    }
  }

  /// Performs a DELETE request to the given [path].
  Future<ApiResponse<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.delete<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return ApiResponse.success(
        data: response.data,
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      final message = NetworkExceptions.fromDioException(e).message;
      return ApiResponse.error(
        errorMsg: message,
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      return ApiResponse.error(
        errorMsg: e.toString(),
      );
    }
  }
}
