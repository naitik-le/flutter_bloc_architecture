import 'package:flutter_bloc_architecture/features/crypto/data/models/crypto_price_model.dart';

/// Abstract contract for cryptocurrency real-time data operations.
///
/// Defines the interface for WebSocket-based trade streaming.
/// Implementations must handle connection lifecycle, reconnection,
/// error handling, and resource cleanup.
abstract class CryptoRepository {
  /// Opens a WebSocket connection for the given trading pair [symbol].
  ///
  /// The [symbol] should be lowercase (e.g. "btcusdt").
  /// If a connection already exists, it should be closed first.
  void connect(String symbol);

  /// A broadcast stream of incoming [CryptoPriceModel] trade events.
  ///
  /// Emits parsed trade data from the Binance WebSocket.
  /// Returns an empty stream if not yet connected.
  Stream<CryptoPriceModel> get tradeStream;

  /// Whether the WebSocket is currently connected and streaming.
  bool get isConnected;

  /// Closes the WebSocket connection and releases all resources.
  ///
  /// Must be called when the repository is no longer needed to prevent
  /// memory leaks.
  void dispose();
}
