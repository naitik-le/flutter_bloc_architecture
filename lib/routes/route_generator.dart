import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_architecture/core/di/injection.dart';
import 'package:flutter_bloc_architecture/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_bloc_architecture/features/auth/presentation/screens/login_screen.dart';
import 'package:flutter_bloc_architecture/features/auth/presentation/screens/register_screen.dart';
import 'package:flutter_bloc_architecture/features/auth/presentation/screens/splash_screen.dart';
import 'package:flutter_bloc_architecture/features/chat/presentation/screens/chat_screen.dart';
import 'package:flutter_bloc_architecture/features/home/data/models/launch_model.dart';
import 'package:flutter_bloc_architecture/features/home/data/models/rocket_model.dart';
import 'package:flutter_bloc_architecture/features/home/presentation/bloc/carousel_cubit.dart';
import 'package:flutter_bloc_architecture/features/home/presentation/bloc/dashboard_cubit.dart';
import 'package:flutter_bloc_architecture/features/home/presentation/bloc/spacex_bloc.dart';
import 'package:flutter_bloc_architecture/features/home/presentation/screens/dashboard_screen.dart';
import 'package:flutter_bloc_architecture/features/home/presentation/screens/launch_detail_screen.dart';
import 'package:flutter_bloc_architecture/features/home/presentation/screens/rocket_detail_screen.dart';
import 'package:flutter_bloc_architecture/features/profile/presentation/screens/profile_screen.dart';
import 'package:flutter_bloc_architecture/features/settings/presentation/screens/settings_screen.dart';
import 'package:flutter_bloc_architecture/routes/app_routes.dart';

/// Centralized route generator that hooks named routes to pages with animations.
///
/// Maps [RouteSettings.name] to the corresponding screen widget and
/// provides custom slide transitions for all navigation.
class RouteGenerator {
  RouteGenerator._();

  /// Router entry point mapping a [RouteSettings] to a specific [Route].
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.splash:
        return _buildRoute(
          BlocProvider(
            create: (_) => getIt<AuthBloc>(),
            child: const SplashScreen(),
          ),
          settings,
        );

      case Routes.login:
        return _buildRoute(
          BlocProvider(
            create: (_) => getIt<AuthBloc>(),
            child: const LoginScreen(),
          ),
          settings,
        );

      case Routes.register:
        return _buildRoute(
          BlocProvider(
            create: (_) => getIt<AuthBloc>(),
            child: const RegisterScreen(),
          ),
          settings,
        );

      case Routes.dashboard:
        return _buildRoute(
          MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => getIt<DashboardCubit>()),
              BlocProvider(create: (_) => getIt<SpacexBloc>()),
              BlocProvider(create: (_) => getIt<AuthBloc>()),
            ],
            child: const DashboardScreen(),
          ),
          settings,
        );

      case Routes.rocketDetail:
        final rocket = settings.arguments! as RocketModel;
        return _buildRoute(
          MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => getIt<CarouselCubit>()),
            ],
            child: RocketDetailScreen(rocket: rocket),
          ),
          settings,
        );

      case Routes.launchDetail:
        final launch = settings.arguments! as LaunchModel;
        return _buildRoute(
          LaunchDetailScreen(launch: launch),
          settings,
        );

      case Routes.profile:
        return _buildRoute(const ProfileScreen(), settings);

      case Routes.chat:
        return _buildRoute(const ChatScreen(), settings);

      case Routes.settings:
        return _buildRoute(const SettingsScreen(), settings);

      default:
        return _buildRoute(
          Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
          settings,
        );
    }
  }

  /// Builds custom slide transitioning routes.
  static PageRouteBuilder<dynamic> _buildRoute(Widget page, RouteSettings settings) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        final tween = Tween(begin: begin, end: end).chain(
          CurveTween(curve: Curves.fastOutSlowIn),
        );
        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }
}
