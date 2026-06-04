import 'package:flutter/material.dart';
import 'package:flutter_bloc_architecture/core/theme/app_animations.dart';
import 'package:flutter_bloc_architecture/core/theme/app_colors.dart';
import 'package:flutter_bloc_architecture/core/theme/app_radius.dart';
import 'package:flutter_bloc_architecture/core/theme/app_text_styles.dart';

/// A custom button widget that triggers an action when pressed.
///
/// Supports loading state, custom styling, and full-width layout.
/// Uses `const` constructors and follows the design system.
class CustomButton extends StatelessWidget {
  /// The text displayed on the button.
  final String text;

  /// The action to be executed when the button is pressed.
  final VoidCallback? onPressed;

  /// Whether the button is in a loading state.
  final bool isLoading;

  /// Whether the button uses the outlined style.
  final bool isOutlined;

  /// Optional button width. Defaults to full width.
  final double? width;

  /// Optional button height. Defaults to 48.
  final double height;

  /// Optional background color override.
  final Color? backgroundColor;

  /// Optional text color override.
  final Color? textColor;

  /// Optional icon to display before the text.
  final IconData? prefixIcon;

  /// Creates a [CustomButton].
  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
    this.width,
    this.height = 48,
    this.backgroundColor,
    this.textColor,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    if (isOutlined) {
      return SizedBox(
        width: width ?? double.infinity,
        height: height,
        child: OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: AppRadius.circularMd,
            ),
            side: BorderSide(
              color: backgroundColor ?? AppColors.primary,
            ),
          ),
          child: _buildChild(
            textColor ?? backgroundColor ?? AppColors.primary,
          ),
        ),
      );
    }

    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? AppColors.primary,
          foregroundColor: textColor ?? AppColors.textOnPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.circularMd,
          ),
          elevation: 0,
        ),
        child: _buildChild(textColor ?? AppColors.textOnPrimary),
      ),
    );
  }

  Widget _buildChild(Color color) {
    if (isLoading) {
      return SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(color),
        ),
      );
    }

    if (prefixIcon != null) {
      return AnimatedSwitcher(
        duration: AppAnimations.fast,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(prefixIcon, size: 18),
            const SizedBox(width: 8),
            Text(
              text,
              style: AppTextStyles.labelLarge.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    }

    return Text(
      text,
      style: AppTextStyles.labelLarge.copyWith(
        color: color,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
