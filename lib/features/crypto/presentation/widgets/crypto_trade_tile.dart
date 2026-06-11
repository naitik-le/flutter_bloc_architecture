import 'package:flutter/material.dart';
import 'package:flutter_bloc_architecture/core/theme/app_radius.dart';
import 'package:flutter_bloc_architecture/core/theme/app_spacing.dart';
import 'package:flutter_bloc_architecture/core/theme/app_text_styles.dart';
import 'package:flutter_bloc_architecture/core/extensions/date_extensions.dart';
import 'package:flutter_bloc_architecture/core/extensions/number_extensions.dart';
import 'package:flutter_bloc_architecture/features/crypto/data/models/crypto_price_model.dart';

/// A compact tile widget displaying a single trade entry.
///
/// Shows the trade price, quantity, and timestamp in a clean
/// horizontal layout. Used in the recent trades list.
class CryptoTradeTile extends StatelessWidget {
  /// The trade data to display.
  final CryptoPriceModel trade;

  /// The index in the list (used for alternating background).
  final int index;

  /// Creates a [CryptoTradeTile].
  const CryptoTradeTile({
    super.key,
    required this.trade,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEven = index.isEven;
    final timeFormattedHnM = trade.tradeTime.time24HourMinute;
    final timeFormattedS = trade.tradeTime.timeSecondsMillis;
    final priceFormatted = trade.price.cryptoPrice;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: isEven ? Colors.transparent : theme.colorScheme.onSurface.withValues(alpha: 0.02),
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        children: [
          // ── Trade Number ──
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.08),
              borderRadius: AppRadius.circularXs,
            ),
            child: Center(
              child: Text(
                '${index + 1}',
                style: AppTextStyles.labelSmall.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          const SizedBox(width: AppSpacing.sm),

          // ── Price ──
          Expanded(
            flex: 3,
            child: Text(
              '\$$priceFormatted',
              style: AppTextStyles.titleMedium.copyWith(
                color: theme.colorScheme.onSurface,
                fontFamily: 'monospace',
              ),
            ),
          ),

          // ── Quantity ──
          Expanded(
            flex: 2,
            child: Text(
              trade.quantity.toStringAsFixed(6),
              textAlign: TextAlign.center,
              style: AppTextStyles.bodySmall.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontFamily: 'monospace',
              ),
            ),
          ),

          const SizedBox(width: AppSpacing.sm),

          // ── Time ──
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  timeFormattedHnM,
                  style: AppTextStyles.labelSmall.copyWith(
                    color: theme.colorScheme.outline,
                    fontFamily: 'monospace',
                  ),
                ),
                Text(
                  timeFormattedS,
                  style: AppTextStyles.labelSmall.copyWith(
                    color: theme.colorScheme.outline,
                    fontFamily: 'monospace',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
