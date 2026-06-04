import 'package:dio/dio.dart';
import 'package:flutter_bloc_architecture/core/utils/app_logger.dart';

/// Dio interceptor for structured request/response logging.
///
/// Logs request details, response summaries, and errors using [AppLogger]
/// for debugging and monitoring purposes.
class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    AppLogger.info(
      '┌── REQUEST ──────────────────────────────\n'
      '│ ${options.method} ${options.uri}\n'
      '│ Headers: ${options.headers}\n'
      '│ Body: ${options.data}\n'
      '└────────────────────────────────────────',
    );

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    AppLogger.info(
      '┌── RESPONSE ─────────────────────────────\n'
      '│ ${response.statusCode} ${response.requestOptions.uri}\n'
      '└────────────────────────────────────────',
    );

    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    AppLogger.error(
      '┌── ERROR ────────────────────────────────\n'
      '│ ${err.response?.statusCode} ${err.requestOptions.uri}\n'
      '│ ${err.message}\n'
      '└────────────────────────────────────────',
    );

    handler.next(err);
  }
}
