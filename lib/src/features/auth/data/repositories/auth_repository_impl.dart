import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:project_base_flutter_handle/src/core/exceptions/app_exception.dart';
import 'package:project_base_flutter_handle/src/core/providers/core_providers.dart';
import 'package:project_base_flutter_handle/src/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:project_base_flutter_handle/src/features/auth/domain/entities/user.dart';
import 'package:project_base_flutter_handle/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:project_base_flutter_handle/src/utils/token_storage.dart';

part 'auth_repository_impl.g.dart';

/// Thực thi hợp đồng AuthRepository.
/// Tầng này biết cả datasource lẫn token storage.
/// Trả về domain entity (User), không bao giờ trả về model.
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._datasource, this._tokenStorage);

  final AuthRemoteDatasource _datasource;
  final TokenStorage _tokenStorage;

  @override
  Future<User> login({required String email, required String password}) async {
    try {
      final response = await _datasource.login(
        email: email,
        password: password,
      );

      await _tokenStorage.saveTokens(
        accessToken: response.accessToken,
        refreshToken: response.refreshToken,
      );

      return response.user.toEntity();
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _datasource.logout();
    } catch (_) {
    } finally {
      await _tokenStorage.clear();
    }
  }

  @override
  Future<User?> getCurrentUser() async {
    final token = await _tokenStorage.getAccessToken();
    if (token == null) return null;

    try {
      final userModel = await _datasource.getProfile();
      return userModel.toEntity();
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  AppException _handleDioError(DioException e) {
    final statusCode = e.response?.statusCode;

    return switch (statusCode) {
      400 => NetworkException(
        e.response?.data['message'] as String? ?? 'Yêu cầu không hợp lệ',
      ),
      401 => const InvalidCredentialsException(),
      403 => const AccountSuspendedException(),
      404 => const NotFoundException(),
      500 => const ServerException(),
      _ => NetworkException(e.message),
    };
  }
}

/// Trả về AuthRepository (interface).
/// Bên trong dùng AuthRepositoryImpl nhưng bên ngoài chỉ thấy interface.
@riverpod
AuthRepository authRepository(Ref ref) => AuthRepositoryImpl(
  ref.watch(authRemoteDatasourceProvider),
  ref.watch(tokenStorageProvider),
);
