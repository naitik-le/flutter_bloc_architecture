import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_architecture/core/constants/app_strings.dart';
import 'package:flutter_bloc_architecture/core/extensions/context_extensions.dart';
import 'package:flutter_bloc_architecture/core/theme/app_colors.dart';
import 'package:flutter_bloc_architecture/core/theme/app_spacing.dart';
import 'package:flutter_bloc_architecture/core/theme/app_text_styles.dart';
import 'package:flutter_bloc_architecture/core/utils/validators.dart';
import 'package:flutter_bloc_architecture/core/widgets/custom_button.dart';
import 'package:flutter_bloc_architecture/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_bloc_architecture/features/auth/presentation/widgets/auth_form_field.dart';
import 'package:flutter_bloc_architecture/routes/app_routes.dart';

/// Login screen with form validation and BLoC state management.
///
/// Listens to [AuthBloc] for navigation and errors, and reads state dynamically.
class LoginScreen extends StatefulWidget {
  /// Creates a [LoginScreen].
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.select<AuthBloc, bool>(
      (bloc) => bloc.state.isLoading,
    );

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: BlocListener<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state.isCompleted) {
                  context.pushNamedAndRemoveAll(Routes.dashboard);
                } else if (state.isFailed) {
                  context.showSnackBar(state.errorMsg ?? '',
                      type: SnackBarType.error,);
                }
              },
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // ── Header ──
                    const Icon(
                      Icons.lock_outline_rounded,
                      size: 64,
                      color: AppColors.primary,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      AppStrings.login,
                      style: AppTextStyles.displayMedium.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'Welcome back! Please sign in to continue.',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.xxxl),

                    // ── Email Field ──
                    AuthFormField(
                      controller: _emailController,
                      label: AppStrings.email,
                      hintText: 'Enter your email',
                      prefixIcon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      validator: Validators.email,
                      enabled: !isLoading,
                    ),
                    const SizedBox(height: AppSpacing.md),

                    // ── Password Field ──
                    AuthFormField(
                      controller: _passwordController,
                      label: AppStrings.password,
                      hintText: 'Enter your password',
                      prefixIcon: Icons.lock_outline,
                      isPassword: true,
                      textInputAction: TextInputAction.done,
                      validator: Validators.password,
                      enabled: !isLoading,
                    ),
                    const SizedBox(height: AppSpacing.xs),

                    // ── Forgot Password ──
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: isLoading ? null : () {},
                        child: Text(
                          AppStrings.forgotPassword,
                          style: AppTextStyles.labelMedium.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    // ── Login Button ──
                    CustomButton(
                      text: AppStrings.loginButton,
                      isLoading: isLoading,
                      onPressed: isLoading ? null : () => _onLogin(context),
                    ),
                    const SizedBox(height: AppSpacing.xl),

                    // ── Register Link ──
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          AppStrings.noAccount,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                        GestureDetector(
                          onTap: isLoading
                              ? null
                              : () {
                                  context.pushNamed(Routes.register);
                                },
                          child: Text(
                            AppStrings.register,
                            style: AppTextStyles.labelLarge.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onLogin(BuildContext context) {
    if (_formKey.currentState?.validate() ?? false) {
      context.unfocus();
      context.read<AuthBloc>().add(
            PerformLoginEvent(
              email: _emailController.text.trim(),
              password: _passwordController.text.trim(),
            ),
          );
    }
  }
}
