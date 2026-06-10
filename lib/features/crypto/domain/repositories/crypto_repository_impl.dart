import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc_architecture/core/utils/app_logger.dart';
import 'package:flutter_bloc_architecture/features/crypto/data/models/crypto_price_model.dart';
import 'package:flutter_bloc_architecture/features/crypto/domain/repositories/crypto_repository.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

/// Binance WebSocket implementation of [CryptoRepository].
///
/// Connects to the Binance `@trade` stream and emits parsed
/// [CryptoPriceModel] objects through a broadcast [StreamController].
///
/// Features:
/// - Automatic reconnection with exponential backoff (max 5 retries).
/// - Safe JSON parsing — malformed messages are silently skipped.
/// - Full lifecycle logging in debug mode.
/// - Proper resource cleanup on [dispose].
class CryptoRepositoryImpl implements CryptoRepository {
  /// Base URL for the Binance WebSocket trade stream.
  static const String _baseWsUrl = 'wss://stream.binance.com:9443/ws';

  /// Maximum number of reconnection attempts before giving up.
  static const int _maxReconnectAttempts = 5;

  /// The active WebSocket channel.
  WebSocketChannel? _channel;

  /// Subscription to the WebSocket channel's stream.
  StreamSubscription<dynamic>? _channelSubscription;

  /// Broadcast controller for emitting parsed trade data.
  StreamController<CryptoPriceModel>? _tradeController;

  /// The currently connected symbol (e.g. "btcusdt").
  String? _currentSymbol;

  /// Whether the WebSocket is actively connected.
  bool _isConnected = false;

  /// Whether [dispose] has been called.
  bool _isDisposed = false;

  /// Whether a reconnection cycle is currently in progress.
  bool _isReconnecting = false;

  /// Current reconnection attempt count.
  int _reconnectAttempts = 0;

  /// Timer for reconnection delays.
  Timer? _reconnectTimer;

  /// Count of trades received (for logging).
  int _tradeCount = 0;

  @override
  Stream<CryptoPriceModel> get tradeStream {
    _tradeController ??= StreamController<CryptoPriceModel>.broadcast();
    return _tradeController!.stream;
  }

  @override
  bool get isConnected => _isConnected;

  @override
  void connect(String symbol) {
    _isDisposed = false;
    _isReconnecting = false;

    // Ensure _tradeController is active and initialized.
    if (_tradeController == null || _tradeController!.isClosed) {
      _tradeController = StreamController<CryptoPriceModel>.broadcast();
    }

    // Close existing connection before starting a new one.
    _closeCurrentConnection();

    _currentSymbol = symbol.toLowerCase();
    _reconnectAttempts = 0;
    _tradeCount = 0;

    _establishConnection();
  }

  /// Establishes the WebSocket connection and subscribes to messages.
  void _establishConnection() {
    if (_isDisposed || _currentSymbol == null) return;

    final wsUrl = '$_baseWsUrl/${_currentSymbol!}@trade';

    if (kDebugMode) {
      AppLogger.info('🔌 Crypto WS: Connecting to $wsUrl');
    }

    try {
      _channel = WebSocketChannel.connect(Uri.parse(wsUrl));

      _channelSubscription = _channel!.stream.listen(
        _onMessage,
        onError: _onError,
        onDone: _onDone,
        cancelOnError: false,
      );

      _isConnected = true;
      _reconnectAttempts = 0;
      _isReconnecting = false;

      if (kDebugMode) {
        AppLogger.info('✅ Crypto WS: Connection established');
      }
    } on Exception catch (e) {
      if (kDebugMode) {
        AppLogger.error('❌ Crypto WS: Connection failed', error: e);
      }
      _isConnected = false;
      _attemptReconnect();
    }
  }

