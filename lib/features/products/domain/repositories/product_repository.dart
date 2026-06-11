import 'package:flutter_bloc_architecture/core/network/api_response.dart';
import 'package:flutter_bloc_architecture/features/products/data/models/product_model.dart';

/// Abstract repository defining endpoints for the Products feature.
abstract class ProductRepository {
  /// Fetches a list of products.
  Future<ApiResponse<List<ProductModel>>> getProducts();
}
