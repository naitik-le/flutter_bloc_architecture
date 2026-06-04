import 'package:flutter/material.dart';

/// Reusable custom AppBar widget that implements [PreferredSizeWidget].
///
/// Automatically handles back buttons, styling, and follows the design system theme.
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// The title text to display in the middle of the app bar.
  final String? title;

  /// Custom widget for the title, if a simple string title is not sufficient.
  final Widget? titleWidget;

  /// Optional list of widgets to display in a row after the title.
  final List<Widget>? actions;

  /// Custom leading widget, overriding the default back button.
  final Widget? leading;

  /// Whether the title should be centered. Defaults to `true`.
  final bool centerTitle;

  /// Custom background color. Defaults to `Theme.of(context).colorScheme.surface`.
  final Color? backgroundColor;

  /// Elevation of the app bar. Defaults to `0`.
  final double elevation;

  /// Whether to automatically show the back button when navigation can pop.
  /// Defaults to `true`.
  final bool showBackButton;

  /// Callback for when the back button is pressed.
  final VoidCallback? onBackPressed;

  /// Optional bottom widget (e.g. [TabBar]).
  final PreferredSizeWidget? bottom;

  /// Creates a [CustomAppBar].
  const CustomAppBar({
    super.key,
    this.title,
    this.titleWidget,
    this.actions,
    this.leading,
    this.centerTitle = true,
    this.backgroundColor,
    this.elevation = 0,
    this.showBackButton = true,
    this.onBackPressed,
    this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final canPop = Navigator.of(context).canPop();

    Widget? leadingWidget = leading;
    if (leadingWidget == null && showBackButton && canPop) {
      leadingWidget = IconButton(
        icon: const Icon(
          Icons.arrow_back_ios_new_rounded,
          size: 20,
        ),
        color: theme.colorScheme.onSurface,
        onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
      );
    }

    return AppBar(
      title: titleWidget ??
          (title != null
              ? Text(
                  title!,
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: theme.colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                )
              : null),
      leading: leadingWidget,
      actions: actions,
      centerTitle: centerTitle,
      backgroundColor: backgroundColor ?? theme.colorScheme.surface,
      elevation: elevation,
      iconTheme: theme.iconTheme.copyWith(color: theme.colorScheme.onSurface),
      bottom: bottom,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(
        kToolbarHeight + (bottom?.preferredSize.height ?? 0),
      );
}
