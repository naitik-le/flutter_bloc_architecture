import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc_architecture/core/constants/api_constants.dart';
import 'package:flutter_bloc_architecture/core/network/api_response.dart';
import 'package:flutter_bloc_architecture/core/network/network_exceptions.dart';
import 'package:flutter_bloc_architecture/features/products/data/models/product_model.dart';
import 'package:flutter_bloc_architecture/features/products/domain/repositories/product_repository.dart';

/// Concrete implementation of [ProductRepository] using [Dio].
class ProductRepositoryImpl extends ProductRepository {
  final Dio _dio;

  /// Creates a [ProductRepositoryImpl] with a dedicated [Dio] instance targeting DummyJSON.
  ProductRepositoryImpl()
      : _dio = Dio(
          BaseOptions(
            baseUrl: 'https://dummyjson.com',
            connectTimeout: const Duration(milliseconds: ApiConstants.connectionTimeout),
            receiveTimeout: const Duration(milliseconds: ApiConstants.receiveTimeout),
          ),
        );

  @override
  Future<ApiResponse<List<ProductModel>>> getProducts() async {
    final stopwatch = Stopwatch()..start();
    try {
      if (kDebugMode) {
        print('[ProductRepository] Fetching products from DummyJSON...');
      }
      final networkStopwatch = Stopwatch()..start();
      final response = await _dio.get<String>(
        '/products?limit=194',
        options: Options(responseType: ResponseType.plain),
      );
      networkStopwatch.stop();

      final rawJson = response.data;
      if (kDebugMode) {
        print('[ProductRepository] API Response: $rawJson');
        print('[ProductRepository] Network request took: ${networkStopwatch.elapsedMilliseconds}ms');
      }

      if (rawJson == null || rawJson.isEmpty) {
        stopwatch.stop();
        return ApiResponse.success(data: const []);
      }

      final parseStopwatch = Stopwatch()..start();
      // Decode and parse large product JSON response in a background isolate
      final products = await compute(ProductModel.parseProductsFromJson, rawJson);
      parseStopwatch.stop();

      stopwatch.stop();
      if (kDebugMode) {
        print('[ProductRepository] Background parsing took: ${parseStopwatch.elapsedMilliseconds}ms');
        print('[ProductRepository] Total getProducts duration: ${stopwatch.elapsedMilliseconds}ms');
        print('[ProductRepository] Parsed ${products.length} products successfully.');
      }
      return ApiResponse.success(data: products);
    } on DioException catch (error) {
      stopwatch.stop();
      final message = NetworkExceptions.fromDioException(error).message;
      if (kDebugMode) {
        print('[ProductRepository] Failed to fetch products (DioException): $message (took ${stopwatch.elapsedMilliseconds}ms)');
      }
      return ApiResponse.error(errorMsg: message);
    } catch (error) {
      stopwatch.stop();
      if (kDebugMode) {
        print('[ProductRepository] Failed to fetch products (Unexpected): $error (took ${stopwatch.elapsedMilliseconds}ms)');
      }
      return ApiResponse.error(errorMsg: 'An unexpected error occurred: $error');
    }
  }
}
