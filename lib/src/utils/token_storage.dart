import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Injectable token storage — inject qua Riverpod, mock được trong test.
class TokenStorage {
  const TokenStorage(this._storage);

  final FlutterSecureStorage _storage;

  static const _keyAccessToken = 'access_token';
  static const _keyRefreshToken = 'refresh_token';

  // ── Access Token ──────────────────────────────────────────────

  Future<void> saveAccessToken(String token) =>
      _storage.write(key: _keyAccessToken, value: token);

  Future<String?> getAccessToken() => _storage.read(key: _keyAccessToken);

  // ── Refresh Token ─────────────────────────────────────────────

  Future<void> saveRefreshToken(String token) =>
      _storage.write(key: _keyRefreshToken, value: token);

  Future<String?> getRefreshToken() => _storage.read(key: _keyRefreshToken);

  // ── Lưu cả 2 cùng lúc (dùng sau khi login) ───────────────────

  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await Future.wait([
      saveAccessToken(accessToken),
      saveRefreshToken(refreshToken),
    ]);
  }

  // ── Xóa hết khi logout ────────────────────────────────────────

  Future<void> clear() => _storage.deleteAll();
}
