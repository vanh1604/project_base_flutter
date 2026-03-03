import 'dart:async';
import 'package:dio/dio.dart';
import 'package:project_base_flutter_handle/src/core/api_endpoints.dart';
import 'package:project_base_flutter_handle/src/utils/token_storage.dart';

class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._dio, this._tokenStorage);

  final Dio _dio;
  final TokenStorage _tokenStorage;

  // ── Lock chống race condition ──────────────────────────────────
  // Khi đang refresh, các request 401 khác sẽ chờ Completer này
  bool _isRefreshing = false;
  Completer<String?>? _refreshCompleter;

  // ─────────────────────────────────────────────────────────────
  // BƯỚC 1: Trước khi gửi request → gắn access token vào header
  // ─────────────────────────────────────────────────────────────
  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final accessToken = await _tokenStorage.getAccessToken();

    if (accessToken != null) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }

    handler.next(options);
  }

  // ─────────────────────────────────────────────────────────────
  // BƯỚC 2: Khi nhận lỗi → kiểm tra có phải 401 không
  // ─────────────────────────────────────────────────────────────
  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    // Chỉ xử lý 401, còn lại cho đi qua
    if (err.response?.statusCode != 401) {
      return handler.next(err);
    }

    // Tránh vòng lặp vô tận: nếu chính request /refresh bị 401
    // thì logout luôn, không retry nữa.
    // So sánh path (e.g. '/api/refresh') với path constant — luôn đúng.
    if (err.requestOptions.path == ApiEndpoints.refresh) {
      await _logout(handler, err);
      return;
    }

    try {
      // Lấy access token mới (có cơ chế lock bên trong)
      final newAccessToken = await _getNewAccessToken();

      if (newAccessToken == null) {
        // Refresh token cũng hết hạn → logout
        await _logout(handler, err);
        return;
      }

      // Retry lại request gốc với token mới
      final retryResponse = await _retry(err.requestOptions, newAccessToken);
      handler.resolve(retryResponse);
    } catch (_) {
      await _logout(handler, err);
    }
  }

  // ─────────────────────────────────────────────────────────────
  // Lấy access token mới, có lock để tránh gọi refresh nhiều lần
  // ─────────────────────────────────────────────────────────────
  Future<String?> _getNewAccessToken() async {
    // Nếu đang có request khác đang refresh → chờ kết quả của nó
    if (_isRefreshing) {
      return _refreshCompleter!.future;
    }

    // Chưa có ai refresh → mình sẽ làm, dựng lock lên
    _isRefreshing = true;
    _refreshCompleter = Completer<String?>();

    try {
      final refreshToken = await _tokenStorage.getRefreshToken();

      if (refreshToken == null) {
        _refreshCompleter!.complete(null);
        return null;
      }

      // Gọi API refresh (dùng _dio trực tiếp để bypass interceptor)
      final response = await _dio.post(
        ApiEndpoints.refresh,
        data: {'refresh_token': refreshToken},
        options: Options(
          extra: {'skipAuthInterceptor': true},
        ),
      );

      final newAccessToken = response.data['access_token'] as String;
      final newRefreshToken = response.data['refresh_token'] as String?;

      // Lưu token mới vào storage
      await _tokenStorage.saveAccessToken(newAccessToken);
      if (newRefreshToken != null) {
        await _tokenStorage.saveRefreshToken(newRefreshToken);
      }

      // Thông báo cho các request đang chờ: "có token mới rồi"
      _refreshCompleter!.complete(newAccessToken);
      return newAccessToken;
    } catch (_) {
      _refreshCompleter!.complete(null);
      return null;
    } finally {
      // Dù thành công hay thất bại, mở lock ra
      _isRefreshing = false;
      _refreshCompleter = null;
    }
  }

  // ─────────────────────────────────────────────────────────────
  // Gửi lại request gốc với token mới
  // ─────────────────────────────────────────────────────────────
  Future<Response> _retry(RequestOptions options, String newToken) {
    return _dio.request(
      options.path,
      data: options.data,
      queryParameters: options.queryParameters,
      options: Options(
        method: options.method,
        headers: {...options.headers, 'Authorization': 'Bearer $newToken'},
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // Xóa token và ném lỗi để app navigate về Login
  // ─────────────────────────────────────────────────────────────
  Future<void> _logout(ErrorInterceptorHandler handler, DioException err) async {
    await _tokenStorage.clear();
    handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        response: err.response,
        type: DioExceptionType.badResponse,
        error: 'Session expired. Please login again.',
      ),
    );
  }
}
