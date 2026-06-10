import 'package:equatable/equatable.dart';

/// Model representing a single cryptocurrency trade from Binance WebSocket.
///
/// Maps the Binance `@trade` stream JSON payload to strongly-typed fields.
/// Uses [Equatable] for value-based equality comparisons in BLoC state.
///
/// Example Binance payload:
/// ```json
/// {
///   "s": "BTCUSDT",
///   "p": "50000.00",
///   "q": "0.001",
///   "T": 1625000000000
/// }
/// ```
class CryptoPriceModel extends Equatable {
  /// The trading pair symbol (e.g. "BTCUSDT").
  final String symbol;

  /// The trade price in USDT.
  final double price;

  /// The trade quantity.
  final double quantity;

  /// The timestamp when the trade occurred.
  final DateTime tradeTime;

  /// Creates a [CryptoPriceModel].
  const CryptoPriceModel({
    required this.symbol,
    required this.price,
    required this.quantity,
    required this.tradeTime,
  });

  /// Creates a [CryptoPriceModel] from a Binance WebSocket JSON map.
  ///
  /// Safely parses all fields with fallback defaults to prevent crashes
  /// from malformed data. Returns `null` if critical fields are missing.
  static CryptoPriceModel? fromJson(Map<String, dynamic> json) {
    try {
      final symbol = json['s'] as String?;
      final priceStr = json['p'] as String?;
      final quantityStr = json['q'] as String?;
      final tradeTimeMs = json['T'] as int?;

      if (symbol == null || priceStr == null) return null;

      return CryptoPriceModel(
        symbol: symbol,
        price: double.tryParse(priceStr) ?? 0.0,
        quantity: double.tryParse(quantityStr ?? '0') ?? 0.0,
        tradeTime: tradeTimeMs != null
            ? DateTime.fromMillisecondsSinceEpoch(tradeTimeMs)
            : DateTime.now(),
      );
    } on Exception {
      return null;
    }
  }

  /// Returns a formatted display symbol (e.g. "BTC/USDT" from "BTCUSDT").
  String get displaySymbol {
    if (symbol.endsWith('USDT')) {
      return '${symbol.replaceAll('USDT', '')}/USDT';
    }
    return symbol;
  }

  /// Returns the base currency (e.g. "BTC" from "BTCUSDT").
  String get baseCurrency {
    if (symbol.endsWith('USDT')) {
      return symbol.replaceAll('USDT', '');
    }
    return symbol;
  }

  @override
  List<Object?> get props => [symbol, price, quantity, tradeTime];
}
