import 'package:flutter/material.dart';
import 'package:flutter_bloc_architecture/core/theme/app_colors.dart';
import 'package:flutter_bloc_architecture/core/theme/app_radius.dart';
import 'package:flutter_bloc_architecture/core/theme/app_spacing.dart';
import 'package:flutter_bloc_architecture/core/theme/app_text_styles.dart';
import 'package:flutter_bloc_architecture/core/extensions/date_extensions.dart';
import 'package:flutter_bloc_architecture/core/extensions/number_extensions.dart';
import 'package:flutter_bloc_architecture/features/crypto/data/models/crypto_price_model.dart';

/// A premium live price card showing the current crypto trade data.
///
/// Displays:
/// - Currency symbol and display pair name
/// - Current price (large, formatted with $ and commas)
/// - Price change indicator (↑ green / ↓ red / → neutral)
/// - Last update timestamp
class CryptoPriceCard extends StatelessWidget {
  /// The current trade data to display.
  final CryptoPriceModel currentTrade;

  /// The previous trade price for calculating price direction.
  final double? previousPrice;

  /// Creates a [CryptoPriceCard].
  const CryptoPriceCard({
    super.key,
    required this.currentTrade,
    this.previousPrice,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final priceDirection = _getPriceDirection();
    final priceFormatted = currentTrade.price.cryptoPrice;
    final timeFormatted = currentTrade.tradeTime.time24WithSeconds;

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: AppRadius.circularLg,
        border: Border.all(color: theme.colorScheme.outlineVariant),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header: Symbol + Live Badge ──
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  _CurrencyIcon(baseCurrency: currentTrade.baseCurrency),
                  const SizedBox(width: AppSpacing.xs),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        currentTrade.baseCurrency,
                        style: AppTextStyles.headlineSmall.copyWith(
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      Text(
                        currentTrade.displaySymbol,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const _LiveBadge(),
            ],
          ),

          const SizedBox(height: AppSpacing.lg),

          // ── Price Display ──
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Text(
                  '\$$priceFormatted',
                  style: AppTextStyles.displayLarge.copyWith(
                    color: theme.colorScheme.onSurface,
                    fontWeight: FontWeight.w800,
                    fontSize: 36,
                  ),
                ),
              ),
              _PriceChangeIndicator(direction: priceDirection),
            ],
          ),

          const SizedBox(height: AppSpacing.sm),

          // ── Footer: Quantity + Last Update ──
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Qty: ${currentTrade.quantity.toStringAsFixed(6)}',
                style: AppTextStyles.bodySmall.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              Row(
                children: [
                  Icon(
                    Icons.access_time_rounded,
                    size: 14,
                    color: theme.colorScheme.outline,
                  ),
                  const SizedBox(width: AppSpacing.xxxs),
                  Text(
                    timeFormatted,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Determines the price direction compared to the previous price.
  _PriceDirection _getPriceDirection() {
    if (previousPrice == null) return _PriceDirection.neutral;
    if (currentTrade.price > previousPrice!) return _PriceDirection.up;
    if (currentTrade.price < previousPrice!) return _PriceDirection.down;
    return _PriceDirection.neutral;
  }

}

/// Animated currency icon based on the base currency.
class _CurrencyIcon extends StatelessWidget {
  final String baseCurrency;

  const _CurrencyIcon({required this.baseCurrency});

  @override
  Widget build(BuildContext context) {

    String iconText;
    Color bgColor;

    switch (baseCurrency) {
      case 'BTC':
        iconText = '₿';
        bgColor = const Color(0xFFF7931A);
      case 'ETH':
        iconText = 'Ξ';
        bgColor = const Color(0xFF627EEA);
      case 'SOL':
        iconText = '◎';
        bgColor = const Color(0xFF9945FF);
      default:
        iconText = '\$';
        bgColor = AppColors.primary;
    }

    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: bgColor.withValues(alpha: 0.15),
        borderRadius: AppRadius.circularMd,
      ),
      child: Center(
        child: Text(
          iconText,
          style: AppTextStyles.headlineMedium.copyWith(
            color: bgColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

/// A pulsing "LIVE" indicator badge.
class _LiveBadge extends StatefulWidget {
  const _LiveBadge({super.key});

  @override
  State<_LiveBadge> createState() => _LiveBadgeState();
}

class _LiveBadgeState extends State<_LiveBadge>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xs,
        vertical: AppSpacing.xxxs,
      ),
      decoration: BoxDecoration(
        color: AppColors.success.withValues(alpha: 0.12),
        borderRadius: AppRadius.circularFull,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.success.withValues(alpha: _animation.value),
                ),
              );
            },
          ),
          const SizedBox(width: AppSpacing.xxs),
          Text(
            'LIVE',
            style: AppTextStyles.labelSmall.copyWith(
              color: AppColors.success,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.0,
            ),
          ),
        ],
      ),
    );
  }
}

/// Price direction indicator arrow.
class _PriceChangeIndicator extends StatelessWidget {
  final _PriceDirection direction;

  const _PriceChangeIndicator({required this.direction});

  @override
  Widget build(BuildContext context) {
    IconData icon;
    Color color;

    switch (direction) {
      case _PriceDirection.up:
        icon = Icons.trending_up_rounded;
        color = AppColors.success;
      case _PriceDirection.down:
        icon = Icons.trending_down_rounded;
        color = AppColors.error;
      case _PriceDirection.neutral:
        icon = Icons.trending_flat_rounded;
        color = AppColors.info;
    }

    return Container(
      padding: const EdgeInsets.all(AppSpacing.xxs),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: AppRadius.circularSm,
      ),
      child: Icon(icon, color: color, size: 24),
    );
  }
}

/// Enum for price movement direction.
enum _PriceDirection { up, down, neutral }
