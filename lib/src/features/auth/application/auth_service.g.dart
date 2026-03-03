// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Application layer — Presentation chỉ giao tiếp qua đây.

@ProviderFor(authService)
const authServiceProvider = AuthServiceProvider._();

/// Application layer — Presentation chỉ giao tiếp qua đây.

final class AuthServiceProvider
    extends $FunctionalProvider<AuthService, AuthService, AuthService>
    with $Provider<AuthService> {
  /// Application layer — Presentation chỉ giao tiếp qua đây.
  const AuthServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authServiceHash();

  @$internal
  @override
  $ProviderElement<AuthService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AuthService create(Ref ref) {
    return authService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuthService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuthService>(value),
    );
  }
}

String _$authServiceHash() => r'5acb156e425ac8f1a4f98de3906cb295110902b3';

/// Trạng thái xác thực hiện tại.
/// Trả về User nếu đã đăng nhập, null nếu chưa / token hết hạn.

@ProviderFor(authState)
const authStateProvider = AuthStateProvider._();

/// Trạng thái xác thực hiện tại.
/// Trả về User nếu đã đăng nhập, null nếu chưa / token hết hạn.

final class AuthStateProvider
    extends $FunctionalProvider<AsyncValue<User?>, User?, FutureOr<User?>>
    with $FutureModifier<User?>, $FutureProvider<User?> {
  /// Trạng thái xác thực hiện tại.
  /// Trả về User nếu đã đăng nhập, null nếu chưa / token hết hạn.
  const AuthStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authStateHash();

  @$internal
  @override
  $FutureProviderElement<User?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<User?> create(Ref ref) {
    return authState(ref);
  }
}

String _$authStateHash() => r'a229815af0fc2a0199447b5a96357017ee61a817';