  /// Handles an incoming WebSocket message.
  ///
  /// Parses the JSON payload into a [CryptoPriceModel] and emits it.
  /// Invalid messages are silently skipped with a debug warning.
  void _onMessage(dynamic message) {
    if (_isDisposed) return;

    try {
      final jsonData = jsonDecode(message as String) as Map<String, dynamic>;
      final trade = CryptoPriceModel.fromJson(jsonData);

      if (trade != null) {
        _tradeCount++;

        _tradeController?.add(trade);

        if (kDebugMode && _tradeCount % 50 == 0) {
          AppLogger.debug(
            '📊 Crypto WS: $_tradeCount trades received | '
            '${trade.baseCurrency}: \$${trade.price.toStringAsFixed(2)}',
          );
        }
      } else {
        if (kDebugMode) {
          AppLogger.warning('⚠️ Crypto WS: Skipped invalid trade payload');
        }
      }
    } on FormatException {
      if (kDebugMode) {
        AppLogger.warning('⚠️ Crypto WS: Invalid JSON received');
      }
    } on Exception catch (e) {
      if (kDebugMode) {
        AppLogger.warning('⚠️ Crypto WS: Message parse error: $e');
      }
    }
  }

  /// Handles a WebSocket error.
  void _onError(Object error) {
    if (_isDisposed) return;

    if (kDebugMode) {
      AppLogger.error('❌ Crypto WS: Stream error', error: error);
    }

    _isConnected = false;

    final controller = _tradeController;
    if (controller != null && !controller.isClosed) {
      controller.addError(error);
    }

    _attemptReconnect();
  }

  /// Handles WebSocket stream completion (disconnect).
  void _onDone() {
    if (_isDisposed) return;

    if (kDebugMode) {
      AppLogger.info('🔒 Crypto WS: Connection closed');
    }

    _isConnected = false;
    _attemptReconnect();
  }

  /// Attempts to reconnect with exponential backoff.
  ///
  /// Delays: 1s, 2s, 4s, 8s, 16s — then gives up after [_maxReconnectAttempts].
  void _attemptReconnect() {
    if (_isDisposed || _currentSymbol == null) return;
    if (_isReconnecting) {
      if (kDebugMode) {
        AppLogger.info('🔄 Crypto WS: Reconnect already in progress, ignoring duplicate trigger.');
      }
      return;
    }
    if (_reconnectAttempts >= _maxReconnectAttempts) {
      if (kDebugMode) {
        AppLogger.error(
          '❌ Crypto WS: Max reconnect attempts ($_maxReconnectAttempts) reached',
        );
      }

      final controller = _tradeController;
      if (controller != null && !controller.isClosed) {
        controller.addError(
          Exception('Unable to connect after $_maxReconnectAttempts attempts'),
        );
      }
      return;
    }

    _isReconnecting = true;
    _reconnectAttempts++;
    final delaySeconds = 1 << (_reconnectAttempts - 1); // Exponential backoff

    if (kDebugMode) {
      AppLogger.info(
        '🔄 Crypto WS: Reconnect attempt $_reconnectAttempts/$_maxReconnectAttempts '
        'in ${delaySeconds}s',
      );
    }

    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(
      Duration(seconds: delaySeconds),
      () {
        if (!_isDisposed) {
          _isReconnecting = false;
          _closeCurrentConnection();
          _establishConnection();
        }
      },
    );
  }

  /// Closes the current WebSocket connection without triggering reconnect.
  void _closeCurrentConnection() {
    _reconnectTimer?.cancel();
    _reconnectTimer = null;
    _channelSubscription?.cancel();
    _channelSubscription = null;
    _isReconnecting = false;

    try {
      _channel?.sink.close();
    } on Exception catch (_) {
      // Ignore close errors — the channel may already be closed.
    }

    _channel = null;
    _isConnected = false;
  }

  @override
  void dispose() {
    if (_isDisposed) return;
    _isDisposed = true;

    if (kDebugMode) {
      AppLogger.info(
        '🗑️ Crypto WS: Disposing (total trades: $_tradeCount)',
      );
    }

    _closeCurrentConnection();

    final controller = _tradeController;
    if (controller != null && !controller.isClosed) {
      controller.close();
    }
    _tradeController = null;
  }
}
