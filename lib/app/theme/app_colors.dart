import 'package:flutter/material.dart';

/// App Colors - Design System
///
/// Định nghĩa toàn bộ màu sắc sử dụng trong app.
/// Tuân theo Material Design 3 principles.
///
/// Location: app/theme/
class AppColors {
  // Primary Colors
  static const Color primaryColor = Color(0xFF673AB7); // Deep Purple
  static const Color primaryLight = Color(0xFF9575CD);
  static const Color primaryDark = Color(0xFF512DA8);

  // Secondary Colors
  static const Color secondaryColor = Color(0xFF3F51B5); // Indigo
  static const Color secondaryLight = Color(0xFF7986CB);
  static const Color secondaryDark = Color(0xFF303F9F);

  // Accent Colors
  static const Color accentBlue = Color(0xFF2196F3);
  static const Color accentTeal = Color(0xFF009688);
  static const Color accentGreen = Color(0xFF4CAF50);
  static const Color accentOrange = Color(0xFFFF9800);
  static const Color accentRed = Color(0xFFF44336);

  // Background Colors
  static const Color background = Color(0xFFFAFAFA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF5F5F5);

  // Text Colors
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textDisabled = Color(0xFFBDBDBD);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // State Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF2196F3);

  // Divider & Border
  static const Color divider = Color(0xFFE0E0E0);
  static const Color border = Color(0xFFE0E0E0);

  // Shadow
  static const Color shadow = Color(0x1F000000);

  /// Year-based color mapping cho book cards
  static Color getYearColor(int year) {
    final decade = (year / 10).floor() % 8;
    switch (decade) {
      case 0:
        return accentBlue;
      case 1:
        return accentTeal;
      case 2:
        return accentGreen;
      case 3:
        return primaryColor;
      case 4:
        return secondaryColor;
      case 5:
        return accentOrange;
      case 6:
        return accentRed;
      case 7:
        return primaryLight;
      default:
        return primaryColor;
    }
  }
}
