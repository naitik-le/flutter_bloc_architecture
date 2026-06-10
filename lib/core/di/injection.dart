import 'package:flutter_bloc_architecture/core/theme/theme_cubit.dart';
import 'package:flutter_bloc_architecture/features/home/presentation/bloc/carousel_cubit.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_bloc_architecture/core/network/api_client.dart';
import 'package:flutter_bloc_architecture/core/services/navigation_service.dart';
import 'package:flutter_bloc_architecture/core/services/notification_service.dart';
import 'package:flutter_bloc_architecture/core/storage/local_storage_service.dart';
import 'package:flutter_bloc_architecture/core/storage/secure_storage_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc_architecture/core/utils/app_logger.dart';
import 'package:flutter_bloc_architecture/features/auth/domain/repositories/auth_repository_impl.dart';
import 'package:flutter_bloc_architecture/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_bloc_architecture/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_bloc_architecture/features/home/presentation/bloc/dashboard_cubit.dart';
import 'package:flutter_bloc_architecture/features/home/domain/repositories/spacex_repository.dart';
import 'package:flutter_bloc_architecture/features/home/domain/repositories/spacex_repository_impl.dart';
import 'package:flutter_bloc_architecture/features/home/presentation/bloc/spacex_bloc.dart';
import 'package:flutter_bloc_architecture/features/profile/data/datasource/profile_local_data_source.dart';
import 'package:flutter_bloc_architecture/features/profile/domain/repositories/profile_repository.dart';
import 'package:flutter_bloc_architecture/features/profile/data/repository_impl/profile_repository_impl.dart';
import 'package:flutter_bloc_architecture/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:flutter_bloc_architecture/features/crypto/domain/repositories/crypto_repository.dart';
import 'package:flutter_bloc_architecture/features/crypto/domain/repositories/crypto_repository_impl.dart';
import 'package:flutter_bloc_architecture/features/crypto/presentation/bloc/crypto_bloc.dart';
import 'package:flutter_bloc_architecture/features/products/domain/repositories/product_repository.dart';
import 'package:flutter_bloc_architecture/features/products/domain/repositories/product_repository_impl.dart';
import 'package:flutter_bloc_architecture/features/products/presentation/bloc/product_bloc.dart';

/// Global service locator instance.
final GetIt getIt = GetIt.instance;

/// Registers all dependencies with the service locator.
///
/// Call this at app startup before `runApp()`.
/// Dependencies are organized by layer: core → data → domain → presentation.
Future<void> setupDependencies() async {
  AppLogger.info('🔧 Setting up dependencies...');

  // ── External Dependencies ──
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(sharedPreferences);

  const secureStorage = FlutterSecureStorage();
  getIt.registerSingleton<FlutterSecureStorage>(secureStorage);

  final localNotifications = FlutterLocalNotificationsPlugin();
  getIt.registerSingleton<FlutterLocalNotificationsPlugin>(localNotifications);

  // ── Core Services ──
  getIt.registerLazySingleton<LocalStorageService>(
    () => LocalStorageService(getIt<SharedPreferences>()),
  );

  getIt.registerLazySingleton<SecureStorageService>(
    () => SecureStorageService(getIt<FlutterSecureStorage>()),
  );

  getIt.registerLazySingleton<NavigationService>(
    () => NavigationService(),
  );

  getIt.registerLazySingleton<NotificationService>(
    () => NotificationService(getIt<FlutterLocalNotificationsPlugin>()),
  );

  getIt.registerLazySingleton<ApiClient>(() => ApiClient());

  // Register Dio for direct consumption in repositories
  getIt.registerLazySingleton<Dio>(() => getIt<ApiClient>().dio);

  // ── Auth Feature ──
  // Repositories
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(),
  );

  // ── Profile Feature ──
  // Data Sources
  getIt.registerLazySingleton<ProfileLocalDataSource>(
    () => ProfileLocalDataSource(getIt<LocalStorageService>()),
  );
  // Repositories
  getIt.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(getIt<ProfileLocalDataSource>()),
  );

  // ── Home Feature (SpaceX) ──
  // Repositories
  getIt.registerLazySingleton<SpacexRepository>(() => SpacexRepositoryImpl());

  // BLoCs / Cubits
  getIt.registerLazySingleton<ThemeCubit>(() => ThemeCubit());
  getIt.registerFactory<AuthBloc>(() => AuthBloc());
  getIt.registerFactory<DashboardCubit>(() => DashboardCubit());
  getIt.registerFactory<SpacexBloc>(() => SpacexBloc());
  getIt.registerFactory<CarouselCubit>(() => CarouselCubit());
  getIt.registerFactory<ProfileBloc>(() => ProfileBloc());

  // ── Crypto Feature ──
  // Repositories
  getIt.registerLazySingleton<CryptoRepository>(
    () => CryptoRepositoryImpl(),
  );

  // BLoCs
  getIt.registerFactory<CryptoBloc>(
    () => CryptoBloc(getIt<CryptoRepository>()),
  );

  // ── Products Feature ──
  getIt.registerLazySingleton<ProductRepository>(() => ProductRepositoryImpl());
  getIt.registerFactory<ProductBloc>(() => ProductBloc());

  AppLogger.info('✅ Dependencies setup complete');
}
