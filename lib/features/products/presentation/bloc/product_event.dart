part of 'product_bloc.dart';

/// Base event class for Products.
abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object?> get props => [];
}

/// Event to fetch product list.
class FetchProductsEvent extends ProductEvent {
  const FetchProductsEvent();
}
