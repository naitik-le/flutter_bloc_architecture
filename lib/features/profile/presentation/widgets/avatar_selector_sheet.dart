import 'package:flutter/material.dart';
import 'package:flutter_bloc_architecture/core/theme/app_colors.dart';
import 'package:flutter_bloc_architecture/core/theme/app_radius.dart';
import 'package:flutter_bloc_architecture/core/theme/app_spacing.dart';
import 'package:flutter_bloc_architecture/core/theme/app_text_styles.dart';

/// Predefined space avatars for profile customization.
class SpaceAvatar {
  final String id;
  final String name;
  final IconData icon;
  final List<Color> gradient;

  const SpaceAvatar({
    required this.id,
    required this.name,
    required this.icon,
    required this.gradient,
  });
}

/// A list of beautiful preloaded avatars.
final List<SpaceAvatar> spaceAvatars = [
  const SpaceAvatar(
    id: 'astronaut',
    name: 'Commander',
    icon: Icons.rocket_launch_rounded,
    gradient: [Color(0xFFC87A24), Color(0xFFBC4A3C)],
  ),
  const SpaceAvatar(
    id: 'rover',
    name: 'Mars Rover',
    icon: Icons.precision_manufacturing_rounded,
    gradient: [Color(0xFF5F6F52), Color(0xFFA9B388)],
  ),
  const SpaceAvatar(
    id: 'satellite',
    name: 'Satellite',
    icon: Icons.settings_input_antenna_rounded,
    gradient: [Color(0xFF5D7B93), Color(0xFF98B3C7)],
  ),
  const SpaceAvatar(
    id: 'telescope',
    name: 'Hubble',
    icon: Icons.visibility_rounded,
    gradient: [Color(0xFF7B2CBF), Color(0xFF9D4EDD)],
  ),
  const SpaceAvatar(
    id: 'ufo',
    name: 'Invader',
    icon: Icons.leak_add_rounded,
    gradient: [Color(0xFF10002B), Color(0xFF3C096C)],
  ),
  const SpaceAvatar(
    id: 'alien',
    name: 'Stardust',
    icon: Icons.brightness_3_rounded,
    gradient: [Color(0xFFD4A373), Color(0xFFC87A24)],
  ),
];

/// A premium modal sheet allowing users to select an avatar.
class AvatarSelectorSheet extends StatelessWidget {
  /// Currently selected avatar id.
  final String currentAvatarId;

  /// Callback when an avatar is picked.
  final ValueChanged<SpaceAvatar> onAvatarSelected;

  /// Creates an [AvatarSelectorSheet].
  const AvatarSelectorSheet({
    super.key,
    required this.currentAvatarId,
    required this.onAvatarSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.lg,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.vertical(
          top: AppRadius.circularLg.topRight,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Drag indicator
          Center(
            child: Container(
              width: 40,
              height: 5,
              decoration: BoxDecoration(
                color: theme.colorScheme.outlineVariant,
                borderRadius: AppRadius.circularFull,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          // Title
          Text(
            'Select Cosmic Avatar',
            style: AppTextStyles.headlineSmall.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Choose your explorer persona for the SpaceX missions.',
            style: AppTextStyles.bodyMedium.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.lg),

          // Avatar Grid
          Wrap(
            spacing: AppSpacing.md,
            runSpacing: AppSpacing.md,
            alignment: WrapAlignment.center,
            children: List.generate(spaceAvatars.length, (index) {
              final avatar = spaceAvatars[index];
              final isSelected = avatar.id == currentAvatarId;
              final screenWidth = MediaQuery.of(context).size.width;
              // Calculate 3-column split accounting for 16px horizontal padding and spacing
              final itemWidth = (screenWidth - (AppSpacing.md * 2) - (AppSpacing.md * 2)) / 3;

              return SizedBox(
                width: itemWidth,
                height: itemWidth / 0.85,
                child: InkWell(
                  onTap: () {
                    onAvatarSelected(avatar);
                    Navigator.pop(context);
                  },
                  borderRadius: AppRadius.circularMd,
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected
                          ? theme.colorScheme.primary.withValues(alpha: 0.08)
                          : Colors.transparent,
                      borderRadius: AppRadius.circularMd,
                      border: Border.all(
                        color: isSelected
                            ? theme.colorScheme.primary
                            : theme.colorScheme.outlineVariant,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Avatar Icon Circle with Gradient
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: avatar.gradient,
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color:
                                    avatar.gradient.first.withValues(alpha: 0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Icon(
                            avatar.icon,
                            color: AppColors.white,
                            size: 32,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          avatar.name,
                          style: AppTextStyles.labelMedium.copyWith(
                            fontWeight:
                                isSelected ? FontWeight.bold : FontWeight.w500,
                            color: isSelected
                                ? theme.colorScheme.primary
                                : theme.colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: AppSpacing.md),
        ],
      ),
    );
  }
}
