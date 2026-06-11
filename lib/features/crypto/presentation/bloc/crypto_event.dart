part of 'crypto_bloc.dart';

/// Events for the [CryptoBloc].
///
/// Defines all user-initiated and stream-driven events that drive
/// cryptocurrency state transitions.
@immutable
abstract class CryptoEvent {
  /// Creates a [CryptoEvent].
  const CryptoEvent();
}

/// Requests connection to a cryptocurrency trade stream.
///
/// The [symbol] should be the lowercase pair name (e.g. "btcusdt").
class CryptoConnectEvent extends CryptoEvent {
  /// The trading pair symbol to connect to.
  final String symbol;

  /// Creates a [CryptoConnectEvent].
  const CryptoConnectEvent(this.symbol);
}

/// Internal event emitted when a new trade is received from the stream.
///
/// Should only be dispatched from within the [CryptoBloc] itself,
/// never from the UI layer.
class CryptoTradeReceivedEvent extends CryptoEvent {
  /// The parsed trade data.
  final CryptoPriceModel trade;

  /// Creates a [CryptoTradeReceivedEvent].
  const CryptoTradeReceivedEvent(this.trade);
}

/// Requests disconnection from the current trade stream.
class CryptoDisconnectEvent extends CryptoEvent {
  /// Creates a [CryptoDisconnectEvent].
  const CryptoDisconnectEvent();
}

/// Requests a reconnection attempt after a failure.
class CryptoReconnectEvent extends CryptoEvent {
  /// Creates a [CryptoReconnectEvent].
  const CryptoReconnectEvent();
}

/// Internal event emitted when the stream encounters an error.
class CryptoErrorEvent extends CryptoEvent {
  /// The error message.
  final String message;

  /// Creates a [CryptoErrorEvent].
  const CryptoErrorEvent(this.message);
}
