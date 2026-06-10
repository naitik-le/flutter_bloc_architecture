import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_architecture/core/di/injection.dart';
import 'package:flutter_bloc_architecture/core/extensions/context_extensions.dart';
import 'package:flutter_bloc_architecture/core/theme/app_colors.dart';
import 'package:flutter_bloc_architecture/core/theme/app_radius.dart';
import 'package:flutter_bloc_architecture/core/theme/app_spacing.dart';
import 'package:flutter_bloc_architecture/core/theme/app_text_styles.dart';
import 'package:flutter_bloc_architecture/core/theme/theme_cubit.dart';
import 'package:flutter_bloc_architecture/core/widgets/custom_button.dart';
import 'package:flutter_bloc_architecture/core/widgets/custom_text_field.dart';
import 'package:flutter_bloc_architecture/core/widgets/loading_indicator.dart';
import 'package:flutter_bloc_architecture/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_bloc_architecture/features/profile/domain/entities/profile_entity.dart';
import 'package:flutter_bloc_architecture/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:flutter_bloc_architecture/features/profile/presentation/bloc/profile_event.dart';
import 'package:flutter_bloc_architecture/features/profile/presentation/bloc/profile_state.dart';
import 'package:flutter_bloc_architecture/features/profile/presentation/widgets/avatar_selector_sheet.dart';
import 'package:flutter_bloc_architecture/routes/app_routes.dart';

/// Main profile screen displaying user information, preferences, and explorer statistics.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<ProfileBloc>()..add(const LoadProfileEvent())),
        BlocProvider.value(value: context.read<AuthBloc>()),
      ],
      child: const _ProfileScreenContent(),
    );
  }
}

class _ProfileScreenContent extends StatefulWidget {
  const _ProfileScreenContent();

  @override
  State<_ProfileScreenContent> createState() => _ProfileScreenContentState();
}

