import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:project_base_flutter_handle/src/features/auth/application/auth_service.dart';
import 'package:project_base_flutter_handle/src/features/auth/domain/entities/user.dart';

part 'login_controller.g.dart';

/// `AsyncNotifier<User?>` nghĩa là:
/// - State kiểu `AsyncValue<User?>`
/// - AsyncLoading  → đang gọi API
/// - AsyncData     → login thành công, chứa User
/// - AsyncError    → login thất bại, chứa AppException
@Riverpod(keepAlive: true)
class LoginController extends _$LoginController {
  @override
  FutureOr<User?> build() {
    // Khi app khởi động, kiểm tra token đã lưu → tự động restore session
    return ref.watch(authStateProvider.future);
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    state = const AsyncLoading();

    // Gọi qua AuthService (Application layer) — không gọi repository trực tiếp
    state = await AsyncValue.guard(() {
      return ref.read(authServiceProvider).signIn(
            email: email,
            password: password,
          );
    });
  }

  Future<void> logout() async {
    await ref.read(authServiceProvider).signOut();
    state = const AsyncData(null);
  }
}
