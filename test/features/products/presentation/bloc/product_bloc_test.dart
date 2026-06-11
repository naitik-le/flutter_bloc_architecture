import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc_architecture/core/network/api_response.dart';
import 'package:flutter_bloc_architecture/features/products/data/models/product_model.dart';
import 'package:flutter_bloc_architecture/features/products/domain/repositories/product_repository.dart';
import 'package:flutter_bloc_architecture/features/products/presentation/bloc/product_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';

// Stub class for ProductRepository
class FakeProductRepository extends ProductRepository {
  ApiResponse<List<ProductModel>> productsResponse =
      ApiResponse.success(data: const []);

  @override
  Future<ApiResponse<List<ProductModel>>> getProducts() async {
    return productsResponse;
  }
}

void main() {
  late FakeProductRepository fakeRepository;

  setUp(() async {
    fakeRepository = FakeProductRepository();
    await GetIt.I.reset();
    GetIt.I.registerLazySingleton<ProductRepository>(() => fakeRepository);
  });

  tearDown(() async {
    await GetIt.I.reset();
  });

  group('ProductBloc State Transitions', () {
    test('initial state has default flags', () {
      final bloc = ProductBloc();
      expect(bloc.state.isLoading, isFalse);
      expect(bloc.state.isFailed, isFalse);
      expect(bloc.state.products, isEmpty);
      bloc.close();
    });

    blocTest<ProductBloc, ProductState>(
      'FetchProductsEvent emits loading and success states',
      build: () {
        fakeRepository.productsResponse = ApiResponse.success(data: [
          const ProductModel(
            id: 1,
            title: 'Test Product',
            description: 'This is a test product',
            price: 19.99,
            rating: 4.5,
            brand: 'Test Brand',
            category: 'test',
            thumbnail: 'https://test.com/thumbnail.png',
            images: [],
          ),
        ],);
        return ProductBloc();
      },
      act: (bloc) => bloc.add(const FetchProductsEvent()),
      expect: () => [
        const ProductState(
          isLoading: true,
          isFailed: false,
          errorMsg: null,
        ),
        isA<ProductState>()
            .having((s) => s.isLoading, 'isLoading', isFalse)
            .having((s) => s.isFailed, 'isFailed', isFalse)
            .having((s) => s.products.length, 'products.length', 1),
      ],
    );

    blocTest<ProductBloc, ProductState>(
      'FetchProductsEvent emits loading and failure states',
      build: () {
        fakeRepository.productsResponse =
            ApiResponse.error(errorMsg: 'Connection timed out');
        return ProductBloc();
      },
      act: (bloc) => bloc.add(const FetchProductsEvent()),
      expect: () => [
        const ProductState(
          isLoading: true,
          isFailed: false,
          errorMsg: null,
        ),
        const ProductState(
          isLoading: false,
          isFailed: true,
          errorMsg: 'Connection timed out',
          products: [],
        ),
      ],
    );
  });
}
