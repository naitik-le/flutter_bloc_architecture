import 'package:flutter/material.dart';
import 'package:flutter_bloc_architecture/core/constants/app_strings.dart';
import 'package:flutter_bloc_architecture/core/theme/app_colors.dart';
import 'package:flutter_bloc_architecture/core/theme/app_spacing.dart';
import 'package:flutter_bloc_architecture/core/theme/app_text_styles.dart';
import 'package:flutter_bloc_architecture/core/widgets/custom_button.dart';

/// A standardized error display widget.
///
/// Shows an error icon, message, and optional retry button.
class AppErrorWidget extends StatelessWidget {
  /// The error message to display.
  final String message;

  /// Optional retry callback. If provided, a retry button is shown.
  final VoidCallback? onRetry;

  /// Optional icon to display. If null, it is automatically resolved based on [message].
  final IconData? icon;

  /// Creates an [AppErrorWidget].
  const AppErrorWidget({
    super.key,
    this.message = AppStrings.somethingWentWrong,
    this.onRetry,
    this.icon,
  });

  IconData _selectIcon() {
    if (icon != null) return icon!;

    final lowerMessage = message.toLowerCase();
    if (lowerMessage.contains('time')) {
      return Icons.hourglass_empty_rounded;
    } else if (lowerMessage.contains('internet') ||
        lowerMessage.contains('connection')) {
      return Icons.wifi_off_rounded;
    }
    return Icons.error_outline_rounded;
  }

  @override
  Widget build(BuildContext context) {
    final displayIcon = _selectIcon();
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              displayIcon,
              size: 64,
              color: AppColors.error,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              message,
              style: AppTextStyles.bodyLarge.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: AppSpacing.xl),
              CustomButton(
                text: AppStrings.retry,
                onPressed: onRetry,
                width: 160,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
