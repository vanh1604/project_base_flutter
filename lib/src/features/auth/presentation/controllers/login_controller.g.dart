// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// `AsyncNotifier<User?>` nghĩa là:
/// - State kiểu `AsyncValue<User?>`
/// - AsyncLoading  → đang gọi API
/// - AsyncData     → login thành công, chứa User
/// - AsyncError    → login thất bại, chứa AppException

@ProviderFor(LoginController)
const loginControllerProvider = LoginControllerProvider._();

/// `AsyncNotifier<User?>` nghĩa là:
/// - State kiểu `AsyncValue<User?>`
/// - AsyncLoading  → đang gọi API
/// - AsyncData     → login thành công, chứa User
/// - AsyncError    → login thất bại, chứa AppException
final class LoginControllerProvider
    extends $AsyncNotifierProvider<LoginController, User?> {
  /// `AsyncNotifier<User?>` nghĩa là:
  /// - State kiểu `AsyncValue<User?>`
  /// - AsyncLoading  → đang gọi API
  /// - AsyncData     → login thành công, chứa User
  /// - AsyncError    → login thất bại, chứa AppException
  const LoginControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'loginControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$loginControllerHash();

  @$internal
  @override
  LoginController create() => LoginController();
}

String _$loginControllerHash() => r'5e3f9461b7e4b9b21d30580b817c26978a7b1366';

/// `AsyncNotifier<User?>` nghĩa là:
/// - State kiểu `AsyncValue<User?>`
/// - AsyncLoading  → đang gọi API
/// - AsyncData     → login thành công, chứa User
/// - AsyncError    → login thất bại, chứa AppException

abstract class _$LoginController extends $AsyncNotifier<User?> {
  FutureOr<User?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<User?>, User?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<User?>, User?>,
              AsyncValue<User?>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
