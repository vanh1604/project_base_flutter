import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:project_base_flutter_handle/src/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:project_base_flutter_handle/src/features/auth/domain/entities/user.dart';
import 'package:project_base_flutter_handle/src/features/auth/domain/repositories/auth_repository.dart';

part 'auth_service.g.dart';

/// Application layer — điều phối giữa Presentation và Domain.
/// Đây là nơi thêm analytics, permission check, caching sau này
/// mà không cần chạm vào Controller hay Repository.
class AuthService {
  const AuthService(this._repository);

  final AuthRepository _repository;

  Future<User?> getCurrentUser() => _repository.getCurrentUser();

  Future<User> signIn({
    required String email,
    required String password,
  }) =>
      _repository.login(email: email, password: password);

  Future<void> signOut() => _repository.logout();
}

/// Application layer — Presentation chỉ giao tiếp qua đây.
@riverpod
AuthService authService(Ref ref) =>
    AuthService(ref.watch(authRepositoryProvider));

/// Trạng thái xác thực hiện tại.
/// Trả về User nếu đã đăng nhập, null nếu chưa / token hết hạn.
@riverpod
Future<User?> authState(Ref ref) =>
    ref.watch(authServiceProvider).getCurrentUser();
