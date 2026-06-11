import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_architecture/core/theme/app_colors.dart';
import 'package:flutter_bloc_architecture/core/theme/app_spacing.dart';

/// Reusable premium floating bottom navigation bar.
class CustomBottomNavBar extends StatelessWidget {
  /// The index of the currently selected tab.
  final int currentIndex;

  /// Callback when a tab is tapped.
  final ValueChanged<int> onTap;

  /// Creates a [CustomBottomNavBar].
  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final activeColor = theme.colorScheme.primary;
    final inactiveColor =
    theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.6);

    return Container(
      margin: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        0,
        AppSpacing.lg,
        AppSpacing.lg,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xs,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 16,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(
            context: context,
            index: 0,
            icon: CupertinoIcons.house,
            activeIcon: CupertinoIcons.house_fill,
            label: 'Home',
            activeColor: activeColor,
            inactiveColor: inactiveColor,
          ),
          _buildNavItem(
            context: context,
            index: 1,
            icon: CupertinoIcons.shopping_cart,
            activeIcon: CupertinoIcons.cart_fill,
            label: 'Products',
            activeColor: activeColor,
            inactiveColor: inactiveColor,
          ),
          _buildNavItem(
            context: context,
            index: 2,
            icon: CupertinoIcons.chart_bar,
            activeIcon: CupertinoIcons.chart_bar_fill,
            label: 'Crypto',
            activeColor: activeColor,
            inactiveColor: inactiveColor,
          ),
          _buildNavItem(
            context: context,
            index: 3,
            icon: CupertinoIcons.person_crop_circle,
            activeIcon: CupertinoIcons.person_crop_circle_fill,
            label: 'Profile',
            activeColor: activeColor,
            inactiveColor: inactiveColor,
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required int index,
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required Color activeColor,
    required Color inactiveColor,
  }) {
    final isSelected = currentIndex == index;
    final theme = Theme.of(context);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onTap(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? activeColor.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? activeIcon : icon,
              color: isSelected ? activeColor : inactiveColor,
              size: 24,
            ),
            AnimatedCrossFade(
              duration: const Duration(milliseconds: 200),
              firstChild: Padding(
                padding: const EdgeInsets.only(left: AppSpacing.xs),
                child: Text(
                  label,
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: activeColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              secondChild: const SizedBox.shrink(),
              crossFadeState: isSelected
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
            ),
          ],
        ),
      ),
    );
  }
}
