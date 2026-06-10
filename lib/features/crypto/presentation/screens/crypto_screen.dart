import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_architecture/core/theme/app_colors.dart';
import 'package:flutter_bloc_architecture/core/theme/app_radius.dart';
import 'package:flutter_bloc_architecture/core/theme/app_spacing.dart';
import 'package:flutter_bloc_architecture/core/theme/app_text_styles.dart';
import 'package:flutter_bloc_architecture/core/widgets/app_error_widget.dart';
import 'package:flutter_bloc_architecture/core/widgets/custom_app_bar.dart';
import 'package:flutter_bloc_architecture/features/crypto/data/models/crypto_price_model.dart';
import 'package:flutter_bloc_architecture/features/crypto/presentation/bloc/crypto_bloc.dart';
import 'package:flutter_bloc_architecture/features/crypto/presentation/widgets/crypto_price_card.dart';
import 'package:flutter_bloc_architecture/features/crypto/presentation/widgets/crypto_symbol_switcher.dart';
import 'package:flutter_bloc_architecture/features/crypto/presentation/widgets/crypto_trade_tile.dart';
import 'package:skeletonizer/skeletonizer.dart';

/// Main crypto dashboard screen with live price streaming.
///
/// Layout:
/// - [CustomAppBar] with "Crypto Dashboard" title
/// - [CryptoSymbolSwitcher] for BTC/ETH/SOL pair selection
/// - [CryptoPriceCard] showing live price with change indicator
/// - Recent trades list (latest 20) with [CryptoTradeTile]
///
/// Uses [BlocBuilder] and [BlocSelector] to minimize unnecessary rebuilds.
/// Shows [Skeletonizer] during initial connection and [AppErrorWidget] on failure.
class CryptoScreen extends StatefulWidget {
  /// Creates a [CryptoScreen].
  const CryptoScreen({super.key});

  @override
  State<CryptoScreen> createState() => _CryptoScreenState();
}

