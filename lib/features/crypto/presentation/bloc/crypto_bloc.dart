import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_bloc_architecture/core/utils/app_logger.dart';
import 'package:flutter_bloc_architecture/features/crypto/data/models/crypto_price_model.dart';
import 'package:flutter_bloc_architecture/features/crypto/domain/repositories/crypto_repository.dart';
import 'package:stream_transform/stream_transform.dart';

part 'crypto_event.dart';

part 'crypto_state.dart';

/// BLoC for managing real-time cryptocurrency trade data.
///
/// Coordinates between the [CryptoRepository] (WebSocket data source)
/// and the UI layer. Handles connection lifecycle, trade stream
/// subscriptions, and state transitions.
///
/// No business logic lives in the UI — this BLoC is the single
/// source of truth for crypto dashboard state.
class CryptoBloc extends Bloc<CryptoEvent, CryptoState> {
  /// The cryptocurrency repository instance.
  final CryptoRepository repository;

  /// Subscription to the repository's trade stream.
  StreamSubscription<CryptoPriceModel>? _tradeSubscription;

  /// Creates a [CryptoBloc] and registers all event handlers.
  CryptoBloc(this.repository) : super(const CryptoState()) {
    on<CryptoConnectEvent>(_onConnect, transformer: restartable());
    on<CryptoTradeReceivedEvent>(_onTradeReceived);
    on<CryptoDisconnectEvent>(_onDisconnect);
    on<CryptoReconnectEvent>(_onReconnect);
    on<CryptoErrorEvent>(_onError);
  }

  /// Handles [CryptoConnectEvent] — starts or switches the WebSocket stream.
  ///
  /// Disposes any previous connection, connects using the repository,
  /// and subscribes to the trade stream.
  Future<void> _onConnect(CryptoConnectEvent event, Emitter<CryptoState> emit) async {
    // Cancel previous subscription.
    await _tradeSubscription?.cancel();
    _tradeSubscription = null;

    emit(
      CryptoState(
        isConnecting: true,
        currentSymbol: event.symbol,
      ),
    );

    try {
      repository.connect(event.symbol);

      _tradeSubscription = repository.tradeStream.throttle(const Duration(milliseconds: 500)).distinct((a, b) => a.price == b.price).listen(
        (trade) => add(CryptoTradeReceivedEvent(trade)),
        onError: (Object error) {
          add(CryptoErrorEvent(error is Exception ? error.toString() : 'Connection error occurred'));
        },
      );
    } on Exception catch (e) {
      if (kDebugMode) {
        AppLogger.error('❌ CryptoBloc: Failed to connect', error: e);
      }
      emit(
        state.copyWith(
          isConnecting: false,
          hasFailed: true,
          errorMessage: 'Failed to connect. Please try again.',
        ),
      );
    }
  }

  /// Handles [CryptoTradeReceivedEvent] — updates state with new trade data.
  ///
  /// Prepends the new trade to [CryptoState.recentTrades] (capped at 20)
  /// and updates [CryptoState.previousPrice] for the change indicator.
  void _onTradeReceived(CryptoTradeReceivedEvent event, Emitter<CryptoState> emit) {
    if (state.currentTrade?.price == event.trade.price) return;

    final trades = List<CryptoPriceModel>.from(
      state.recentTrades,
    )..insert(0, event.trade);

    if (trades.length > 20) {
      trades.removeLast();
    }

    emit(
      state.copyWith(
        isConnecting: false,
        isConnected: true,
        hasFailed: false,
        errorMessage: null,
        currentTrade: event.trade,
        recentTrades: trades,
        previousPrice: state.currentTrade?.price,
      ),
    );
  }

  /// Handles [CryptoDisconnectEvent] — cleanly shuts down the connection.
  Future<void> _onDisconnect(CryptoDisconnectEvent event, Emitter<CryptoState> emit) async {
    await _tradeSubscription?.cancel();
    _tradeSubscription = null;
    repository.dispose();

    emit(const CryptoState());
  }

  /// Handles [CryptoReconnectEvent] — retries the connection.
  Future<void> _onReconnect(CryptoReconnectEvent event, Emitter<CryptoState> emit) async {
    final symbol = state.currentSymbol;
    add(CryptoConnectEvent(symbol));
  }

  /// Handles [CryptoErrorEvent] — updates state with error information.
  void _onError(CryptoErrorEvent event, Emitter<CryptoState> emit) {
    emit(
      state.copyWith(
        isConnecting: false,
        isConnected: false,
        hasFailed: true,
        errorMessage: event.message,
      ),
    );
  }

  @override
  Future<void> close() async {
    await _tradeSubscription?.cancel();
    _tradeSubscription = null;
    repository.dispose();
    return super.close();
  }
}