class _ProfileScreenContentState extends State<_ProfileScreenContent> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _emailController;

  final ValueNotifier<bool> _isEditingNotifier = ValueNotifier<bool>(false);
  final ValueNotifier<String> _selectedRocketNotifier = ValueNotifier<String>('Falcon 9');

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _emailController = TextEditingController();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _isEditingNotifier.dispose();
    _selectedRocketNotifier.dispose();
    super.dispose();
  }

  void _toggleEditMode(ProfileEntity profile) {
    if (_isEditingNotifier.value) {
      // Save changes
      if (_formKey.currentState?.validate() ?? false) {
        final updatedProfile = ProfileEntity(
          firstName: _firstNameController.text.trim(),
          lastName: _lastNameController.text.trim(),
          email: _emailController.text.trim(),
          avatarUrl: profile.avatarUrl,
          favoriteRocket: _selectedRocketNotifier.value,
          notificationsEnabled: profile.notificationsEnabled,
          biometricEnabled: profile.biometricEnabled,
          explorerXp: profile.explorerXp,
          rank: profile.rank,
        );
        context.read<ProfileBloc>().add(UpdateProfileEvent(updatedProfile));
        _isEditingNotifier.value = false;
        context.showSnackBar(
          'Cosmic profile updated successfully!',
          type: SnackBarType.success,
        );
      }
    } else {
      // Enter edit mode
      _firstNameController.text = profile.firstName;
      _lastNameController.text = profile.lastName;
      _emailController.text = profile.email;
      _selectedRocketNotifier.value = profile.favoriteRocket;
      _isEditingNotifier.value = true;
    }
  }

  void _showAvatarPicker(BuildContext context, String currentAvatarId, ProfileEntity profile) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) {
        return AvatarSelectorSheet(
          currentAvatarId: currentAvatarId,
          onAvatarSelected: (selectedAvatar) {
            final updated = ProfileEntity(
              firstName: profile.firstName,
              lastName: profile.lastName,
              email: profile.email,
              avatarUrl: selectedAvatar.id,
              favoriteRocket: profile.favoriteRocket,
              notificationsEnabled: profile.notificationsEnabled,
              biometricEnabled: profile.biometricEnabled,
              explorerXp: profile.explorerXp,
              rank: profile.rank,
            );
            context.read<ProfileBloc>().add(UpdateProfileEvent(updated));
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Form(
        key: _formKey,
        child: BlocConsumer<ProfileBloc, ProfileState>(
          listener: (context, state) {
            if (state.status == ProfileStatus.success && state.profile != null) {
              final profile = state.profile!;
              if (!_isEditingNotifier.value) {
                _firstNameController.text = profile.firstName;
                _lastNameController.text = profile.lastName;
                _emailController.text = profile.email;
                _selectedRocketNotifier.value = profile.favoriteRocket;
              }
            } else if (state.status == ProfileStatus.failure) {
              context.showSnackBar(
                state.errorMsg ?? 'Failed to perform operation',
                type: SnackBarType.error,
              );
            }
          },
          builder: (context, state) {
            if (state.status == ProfileStatus.loading && state.profile == null) {
              return const LoadingIndicator(
                message: 'Loading cosmic coordinates...',
              );
            }

            final profile = state.profile;
            if (profile == null) {
              return const Center(child: Text('Failed to load profile'));
            }

            // Lookup matching avatar from constants
            final currentAvatar = spaceAvatars.firstWhere(
              (a) => a.id == profile.avatarUrl,
              orElse: () => spaceAvatars.first,
            );

            return CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // ── Parallax / Collapsible Header ──
                SliverAppBar(
                  expandedHeight: 120,
                  pinned: true,
                  stretch: true,
                  backgroundColor: theme.scaffoldBackgroundColor,
                  surfaceTintColor: theme.scaffoldBackgroundColor,
                  elevation: 0,
                  actions: [
                    ValueListenableBuilder<bool>(
                      valueListenable: _isEditingNotifier,
                      builder: (context, isEditing, _) {
                        return IconButton(
                          icon: Icon(
                            isEditing ? Icons.check_rounded : Icons.edit_rounded,
                            color: theme.colorScheme.secondary,
                          ),
                          tooltip: isEditing ? 'Save Changes' : 'Edit Profile',
                          onPressed: () => _toggleEditMode(profile),
                        );
                      },
                    ),
                  ],
                ),

                // ── Profile Main Content ──
                SliverList(
                  delegate: SliverChildListDelegate([
                    Transform.translate(
                      offset: const Offset(0, 20),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // ── Interactive Avatar Badge ──
                            Center(
                              child: Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  // Outer glowing border ring
                                  Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: LinearGradient(colors: currentAvatar.gradient),
                                      boxShadow: [
                                        BoxShadow(
                                          color: currentAvatar.gradient.first.withValues(alpha: 0.4),
                                          blurRadius: 16,
                                          spreadRadius: 2,
                                        ),
                                      ],
                                    ),
                                    child: CircleAvatar(
                                      radius: 46,
                                      backgroundColor: AppColors.white,
                                      child: Container(
                                        width: 84,
                                        height: 84,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          gradient: LinearGradient(
                                            colors: currentAvatar.gradient,
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                        ),
                                        child: Icon(
                                          currentAvatar.icon,
                                          color: AppColors.white,
                                          size: 40,
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Edit avatar floating badge
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: Material(
                                      type: MaterialType.circle,
                                      color: theme.colorScheme.primary,
                                      elevation: 3,
                                      child: InkWell(
                                        customBorder: const CircleBorder(),
                                        onTap: () => _showAvatarPicker(context, profile.avatarUrl, profile),
                                        child: const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Icon(
                                            Icons.camera_alt_rounded,
                                            color: AppColors.white,
                                            size: 16,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: AppSpacing.md),

                            // Name & Rank Headers
                            Center(
                              child: Text(
                                profile.fullName,
                                style: AppTextStyles.headlineMedium.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.onSurface,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.xxs),
                            Center(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppSpacing.sm,
                                  vertical: AppSpacing.xxxs,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.secondary.withValues(alpha: 0.15),
                                  borderRadius: AppRadius.circularFull,
                                ),
                                child: Text(
                                  profile.rank.toUpperCase(),
                                  style: AppTextStyles.labelSmall.copyWith(
                                    color: AppColors.secondary,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.1,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: AppSpacing.xl),

                            // ── Achievement XP Card ──
                            AchievementCard(profile: profile),
                            const SizedBox(height: AppSpacing.md),

                            // ── Stats Explorer Grid ──
                            const StatsGrid(),
                            const SizedBox(height: AppSpacing.xl),

                            // ── Form fields card (Editable / Non-editable) ──
                            _buildSectionHeader(theme, 'Personal Info'),
                            const SizedBox(height: AppSpacing.xs),
                            PersonalInfoCard(
                              isEditingNotifier: _isEditingNotifier,
                              firstNameController: _firstNameController,
                              lastNameController: _lastNameController,
                              emailController: _emailController,
                              profile: profile,
                            ),
                            const SizedBox(height: AppSpacing.xl),

                            // ── Settings / Preferences ──
                            _buildSectionHeader(theme, 'SpaceX Preferences'),
                            const SizedBox(height: AppSpacing.xs),
                            SpacePreferencesCard(
                              selectedRocketNotifier: _selectedRocketNotifier,
                              profile: profile,
                            ),
                            const SizedBox(height: AppSpacing.xl),

                            _buildSectionHeader(theme, 'App Settings'),
                            const SizedBox(height: AppSpacing.xs),
                            const AppSettingsCard(),
                            const SizedBox(height: AppSpacing.xl),

                            // ── Logout Action ──
                            CustomButton(
                              text: 'Abort Mission (Logout)',
                              backgroundColor: AppColors.error,
                              onPressed: () => _confirmLogout(context),
                            ),
                            const SizedBox(height: 120),
                          ],
                        ),
                      ),
                    ),
                  ]),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSectionHeader(ThemeData theme, String title) {
    return Padding(
      padding: const EdgeInsets.only(left: AppSpacing.xs),
      child: Text(
        title,
        style: AppTextStyles.titleMedium.copyWith(
          fontWeight: FontWeight.bold,
          color: theme.colorScheme.onSurface,
        ),
      ),
    );
  }

  void _confirmLogout(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        title: const Text('Abort Mission'),
        content: const Text('Are you sure you want to sign out and clear your cached coordinates?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogCtx);
              // Clear profile and logout
              context.read<ProfileBloc>().add(const ResetProfileEvent());
              context.read<AuthBloc>().add(const PerformLogoutEvent());
              // Force redirection to login route
              Navigator.of(context).pushNamedAndRemoveUntil(
                Routes.login,
                (route) => false,
              );
            },
            child: const Text(
              'Logout',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}

class AchievementCard extends StatelessWidget {
  final ProfileEntity profile;

  const AchievementCard({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const maxXp = 1000;
    final progress = (profile.explorerXp / maxXp).clamp(0.0, 1.0);

    return Card(
      elevation: 0,
      color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.circularMd,
        side: BorderSide(color: theme.colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.military_tech_rounded, color: AppColors.secondary, size: 24),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      'Explorer Rank',
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
                Text(
                  'LVL 8',
                  style: AppTextStyles.labelLarge.copyWith(
                    color: AppColors.secondary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            ClipRRect(
              borderRadius: AppRadius.circularFull,
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 8,
                backgroundColor: theme.colorScheme.outlineVariant,
                valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${profile.explorerXp} XP',
                  style: AppTextStyles.labelMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                Text(
                  '${maxXp - profile.explorerXp} XP to level up',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class StatsGrid extends StatelessWidget {
  const StatsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(
          child: _StatItem(
            icon: Icons.rocket_launch_rounded,
            value: '18',
            label: 'Launches',
            accentColor: Color(0xFFC87A24),
          ),
        ),
        SizedBox(width: AppSpacing.sm),
        Expanded(
          child: _StatItem(
            icon: Icons.explore_rounded,
            value: '4',
            label: 'Rockets',
            accentColor: Color(0xFF5F6F52),
          ),
        ),
        SizedBox(width: AppSpacing.sm),
        Expanded(
          child: _StatItem(
            icon: Icons.checklist_rtl_rounded,
            value: '12',
            label: 'Missions',
            accentColor: Color(0xFF5D7B93),
          ),
        ),
      ],
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color accentColor;

  const _StatItem({
    required this.icon,
    required this.value,
    required this.label,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 0,
      color: theme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.circularMd,
        side: BorderSide(color: theme.colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.xs),
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: accentColor, size: 20),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              value,
              style: AppTextStyles.titleLarge.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
            Text(
              label,
              style: AppTextStyles.bodySmall.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PersonalInfoCard extends StatelessWidget {
  final ValueNotifier<bool> isEditingNotifier;
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController emailController;
  final ProfileEntity profile;

  const PersonalInfoCard({
    super.key,
    required this.isEditingNotifier,
    required this.firstNameController,
    required this.lastNameController,
    required this.emailController,
    required this.profile,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 0,
      color: theme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.circularMd,
        side: BorderSide(color: theme.colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: ValueListenableBuilder<bool>(
          valueListenable: isEditingNotifier,
          builder: (context, isEditing, _) {
            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: isEditing
                  ? Column(
                      key: const ValueKey('edit_info_fields'),
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        CustomTextField(
                          controller: firstNameController,
                          label: 'First Name',
                          hintText: 'Enter first name',
                          prefixIcon: Icons.badge_outlined,
                          validator: (v) => v == null || v.isEmpty ? 'Required field' : null,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        CustomTextField(
                          controller: lastNameController,
                          label: 'Last Name',
                          hintText: 'Enter last name',
                          prefixIcon: Icons.badge_outlined,
                          validator: (v) => v == null || v.isEmpty ? 'Required field' : null,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        CustomTextField(
                          controller: emailController,
                          label: 'Email Address',
                          hintText: 'Enter email',
                          prefixIcon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                          validator: (v) => v == null || !v.contains('@') ? 'Invalid email' : null,
                        ),
                      ],
                    )
                  : Column(
                      key: const ValueKey('view_info_tiles'),
                      children: [
                        _InfoTile(
                          icon: Icons.person_outline_rounded,
                          label: 'First Name',
                          value: profile.firstName.isEmpty ? 'Not set' : profile.firstName,
                        ),
                        const Divider(),
                        _InfoTile(
                          icon: Icons.person_outline_rounded,
                          label: 'Last Name',
                          value: profile.lastName.isEmpty ? 'Not set' : profile.lastName,
                        ),
                        const Divider(),
                        _InfoTile(
                          icon: Icons.email_outlined,
                          label: 'Email Address',
                          value: profile.email,
                        ),
                      ],
                    ),
            );
          },
        ),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        children: [
          Icon(icon, size: 20, color: theme.colorScheme.outline),
          const SizedBox(width: AppSpacing.md),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTextStyles.bodySmall.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class SpacePreferencesCard extends StatelessWidget {
  final ValueNotifier<String> selectedRocketNotifier;
  final ProfileEntity profile;

  const SpacePreferencesCard({
    super.key,
    required this.selectedRocketNotifier,
    required this.profile,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final rocketOptions = ['Falcon 9', 'Falcon Heavy', 'Starship'];

    return Card(
      elevation: 0,
      color: theme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.circularMd,
        side: BorderSide(color: theme.colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Favorite Rocket Configuration',
              style: AppTextStyles.bodySmall.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),

            // Horizontal Selector Cards
            ValueListenableBuilder<String>(
              valueListenable: selectedRocketNotifier,
              builder: (context, selectedRocket, _) {
                return Row(
                  children: rocketOptions.map((rocket) {
                    final isSelected = selectedRocket == rocket;
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2),
                        child: InkWell(
                          onTap: () {
                            selectedRocketNotifier.value = rocket;
                            // Instantly auto-save preference updates
                            final updated = ProfileEntity(
                              firstName: profile.firstName,
                              lastName: profile.lastName,
                              email: profile.email,
                              avatarUrl: profile.avatarUrl,
                              favoriteRocket: rocket,
                              notificationsEnabled: profile.notificationsEnabled,
                              biometricEnabled: profile.biometricEnabled,
                              explorerXp: profile.explorerXp,
                              rank: profile.rank,
                            );
                            context.read<ProfileBloc>().add(UpdateProfileEvent(updated));
                          },
                          borderRadius: AppRadius.circularSm,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                            decoration: BoxDecoration(
                              color: isSelected ? theme.colorScheme.primary.withValues(alpha: 0.1) : theme.colorScheme.surface,
                              border: Border.all(
                                color: isSelected ? theme.colorScheme.primary : theme.colorScheme.outlineVariant,
                                width: isSelected ? 1.5 : 1,
                              ),
                              borderRadius: AppRadius.circularSm,
                            ),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.rocket_launch_rounded,
                                  color: isSelected ? theme.colorScheme.primary : theme.colorScheme.outline,
                                  size: 20,
                                ),
                                const SizedBox(height: AppSpacing.xs),
                                Text(
                                  rocket,
                                  style: AppTextStyles.labelMedium.copyWith(
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                    color: isSelected ? theme.colorScheme.primary : theme.colorScheme.onSurface,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class AppSettingsCard extends StatelessWidget {
  const AppSettingsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 0,
      color: theme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.circularMd,
        side: BorderSide(color: theme.colorScheme.outlineVariant),
      ),
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          final isDark = theme.brightness == Brightness.dark;

          return Column(
            children: [
              // Dynamic Mode Swapper
              SwitchListTile(
                title: Text(
                  'Dark Theme Mode',
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w500,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                subtitle: Text(
                  'Engage space night colors',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                secondary: Icon(
                  isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                  color: isDark ? AppColors.secondaryLight : AppColors.primary,
                ),
                value: isDark,
                activeThumbColor: AppColors.secondary,
                onChanged: (_) {
                  context.read<ThemeCubit>().toggleTheme();
                },
              ),
              const Divider(indent: 56),

              // Mock Notification Preferences
              SwitchListTile(
                title: Text(
                  'Mission Alerts',
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w500,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                subtitle: Text(
                  'Receive push updates on SpaceX launches',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                secondary: Icon(
                  Icons.notifications_active_outlined,
                  color: theme.colorScheme.outline,
                ),
                value: true,
                activeThumbColor: AppColors.secondary,
                onChanged: (_) {},
              ),
              const Divider(indent: 56),

              // Mock Biometric Settings
              SwitchListTile(
                title: Text(
                  'Biometric Launch Lock',
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w500,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                subtitle: Text(
                  'Secure profile using fingerprint/face ID',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                secondary: Icon(
                  Icons.fingerprint_rounded,
                  color: theme.colorScheme.outline,
                ),
                value: false,
                activeThumbColor: AppColors.secondary,
                onChanged: (_) {},
              ),
            ],
          );
        },
      ),
    );
  }
}

/// Star field custom painter for the collapsible background
class _StarsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final List<Offset> starLocations = [
      Offset(size.width * 0.1, size.height * 0.2),
      Offset(size.width * 0.25, size.height * 0.15),
      Offset(size.width * 0.35, size.height * 0.45),
      Offset(size.width * 0.55, size.height * 0.2),
      Offset(size.width * 0.75, size.height * 0.35),
      Offset(size.width * 0.85, size.height * 0.15),
      Offset(size.width * 0.9, size.height * 0.5),
      Offset(size.width * 0.15, size.height * 0.7),
      Offset(size.width * 0.45, size.height * 0.75),
      Offset(size.width * 0.7, size.height * 0.8),
    ];

    for (var i = 0; i < starLocations.length; i++) {
      final radius = (i % 3 == 0) ? 2.0 : 1.2;
      canvas.drawCircle(starLocations[i], radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
