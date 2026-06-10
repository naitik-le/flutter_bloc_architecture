import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import 'package:flutter_bloc_architecture/core/network/api_status.dart';
import 'package:flutter_bloc_architecture/features/products/data/models/product_model.dart';
import 'package:flutter_bloc_architecture/features/products/domain/repositories/product_repository.dart';

part 'product_event.dart';

part 'product_state.dart';

/// BLoC for handling Products state transitions and fetching logic.
class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final _repository = GetIt.I<ProductRepository>();

  /// Creates a [ProductBloc].
  ProductBloc() : super(const ProductState()) {
    on<FetchProductsEvent>(_onFetchProducts);
  }

  Future<void> _onFetchProducts(
    FetchProductsEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, isFailed: false, errorMsg: null));

    final response = await _repository.getProducts();

    if (response.status == ApiStatus.error) {
      emit(
        state.copyWith(
          isLoading: false,
          isFailed: true,
          errorMsg: response.errorMsg ?? 'Failed to fetch products',
        ),
      );
    } else {
      emit(
        state.copyWith(
          isLoading: false,
          isFailed: false,
          products: response.data ?? [],
        ),
      );
    }
  }
}
