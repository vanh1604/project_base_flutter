import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Chỉ active khi chạy debug mode.
/// In ra toàn bộ request/response để dễ debug.
class AppLogInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('┌── REQUEST ──────────────────────────');
      debugPrint('│ ${options.method} ${options.uri}');
      debugPrint('│ Headers: ${options.headers}');
      if (options.data != null) {
        debugPrint('│ Body: ${options.data}');
      }
      debugPrint('└─────────────────────────────────────');
    }
    // QUAN TRỌNG: phải gọi handler.next() để request tiếp tục đi
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('┌── RESPONSE ─────────────────────────');
      debugPrint('│ ${response.statusCode} ${response.requestOptions.uri}');
      debugPrint('│ Data: ${response.data}');
      debugPrint('└─────────────────────────────────────');
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('┌── ERROR ────────────────────────────');
      debugPrint('│ ${err.response?.statusCode} ${err.requestOptions.uri}');
      debugPrint('│ Message: ${err.message}');
      debugPrint('└─────────────────────────────────────');
    }
    handler.next(err);
  }
}
