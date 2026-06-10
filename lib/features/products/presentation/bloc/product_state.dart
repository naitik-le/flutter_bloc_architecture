part of 'product_bloc.dart';

/// State for the [ProductBloc].
class ProductState extends Equatable {
  final bool isLoading;
  final bool isFailed;
  final String? errorMsg;
  final List<ProductModel> products;

  const ProductState({
    this.isLoading = false,
    this.isFailed = false,
    this.errorMsg,
    this.products = const [],
  });

  ProductState copyWith({
    bool? isLoading,
    bool? isFailed,
    String? errorMsg,
    List<ProductModel>? products,
  }) {
    return ProductState(
      isLoading: isLoading ?? this.isLoading,
      isFailed: isFailed ?? this.isFailed,
      errorMsg: errorMsg ?? this.errorMsg,
      products: products ?? this.products,
    );
  }

  @override
  List<Object?> get props => [isLoading, isFailed, errorMsg, products];
}
