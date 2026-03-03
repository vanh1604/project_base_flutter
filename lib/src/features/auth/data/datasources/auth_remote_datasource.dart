import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:project_base_flutter_handle/src/core/api_endpoints.dart';
import 'package:project_base_flutter_handle/src/core/providers/core_providers.dart';
import 'package:project_base_flutter_handle/src/features/auth/data/models/login_response_model.dart';
import 'package:project_base_flutter_handle/src/features/auth/data/models/user_model.dart';

part 'auth_remote_datasource.g.dart';

/// Chỉ biết gọi HTTP và trả về raw model.
/// Không xử lý business logic, không biết Token Storage.
class AuthRemoteDatasource {
  AuthRemoteDatasource(this._dio);

  final Dio _dio;

  /// Gọi POST /api/signin
  /// Trả về [LoginResponseModel] chứa tokens + thông tin user
  Future<LoginResponseModel> login({
    required String email,
    required String password,
  }) async {
    final response = await _dio.post(
      ApiEndpoints.login,
      data: {'email': email, 'password': password},
    );
    return LoginResponseModel.fromJson(response.data as Map<String, dynamic>);
  }

  /// Gọi POST /api/logout
  Future<void> logout() async {
    await _dio.post(ApiEndpoints.logout);
  }

  /// Gọi GET /api/me — lấy thông tin user đang đăng nhập
  Future<UserModel> getProfile() async {
    final response = await _dio.get(ApiEndpoints.me);
    return UserModel.fromJson(response.data as Map<String, dynamic>);
  }
}

@riverpod
AuthRemoteDatasource authRemoteDatasource(Ref ref) =>
    AuthRemoteDatasource(ref.watch(dioProvider));
