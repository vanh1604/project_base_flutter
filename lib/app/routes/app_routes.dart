/// App Routes - Route Constants
///
/// Định nghĩa tên routes constant cho toàn bộ app.
/// Sử dụng constants giúp tránh typo và dễ refactor.
///
/// Location: app/routes/
class AppRoutes {
  // Prevent instantiation
  AppRoutes._();

  // Root routes
  static const String splash = '/';
  static const String home = '/home';

  // Books feature routes
  static const String bookList = '/books';
  static const String bookDetails = '/books/details';
  static const String dashboard = '/dashboard';
}
