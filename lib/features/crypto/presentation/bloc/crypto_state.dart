part of 'crypto_bloc.dart';

/// State for the [CryptoBloc].
///
/// Uses a single-class pattern with status flags, matching the project's
/// [SpacexState] convention. All fields are immutable and compared via
/// [Equatable].
class CryptoState extends Equatable {
  /// Whether the WebSocket is currently connecting.
  final bool isConnecting;

  /// Whether the WebSocket is connected and streaming.
  final bool isConnected;

  /// Whether the last connection attempt or stream encountered a failure.
  final bool hasFailed;

  /// Error message from the last failure, if any.
  final String? errorMessage;

  /// The currently selected trading pair symbol (e.g. "btcusdt").
  final String currentSymbol;

  /// The most recent trade received from the stream.
  final CryptoPriceModel? currentTrade;

  /// List of the most recent trades (max 20), newest first.
  final List<CryptoPriceModel> recentTrades;

  /// The price from the trade before [currentTrade], used for
  /// determining the price change direction indicator.
  final double? previousPrice;

  /// Creates a [CryptoState].
  const CryptoState({
    this.isConnecting = false,
    this.isConnected = false,
    this.hasFailed = false,
    this.errorMessage,
    this.currentSymbol = 'btcusdt',
    this.currentTrade,
    this.recentTrades = const [],
    this.previousPrice,
  });

  /// Creates a copy of this state with the given fields replaced.
  CryptoState copyWith({
    bool? isConnecting,
    bool? isConnected,
    bool? hasFailed,
    String? errorMessage,
    String? currentSymbol,
    CryptoPriceModel? currentTrade,
    List<CryptoPriceModel>? recentTrades,
    double? previousPrice,
  }) {
    return CryptoState(
      isConnecting: isConnecting ?? this.isConnecting,
      isConnected: isConnected ?? this.isConnected,
      hasFailed: hasFailed ?? this.hasFailed,
      errorMessage: errorMessage ?? this.errorMessage,
      currentSymbol: currentSymbol ?? this.currentSymbol,
      currentTrade: currentTrade ?? this.currentTrade,
      recentTrades: recentTrades != null ? List<CryptoPriceModel>.unmodifiable(recentTrades) : this.recentTrades,
      previousPrice: previousPrice ?? this.previousPrice,
    );
  }

  /// Whether this is the initial loading state (connecting, no data yet).
  bool get isInitialLoading => isConnecting && currentTrade == null;

  @override
  List<Object?> get props => [
        isConnecting,
        isConnected,
        hasFailed,
        errorMessage,
        currentSymbol,
        currentTrade,
        recentTrades,
        previousPrice,
      ];
}
