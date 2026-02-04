import 'package:flutter/material.dart';
import '../../features/books/domain/entities/book_entity.dart';
import '../../features/books/presentation/pages/book_details_screen.dart';
import 'app_routes.dart';

/// App Router - Centralized Navigation Configuration
///
/// Quản lý routing trung tâm cho toàn bộ app.
/// Sử dụng named routes với MaterialPageRoute.
///
/// Location: app/routes/
class AppRouter {
  /// Generate route based on RouteSettings
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.bookDetails:
        // Extract book argument
        final book = settings.arguments as BookEntity?;
        if (book == null) {
          return _errorRoute('Book argument is required');
        }
        return MaterialPageRoute(
          builder: (_) => BookDetailsScreen(book: book),
          settings: settings,
        );

      // Add more routes here as needed
      // case AppRoutes.dashboard:
      //   return MaterialPageRoute(builder: (_) => DashboardScreen());

      default:
        return _errorRoute('Route not found: ${settings.name}');
    }
  }

  /// Error route when route not found
  static Route<dynamic> _errorRoute(String message) {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: Center(
          child: Text(message),
        ),
      ),
    );
  }
}
