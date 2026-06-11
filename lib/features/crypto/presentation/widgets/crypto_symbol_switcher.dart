import 'package:flutter/material.dart';
import 'package:flutter_bloc_architecture/core/theme/app_colors.dart';
import 'package:flutter_bloc_architecture/core/theme/app_radius.dart';
import 'package:flutter_bloc_architecture/core/theme/app_spacing.dart';
import 'package:flutter_bloc_architecture/core/theme/app_text_styles.dart';

/// A horizontal chip-style symbol switcher for cryptocurrency pairs.
///
/// Displays selectable chips for each supported trading pair (BTC, ETH, SOL).
/// The active chip is visually highlighted with the primary color.
class CryptoSymbolSwitcher extends StatelessWidget {
  /// The currently selected symbol (e.g. "btcusdt").
  final String currentSymbol;

  /// Callback when a symbol chip is tapped.
  final ValueChanged<String> onSymbolChanged;

  /// Creates a [CryptoSymbolSwitcher].
  const CryptoSymbolSwitcher({
    super.key,
    required this.currentSymbol,
    required this.onSymbolChanged,
  });

  /// Supported trading pairs with display labels.
  static const List<_SymbolOption> _symbols = [
    _SymbolOption(symbol: 'btcusdt', label: 'BTC', icon: '₿'),
    _SymbolOption(symbol: 'ethusdt', label: 'ETH', icon: 'Ξ'),
    _SymbolOption(symbol: 'solusdt', label: 'SOL', icon: '◎'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      child: Row(
        children: _symbols.map((option) {
          final isSelected = currentSymbol == option.symbol;
          return Padding(
            padding: const EdgeInsets.only(right: AppSpacing.xs),
            child: _SymbolChip(
              option: option,
              isSelected: isSelected,
              onTap: () => onSymbolChanged(option.symbol),
            ),
          );
        }).toList(),
      ),
    );
  }
}

/// Internal widget for an individual symbol chip.
class _SymbolChip extends StatelessWidget {
  final _SymbolOption option;
  final bool isSelected;
  final VoidCallback onTap;

  const _SymbolChip({
    required this.option,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color:
            isSelected ? theme.colorScheme.primary : theme.colorScheme.surface,
        borderRadius: AppRadius.circularFull,
        border: Border.all(
          color: isSelected
              ? theme.colorScheme.primary
              : theme.colorScheme.outlineVariant,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: AppRadius.circularFull,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadius.circularFull,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.xs,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  option.icon,
                  style: AppTextStyles.titleMedium.copyWith(
                    color: isSelected
                        ? AppColors.textOnPrimary
                        : theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(width: AppSpacing.xxs),
                Text(
                  option.label,
                  style: AppTextStyles.labelLarge.copyWith(
                    color: isSelected
                        ? AppColors.textOnPrimary
                        : theme.colorScheme.onSurface,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Data class for a symbol option in the switcher.
class _SymbolOption {
  final String symbol;
  final String label;
  final String icon;

  const _SymbolOption({
    required this.symbol,
    required this.label,
    required this.icon,
  });
}
