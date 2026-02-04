import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'routes/app_router.dart';

/// Root App Widget - Material App Configuration
///
/// Root widget của toàn bộ app.
/// Cấu hình theme, routing, và các global settings.
///
/// Location: app/
class App extends StatelessWidget {
  final Widget home;

  const App({
    super.key,
    required this.home,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stephen King Books',
      debugShowCheckedModeBanner: false,

      // Theme
      theme: AppTheme.lightTheme,
      // darkTheme: AppTheme.darkTheme, // TODO: Implement dark theme

      // Routing
      onGenerateRoute: AppRouter.generateRoute,

      // Home screen
      home: home,
    );
  }
}
