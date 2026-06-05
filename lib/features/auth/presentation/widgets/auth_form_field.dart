import 'package:flutter/material.dart';
import 'package:flutter_bloc_architecture/core/theme/app_radius.dart';
import 'package:flutter_bloc_architecture/core/theme/app_text_styles.dart';

/// A styled form field widget for authentication screens.
///
/// Wraps [TextFormField] with consistent styling, optional label,
/// prefix/suffix icons, and password visibility toggle support.
class AuthFormField extends StatefulWidget {
  /// Text editing controller.
  final TextEditingController? controller;

  /// Label text above the field.
  final String? label;

  /// Hint text inside the field.
  final String? hintText;

  /// Prefix icon.
  final IconData? prefixIcon;

  /// Whether this is a password field (shows toggle).
  final bool isPassword;

  /// Keyboard type.
  final TextInputType? keyboardType;

  /// Text input action.
  final TextInputAction? textInputAction;

  /// Validator function.
  final String? Function(String?)? validator;

  /// On changed callback.
  final ValueChanged<String>? onChanged;

  /// Focus node.
  final FocusNode? focusNode;

  /// Whether the field is enabled.
  final bool enabled;

  /// Creates an [AuthFormField].
  const AuthFormField({
    super.key,
    this.controller,
    this.label,
    this.hintText,
    this.prefixIcon,
    this.isPassword = false,
    this.keyboardType,
    this.textInputAction,
    this.validator,
    this.onChanged,
    this.focusNode,
    this.enabled = true,
  });

  @override
  State<AuthFormField> createState() => _AuthFormFieldState();
}

class _AuthFormFieldState extends State<AuthFormField> {
  late final ValueNotifier<bool> _obscureTextNotifier;

  @override
  void initState() {
    super.initState();
    _obscureTextNotifier = ValueNotifier<bool>(true);
  }

  @override
  void dispose() {
    _obscureTextNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: AppTextStyles.labelLarge.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
        ],
        ValueListenableBuilder<bool>(
          valueListenable: _obscureTextNotifier,
          builder: (context, obscureText, _) {
            return TextFormField(
              controller: widget.controller,
              obscureText: widget.isPassword ? obscureText : false,
              keyboardType: widget.keyboardType,
              textInputAction: widget.textInputAction,
              validator: widget.validator,
              onChanged: widget.onChanged,
              focusNode: widget.focusNode,
              enabled: widget.enabled,
              style: AppTextStyles.bodyMedium,
              decoration: InputDecoration(
                hintText: widget.hintText,
                prefixIcon: widget.prefixIcon != null
                    ? Icon(
                        widget.prefixIcon,
                        size: 20,
                        color: Theme.of(context).colorScheme.outline,
                      )
                    : null,
                suffixIcon: widget.isPassword
                    ? IconButton(
                        icon: Icon(
                          obscureText
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          size: 20,
                          color: Theme.of(context).colorScheme.outline,
                        ),
                        onPressed: () {
                          _obscureTextNotifier.value =
                              !_obscureTextNotifier.value;
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: AppRadius.circularMd,
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.outlineVariant,
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
