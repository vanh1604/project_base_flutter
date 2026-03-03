// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_repository_impl.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Trả về AuthRepository (interface).
/// Bên trong dùng AuthRepositoryImpl nhưng bên ngoài chỉ thấy interface.

@ProviderFor(authRepository)
const authRepositoryProvider = AuthRepositoryProvider._();

/// Trả về AuthRepository (interface).
/// Bên trong dùng AuthRepositoryImpl nhưng bên ngoài chỉ thấy interface.

final class AuthRepositoryProvider
    extends $FunctionalProvider<AuthRepository, AuthRepository, AuthRepository>
    with $Provider<AuthRepository> {
  /// Trả về AuthRepository (interface).
  /// Bên trong dùng AuthRepositoryImpl nhưng bên ngoài chỉ thấy interface.
  const AuthRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authRepositoryHash();

  @$internal
  @override
  $ProviderElement<AuthRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AuthRepository create(Ref ref) {
    return authRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuthRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuthRepository>(value),
    );
  }
}

String _$authRepositoryHash() => r'd4cb664fff585f755ca87cc840f9036512b08fd2';
