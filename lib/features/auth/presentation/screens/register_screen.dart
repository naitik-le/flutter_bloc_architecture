import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_architecture/core/constants/app_strings.dart';
import 'package:flutter_bloc_architecture/core/extensions/context_extensions.dart';
import 'package:flutter_bloc_architecture/core/theme/app_colors.dart';
import 'package:flutter_bloc_architecture/core/theme/app_spacing.dart';
import 'package:flutter_bloc_architecture/core/theme/app_text_styles.dart';
import 'package:flutter_bloc_architecture/core/utils/validators.dart';
import 'package:flutter_bloc_architecture/core/widgets/custom_button.dart';
import 'package:flutter_bloc_architecture/core/widgets/custom_app_bar.dart';
import 'package:flutter_bloc_architecture/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_bloc_architecture/features/auth/presentation/widgets/auth_form_field.dart';
import 'package:flutter_bloc_architecture/routes/app_routes.dart';

/// Register screen with form validation and BLoC state management.
///
/// Listens to [AuthBloc] for navigation and errors, and reads state dynamically.
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.select<AuthBloc, bool>(
      (bloc) => bloc.state.isLoading,
    );

    return Scaffold(
      appBar: CustomAppBar(
        backgroundColor: AppColors.transparent,
        onBackPressed: isLoading ? () {} : null,
      ),
      body: SafeArea(
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
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ── Header ──
                  Text(
                    AppStrings.register,
                    style: AppTextStyles.displayMedium.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'Create your account to get started.',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxl),

                  // ── First Name ──
                  AuthFormField(
                    controller: _firstNameController,
                    label: 'First Name',
                    hintText: 'Enter your first name',
                    prefixIcon: Icons.person_outline,
                    textInputAction: TextInputAction.next,
                    validator: Validators.name,
                    enabled: !isLoading,
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // ── Last Name ──
                  AuthFormField(
                    controller: _lastNameController,
                    label: 'Last Name',
                    hintText: 'Enter your last name',
                    prefixIcon: Icons.person_outline,
                    textInputAction: TextInputAction.next,
                    validator: Validators.name,
                    enabled: !isLoading,
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // ── Email ──
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

                  // ── Password ──
                  AuthFormField(
                    controller: _passwordController,
                    label: AppStrings.password,
                    hintText: 'Create a password',
                    prefixIcon: Icons.lock_outline,
                    isPassword: true,
                    textInputAction: TextInputAction.next,
                    validator: Validators.password,
                    enabled: !isLoading,
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // ── Confirm Password ──
                  AuthFormField(
                    controller: _confirmPasswordController,
                    label: AppStrings.confirmPassword,
                    hintText: 'Confirm your password',
                    prefixIcon: Icons.lock_outline,
                    isPassword: true,
                    textInputAction: TextInputAction.done,
                    validator: (value) => Validators.confirmPassword(
                      value,
                      _passwordController.text,
                    ),
                    enabled: !isLoading,
                  ),
                  const SizedBox(height: AppSpacing.xl),

                  // ── Register Button ──
                  CustomButton(
                    text: AppStrings.registerButton,
                    isLoading: isLoading,
                    onPressed: isLoading ? null : () => _onRegister(context),
                  ),
                  const SizedBox(height: AppSpacing.xl),

                  // ── Login Link ──
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        AppStrings.haveAccount,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                      GestureDetector(
                        onTap: isLoading ? null : () => context.pop(),
                        child: Text(
                          AppStrings.login,
                          style: AppTextStyles.labelLarge.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xl),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onRegister(BuildContext context) {
    if (_formKey.currentState?.validate() ?? false) {
      context.unfocus();
      context.read<AuthBloc>().add(
            PerformRegisterEvent(
              email: _emailController.text.trim(),
              password: _passwordController.text.trim(),
              firstName: _firstNameController.text.trim(),
              lastName: _lastNameController.text.trim(),
            ),
          );
    }
  }
}
