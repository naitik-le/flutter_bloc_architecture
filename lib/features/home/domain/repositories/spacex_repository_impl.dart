import 'package:dio/dio.dart';

import 'package:flutter_bloc_architecture/core/constants/api_constants.dart';
import 'package:flutter_bloc_architecture/core/network/api_response.dart';
import 'package:flutter_bloc_architecture/features/home/data/models/launch_model.dart';
import 'package:flutter_bloc_architecture/features/home/data/models/rocket_model.dart';
import 'package:flutter_bloc_architecture/features/home/domain/repositories/spacex_repository.dart';

/// Concrete implementation of [SpacexRepository].
///
/// Uses a dedicated [Dio] instance targeting the SpaceX API base URL.
/// No authentication is required for these endpoints.
class SpacexRepositoryImpl extends SpacexRepository {
  final Dio _dio;

  /// Creates a [SpacexRepositoryImpl] with a pre-configured [Dio] instance.
  SpacexRepositoryImpl()
      : _dio = Dio(
          BaseOptions(
            baseUrl: ApiConstants.spacexBaseUrl,
            connectTimeout: const Duration(
              milliseconds: ApiConstants.connectionTimeout,
            ),
            receiveTimeout: const Duration(
              milliseconds: ApiConstants.receiveTimeout,
            ),
            headers: {
              'Content-Type': ApiConstants.contentType,
              'Accept': ApiConstants.accept,
            },
          ),
        );

  @override
  Future<ApiResponse<List<RocketModel>>> getRockets() async {
    try {
      final response = await _dio.get(ApiConstants.spacexRockets);
      final data = response.data as List<dynamic>? ?? [];
      final rockets = data
          .map((e) => RocketModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return ApiResponse.success(data: rockets);
    } on DioException catch (error) {
      return ApiResponse.error(
        errorMsg: error.message ?? 'Failed to fetch rockets',
      );
    }
  }

  @override
  Future<ApiResponse<List<LaunchModel>>> getLaunches() async {
    try {
      final response = await _dio.get(ApiConstants.spacexLaunches);
      final data = response.data as List<dynamic>? ?? [];
      final launches = data
          .map((e) => LaunchModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return ApiResponse.success(data: launches);
    } on DioException catch (error) {
      return ApiResponse.error(
        errorMsg: error.message ?? 'Failed to fetch launches',
      );
    }
  }
}
