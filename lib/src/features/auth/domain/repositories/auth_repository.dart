import 'package:project_base_flutter_handle/src/features/auth/domain/entities/user.dart';

/// Hợp đồng (contract) giữa domain và data layer.
/// Domain chỉ biết interface này, không biết Dio hay bất kỳ thư viện nào.
abstract interface class AuthRepository {
  /// Đăng nhập, trả về thông tin User nếu thành công.
  /// Ném Exception nếu thất bại.
  Future<User> login({required String email, required String password});

  /// Đăng xuất, xóa token khỏi storage.
  Future<void> logout();

  /// Lấy thông tin user hiện tại đang đăng nhập.
  /// Trả về null nếu chưa đăng nhập.
  Future<User?> getCurrentUser();
}
