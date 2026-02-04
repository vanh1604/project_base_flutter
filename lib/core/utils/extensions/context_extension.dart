import 'package:flutter/material.dart';

/// BuildContext Extensions - Utility Extensions
///
/// Extension methods cho BuildContext để truy cập theme, mediaQuery, navigation dễ dàng.
///
/// Location: core/utils/extensions/
extension ContextExtension on BuildContext {
  /// Theme
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => theme.textTheme;
  ColorScheme get colorScheme => theme.colorScheme;

  /// Media Query
  MediaQueryData get mediaQuery => MediaQuery.of(this);
  Size get screenSize => mediaQuery.size;
  double get screenWidth => screenSize.width;
  double get screenHeight => screenSize.height;
  EdgeInsets get padding => mediaQuery.padding;
  EdgeInsets get viewInsets => mediaQuery.viewInsets;

  /// Screen breakpoints
  bool get isMobile => screenWidth < 600;
  bool get isTablet => screenWidth >= 600 && screenWidth < 1024;
  bool get isDesktop => screenWidth >= 1024;

  /// Navigation
  NavigatorState get navigator => Navigator.of(this);

  void pop<T>([T? result]) => navigator.pop(result);

  Future<T?> push<T>(Widget screen) {
    return navigator.push<T>(
      MaterialPageRoute(builder: (_) => screen),
    );
  }

  Future<T?> pushNamed<T>(String routeName, {Object? arguments}) {
    return navigator.pushNamed<T>(routeName, arguments: arguments);
  }

  Future<T?> pushReplacement<T, TO>(Widget screen, {TO? result}) {
    return navigator.pushReplacement<T, TO>(
      MaterialPageRoute(builder: (_) => screen),
      result: result,
    );
  }

  Future<T?> pushReplacementNamed<T, TO>(
    String routeName, {
    TO? result,
    Object? arguments,
  }) {
    return navigator.pushReplacementNamed<T, TO>(
      routeName,
      result: result,
      arguments: arguments,
    );
  }

  /// Dialogs & Snackbars
  void showSnackBar(
    String message, {
    Duration duration = const Duration(seconds: 3),
  }) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: duration,
      ),
    );
  }

  void showErrorSnackBar(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: colorScheme.error,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  Future<T?> showAlertDialog<T>({
    required String title,
    required String content,
    String confirmText = 'OK',
    String? cancelText,
  }) {
    return showDialog<T>(
      context: this,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          if (cancelText != null)
            TextButton(
              onPressed: () => context.pop(false),
              child: Text(cancelText),
            ),
          TextButton(
            onPressed: () => context.pop(true),
            child: Text(confirmText),
          ),
        ],
      ),
    );
  }
}
