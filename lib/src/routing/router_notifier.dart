import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:project_base_flutter_handle/src/features/auth/domain/entities/user.dart';
import 'package:project_base_flutter_handle/src/features/auth/presentation/controllers/login_controller.dart';

part 'router_notifier.g.dart';

/// Cầu nối giữa Riverpod và GoRouter.
/// Khi [loginControllerProvider] thay đổi (login / logout / startup),
/// GoRouter nhận tín hiệu qua [refreshListenable] và tự re-evaluate redirect.
class RouterNotifier extends ChangeNotifier {
  RouterNotifier(Ref ref) {
    ref.listen<AsyncValue<User?>>(
      loginControllerProvider,
      (_, _) => notifyListeners(),
    );
  }
}

@Riverpod(keepAlive: true)
RouterNotifier routerNotifier(Ref ref) => RouterNotifier(ref);
