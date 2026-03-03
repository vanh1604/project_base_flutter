// Chỉ chứa path — baseUrl do Dio BaseOptions quản lý.
// Tách biệt path khỏi baseUrl để tránh so sánh sai trong interceptor.
class ApiEndpoints {
  ApiEndpoints._();

  static const String login = '/api/signin';
  static const String register = '/api/signup';
  static const String logout = '/api/logout';
  static const String refresh = '/api/refresh';
  static const String me = '/users/me';
}
