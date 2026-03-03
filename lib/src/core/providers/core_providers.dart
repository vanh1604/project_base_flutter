import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:project_base_flutter_handle/src/core/app_environment.dart';
import 'package:project_base_flutter_handle/src/core/interceptors/auth_interceptor.dart';
import 'package:project_base_flutter_handle/src/core/interceptors/log_interceptor.dart';
import 'package:project_base_flutter_handle/src/utils/token_storage.dart';

part 'core_providers.g.dart';

/// TokenStorage duy nhất cho toàn app — injectable và mockable trong test.
@Riverpod(keepAlive: true)
TokenStorage tokenStorage(Ref ref) => const TokenStorage(FlutterSecureStorage());

/// Dio instance duy nhất cho toàn app.
/// AuthInterceptor nhận TokenStorage qua Riverpod thay vì gọi static.
@Riverpod(keepAlive: true)
Dio dio(Ref ref) {
  final tokenStorage = ref.watch(tokenStorageProvider);

  final dio = Dio(
    BaseOptions(
      baseUrl: AppEnvironment.baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {'Content-Type': 'application/json'},
    ),
  );

  dio.interceptors.addAll([
    AppLogInterceptor(),
    AuthInterceptor(dio, tokenStorage),
  ]);

  return dio;
}
