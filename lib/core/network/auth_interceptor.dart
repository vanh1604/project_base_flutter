import 'package:dio/dio.dart';

/// Authentication Interceptor
///
/// Handles:
/// - Adding auth tokens to requests
/// - Token refresh on 401 responses
/// - Logout on invalid tokens
class AuthInterceptor extends Interceptor {
  final Future<String?> Function() getAccessToken;
  final Future<String?> Function()? refreshToken;
  final Function()? onUnauthorized;

  AuthInterceptor({
    required this.getAccessToken,
    this.refreshToken,
    this.onUnauthorized,
  });

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Skip auth header for certain endpoints
    if (_shouldSkipAuth(options.path)) {
      return handler.next(options);
    }

    // Add access token to request
    final token = await getAccessToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    return handler.next(options);
  }

  @override
  void onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    // Handle 401 Unauthorized
    if (err.response?.statusCode == 401) {
      // Try to refresh token
      if (refreshToken != null) {
        try {
          final newToken = await refreshToken!();
          if (newToken != null) {
            // Retry the request with new token
            final options = err.requestOptions;
            options.headers['Authorization'] = 'Bearer $newToken';

            final response = await Dio().fetch(options);
            return handler.resolve(response);
          }
        } catch (e) {
          // Token refresh failed
          _handleUnauthorized();
          return handler.next(err);
        }
      }

      // No refresh token handler or refresh failed
      _handleUnauthorized();
    }

    return handler.next(err);
  }

  /// Check if auth should be skipped for this path
  bool _shouldSkipAuth(String path) {
    final skipPaths = [
      '/auth/login',
      '/auth/register',
      '/auth/refresh',
    ];

    return skipPaths.any((skipPath) => path.contains(skipPath));
  }

  /// Handle unauthorized access
  void _handleUnauthorized() {
    if (onUnauthorized != null) {
      onUnauthorized!();
    }
  }
}