class _CryptoScreenState extends State<CryptoScreen> {
  @override
  void initState() {
    super.initState();
    // Start streaming BTC by default on first load.
    context.read<CryptoBloc>().add(const CryptoConnectEvent('btcusdt'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Crypto',
        showBackButton: false,
      ),
      body: Column(
        children: [
          // ── Section 1: Symbol Switcher ──
          BlocSelector<CryptoBloc, CryptoState, String>(
            selector: (state) => state.currentSymbol,
            builder: (context, currentSymbol) {
              return CryptoSymbolSwitcher(
                currentSymbol: currentSymbol,
                onSymbolChanged: (symbol) {
                  context.read<CryptoBloc>().add(CryptoConnectEvent(symbol));
                },
              );
            },
          ),

          // ── Section 2: Main Content ──
          Expanded(
            child: BlocBuilder<CryptoBloc, CryptoState>(
              buildWhen: (previous, current) {
                final prevIsError = previous.hasFailed && previous.currentTrade == null;
                final currIsError = current.hasFailed && current.currentTrade == null;

                final prevIsLoading = previous.isInitialLoading;
                final currIsLoading = current.isInitialLoading;

                return prevIsError != currIsError || prevIsLoading != currIsLoading || (currIsError && previous.errorMessage != current.errorMessage);
              },
              builder: (context, state) {
                // ── Error State ──
                if (state.hasFailed && state.currentTrade == null) {
                  return _buildErrorSection(context, state);
                }

                // ── Initial Loading State (Skeleton) ──
                if (state.isInitialLoading) {
                  return _buildSkeletonSection(context);
                }

                // ── Connected / Has Data ──
                return _buildDataSection(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  // ── Section Builders ──
  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  /// Builds the error display with retry.
  Widget _buildErrorSection(BuildContext context, CryptoState state) {
    return AppErrorWidget(
      message: state.errorMessage ?? 'Unable to connect to market data.',
      onRetry: () => context.read<CryptoBloc>().add(const CryptoReconnectEvent()),
    );
  }

  /// Builds the skeleton loading placeholder.
  Widget _buildSkeletonSection(BuildContext context) {
    final theme = Theme.of(context);

    return Skeletonizer(
      enabled: true,
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          children: [
            // Skeleton price card.
            Container(
              margin: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.xs,
              ),
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: AppRadius.circularLg,
                border: Border.all(color: theme.colorScheme.outlineVariant),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.15),
                          borderRadius: AppRadius.circularMd,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'BTC',
                            style: AppTextStyles.headlineSmall,
                          ),
                          Text(
                            'BTC/USDT',
                            style: AppTextStyles.bodySmall,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    '\$00,000.00',
                    style: AppTextStyles.displayLarge.copyWith(fontSize: 36),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Qty: 0.000000',
                        style: AppTextStyles.bodySmall,
                      ),
                      Text(
                        '00:00:00',
                        style: AppTextStyles.bodySmall,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.md),

            // Skeleton trade list header.
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Recent Trades',
                    style: AppTextStyles.titleLarge,
                  ),
                  Text('0 trades', style: AppTextStyles.bodySmall),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.xs),

            // Skeleton trade items.
            ...List.generate(
              6,
              (index) => Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.08),
                        borderRadius: AppRadius.circularXs,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      flex: 3,
                      child: Text(
                        '\$00,000.00',
                        style: AppTextStyles.titleMedium,
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        '0.000000',
                        style: AppTextStyles.bodySmall,
                        textAlign: TextAlign.right,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      '00:00:00.000',
                      style: AppTextStyles.labelSmall,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the main data section with price card and trades list.
  Widget _buildDataSection(BuildContext context) {
    return CustomScrollView(
      slivers: [
        // ── Price Card ──
        SliverToBoxAdapter(
          child: BlocSelector<CryptoBloc, CryptoState, PriceCardData>(
            selector: (state) => PriceCardData(
              state.currentTrade,
              state.previousPrice,
            ),
            builder: (context, data) {
              debugPrint('Price rebuild');
              final trade = data.trade;
              if (trade == null) {
                return const SizedBox.shrink();
              }

              return CryptoPriceCard(
                currentTrade: trade,
                previousPrice: data.previousPrice,
              );
            },
          ),
        ),

        // ── Connection Warning Banner ──
        SliverToBoxAdapter(
          child: BlocSelector<CryptoBloc, CryptoState, ConnectionWarningState>(
            selector: (state) => ConnectionWarningState(
              hasFailed: state.hasFailed,
              hasData: state.currentTrade != null,
            ),
            builder: (context, data) {
              debugPrint('Status rebuild');
              if (data.hasFailed && data.hasData) {
                return _buildConnectionWarning(context);
              }
              return const SizedBox.shrink();
            },
          ),
        ),

        // ── Trades List Header ──
        SliverToBoxAdapter(
          child: BlocSelector<CryptoBloc, CryptoState, int>(
            selector: (state) => state.recentTrades.length,
            builder: (context, tradesCount) {
              return _buildTradesHeader(context, tradesCount);
            },
          ),
        ),

        // ── Column Headers ──
        SliverToBoxAdapter(
          child: _buildColumnHeaders(context),
        ),

        // ── Trades List ──
        BlocSelector<CryptoBloc, CryptoState, List<CryptoPriceModel>>(
          selector: (state) => state.recentTrades,
          builder: (context, recentTrades) {
            debugPrint('TradeList rebuild');
            if (recentTrades.isEmpty) {
              return SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.xxl),
                  child: Center(
                    child: Text(
                      'Waiting for trades...',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ),
              );
            }

            return SliverList.builder(
              itemCount: recentTrades.length,
              itemBuilder: (context, index) {
                final trade = recentTrades[index];
                final isLast = index == recentTrades.length - 1;
                final theme = Theme.of(context);

                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    border: Border(
                      left: BorderSide(
                        color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
                      ),
                      right: BorderSide(
                        color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
                      ),
                      bottom: isLast
                          ? BorderSide(
                              color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
                            )
                          : BorderSide.none,
                    ),
                    borderRadius: isLast
                        ? const BorderRadius.only(
                            bottomLeft: Radius.circular(AppRadius.sm),
                            bottomRight: Radius.circular(AppRadius.sm),
                          )
                        : BorderRadius.zero,
                  ),
                  clipBehavior: isLast ? Clip.antiAlias : Clip.none,
                  child: CryptoTradeTile(
                    key: ValueKey('${trade.tradeTime.millisecondsSinceEpoch}_${trade.price}'),
                    trade: trade,
                    index: index,
                  ),
                );
              },
            );
          },
        ),

        // ── Bottom Padding for Floating NavBar ──
        const SliverToBoxAdapter(
          child: SizedBox(height: 100),
        ),
      ],
    );
  }

  /// Builds a warning banner when connection is lost but data still exists.
  Widget _buildConnectionWarning(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: AppColors.warning.withValues(alpha: 0.12),
        borderRadius: AppRadius.circularSm,
      ),
      child: Row(
        children: [
          const Icon(
            Icons.wifi_off_rounded,
            size: 18,
            color: AppColors.warning,
          ),
          const SizedBox(width: AppSpacing.xs),
          Expanded(
            child: Text(
              'Connection lost. Showing last known data.',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.warning,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              context.read<CryptoBloc>().add(const CryptoReconnectEvent());
            },
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              'Retry',
              style: AppTextStyles.labelMedium.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the "Recent Trades" section header with trade count.
  Widget _buildTradesHeader(BuildContext context, int tradesCount) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.xxs,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Recent Trades',
            style: AppTextStyles.titleLarge.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          Text(
            '$tradesCount trades',
            style: AppTextStyles.bodySmall.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the column header row for the trades table.
  Widget _buildColumnHeaders(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.onSurface.withValues(alpha: 0.04),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(AppRadius.sm),
          topRight: Radius.circular(AppRadius.sm),
        ),
      ),
      child: Row(
        children: [
          const SizedBox(width: 28 + AppSpacing.sm),
          Expanded(
            flex: 3,
            child: Text(
              'Price (USDT)',
              style: AppTextStyles.labelSmall.copyWith(
                color: theme.colorScheme.outline,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'Quantity',
              textAlign: TextAlign.center,
              style: AppTextStyles.labelSmall.copyWith(
                color: theme.colorScheme.outline,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              'Time',
              textAlign: TextAlign.center,
              style: AppTextStyles.labelSmall.copyWith(
                color: theme.colorScheme.outline,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Helper class for selecting and comparing price card state in [BlocSelector].
@immutable
class PriceCardData extends Equatable {
  /// The current trade data.
  final CryptoPriceModel? trade;

  /// The previous trade price.
  final double? previousPrice;

  /// Creates a [PriceCardData].
  const PriceCardData(this.trade, this.previousPrice);

  @override
  List<Object?> get props => [trade?.price, previousPrice];
}

/// Helper class for selecting and comparing connection warning banner state in [BlocSelector].
@immutable
class ConnectionWarningState extends Equatable {
  /// Whether the last connection attempt or stream failed.
  final bool hasFailed;

  /// Whether we have active trade data.
  final bool hasData;

  /// Creates a [ConnectionWarningState].
  const ConnectionWarningState({
    required this.hasFailed,
    required this.hasData,
  });

  @override
  List<Object?> get props => [hasFailed, hasData];
}
