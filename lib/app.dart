import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_architecture/core/constants/app_strings.dart';
import 'package:flutter_bloc_architecture/core/di/injection.dart';
import 'package:flutter_bloc_architecture/core/services/navigation_service.dart';
import 'package:flutter_bloc_architecture/core/theme/app_theme.dart';
import 'package:flutter_bloc_architecture/core/theme/theme_cubit.dart';
import 'package:flutter_bloc_architecture/routes/app_routes.dart';
import 'package:flutter_bloc_architecture/routes/route_generator.dart';

/// Root application widget.
///
/// Configures:
/// - MaterialApp with theme, routes, and localizations.
/// - Navigation service integration.
/// - Light and dark theme support.
class App extends StatelessWidget {
  /// Creates the root [App] widget.
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ThemeCubit>(),
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp(
            navigatorKey: getIt<NavigationService>().navigatorKey,
            title: AppStrings.appName,
            debugShowCheckedModeBanner: false,

            // ── Theme Config ──
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeMode,

            // ── Routes Config ──
            initialRoute: Routes.splash,
            onGenerateRoute: RouteGenerator.generateRoute,
          );
        },
      ),
    );
  }
}
