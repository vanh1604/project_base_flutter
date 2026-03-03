/// Typed exceptions cho toàn bộ app.
/// Dùng sealed class để Presentation layer có thể switch trên type,
/// thay vì dùng generic Exception và parse toString().
sealed class AppException implements Exception {
  const AppException(this.message);

  final String message;

  @override
  String toString() => message;
}

/// 401 — sai email hoặc mật khẩu
class InvalidCredentialsException extends AppException {
  const InvalidCredentialsException()
      : super('Email hoặc mật khẩu không đúng');
}

/// 403 — tài khoản bị khóa / không có quyền
class AccountSuspendedException extends AppException {
  const AccountSuspendedException() : super('Tài khoản bị khóa');
}

/// 404 — không tìm thấy tài khoản
class NotFoundException extends AppException {
  const NotFoundException() : super('Tài khoản không tồn tại');
}

/// 500 — lỗi phía server
class ServerException extends AppException {
  const ServerException() : super('Lỗi server, vui lòng thử lại');
}

/// Phiên đăng nhập hết hạn (refresh token cũng hết)
class SessionExpiredException extends AppException {
  const SessionExpiredException() : super('Phiên đăng nhập hết hạn');
}

/// Lỗi mạng / không xác định
class NetworkException extends AppException {
  const NetworkException([String? detail])
      : super(detail ?? 'Lỗi kết nối mạng');
}
