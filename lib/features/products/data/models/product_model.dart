import 'dart:convert';
import 'package:equatable/equatable.dart';

/// Data model representing a product from the DummyJSON API.
class ProductModel extends Equatable {
  final int id;
  final String title;
  final String description;
  final double price;
  final double rating;
  final String? brand;
  final String category;
  final String thumbnail;
  final List<String> images;

  const ProductModel({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.rating,
    required this.brand,
    required this.category,
    required this.thumbnail,
    required this.images,
  });

  /// Factory constructor to parse ProductModel from JSON.
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    final imagesList = json['images'] as List<dynamic>? ?? [];
    return ProductModel(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      brand: json['brand'] as String?,
      category: json['category'] as String? ?? '',
      thumbnail: json['thumbnail'] as String? ?? '',
      images: imagesList.map((e) => e.toString()).toList(),
    );
  }

  /// Parses a raw JSON string into a list of [ProductModel]s.
  /// Designed to be executed in a background isolate using `compute`.
  static List<ProductModel> parseProductsFromJson(String jsonString) {
    final decoded = jsonDecode(jsonString) as Map<String, dynamic>;
    final productsList = decoded['products'] as List<dynamic>? ?? [];
    return productsList.map((e) => ProductModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  List<Object?> get props => [id, title, description, price, rating, brand, category, thumbnail, images];
}
