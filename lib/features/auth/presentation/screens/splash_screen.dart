import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_architecture/core/constants/app_strings.dart';
import 'package:flutter_bloc_architecture/core/theme/app_colors.dart';
import 'package:flutter_bloc_architecture/core/theme/app_spacing.dart';
import 'package:flutter_bloc_architecture/core/theme/app_text_styles.dart';
import 'package:flutter_bloc_architecture/core/widgets/loading_indicator.dart';
import 'package:flutter_bloc_architecture/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_bloc_architecture/routes/app_routes.dart';

/// Splash screen that determines the entry point based on authentication status.
///
/// Dispatches a check event on initialization and navigates accordingly.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    _controller.forward();

    // Trigger auth status check.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthBloc>().add(const CheckAuthStatusEvent());
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          final navigator = Navigator.of(context);
          Future.delayed(const Duration(milliseconds: 1500), () {
            if (!mounted) return;
            if (state.isCompleted) {
              navigator.pushNamedAndRemoveUntil(
                Routes.dashboard,
                (route) => false,
              );
            } else if (state.isLoggedOut || state.isFailed) {
              navigator.pushNamedAndRemoveUntil(
                Routes.login,
                (route) => false,
              );
            }
          });
        },
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // ── Animated Brand Icon ──
                Container(
                  padding: const EdgeInsets.all(AppSpacing.xl),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.security_rounded,
                    size: 80,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),

                // ── App Name ──
                Text(
                  AppStrings.appName,
                  style: AppTextStyles.displayMedium.copyWith(
                    color: theme.colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.sm),

                // ── Subtitle ──
                Text(
                  'Clean Architecture • BLoC',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    letterSpacing: 1.2,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.xxxl),

                // ── Progress indicator ──
                const LoadingIndicator(size: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
