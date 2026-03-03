import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:project_base_flutter_handle/src/features/auth/presentation/controllers/login_controller.dart';
import 'package:project_base_flutter_handle/src/features/auth/presentation/screens/login_screen.dart';
import 'package:project_base_flutter_handle/src/features/home/presentation/screens/detail_screen.dart';
import 'package:project_base_flutter_handle/src/features/home/presentation/screens/home_screen.dart';
import 'package:project_base_flutter_handle/src/features/settings/presentation/screens/setting_detail_screen.dart';
import 'package:project_base_flutter_handle/src/features/settings/presentation/screens/setting_screen.dart';
import 'package:project_base_flutter_handle/src/routing/router_notifier.dart';
import 'package:project_base_flutter_handle/src/utils/scaffold_with_nested_navigation.dart';

part 'app_router.g.dart';

enum AppRoute { home, settings, login }

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorHomeKey = GlobalKey<NavigatorState>(
  debugLabel: 'HomeShell',
);
final _shellNavigatorSettingKey = GlobalKey<NavigatorState>(
  debugLabel: 'SettingShell',
);

@Riverpod(keepAlive: true)
GoRouter goRouter(Ref ref) {
  final notifier = ref.watch(routerProvider);
  return GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: false,
    navigatorKey: _rootNavigatorKey,
    // GoRouter lắng nghe RouterNotifier, tự re-evaluate redirect khi auth thay đổi
    refreshListenable: notifier,
    redirect: (context, state) {
      final authState = ref.read(loginControllerProvider);
      final path = state.uri.path;

      // Đang kiểm tra token (app mới khởi động) → giữ ở login tạm thời
      if (authState.isLoading) return '/login';

      final isLoggedIn = authState.maybeWhen(
        data: (user) => user != null,
        orElse: () => false,
      );

      // Chưa đăng nhập hoặc token hết hạn → đá về login
      if (!isLoggedIn && path != '/login') return '/login';

      // Đã đăng nhập mà đang ở login → về home
      if (isLoggedIn && path == '/login') return '/';

      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => LoginScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return ScaffoldWithNestedNavigation(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            navigatorKey: _shellNavigatorHomeKey,
            routes: [
              GoRoute(
                path: '/',
                name: AppRoute.home.name,
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: HomeScreen()),
                routes: [
                  GoRoute(
                    path: 'details',
                    builder: (context, state) => const DetailScreen(),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _shellNavigatorSettingKey,
            routes: [
              GoRoute(
                path: '/settings',
                name: AppRoute.settings.name,
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: SettingScreen()),
                routes: [
                  GoRoute(
                    path: 'details',
                    builder: (context, state) => const SettingDetailScreen(),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
