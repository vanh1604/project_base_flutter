import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:project_base_flutter_handle/src/features/auth/data/models/user_model.dart';

part 'login_response_model.freezed.dart';
part 'login_response_model.g.dart';

/// Model ánh xạ response trả về từ API /login
/// {
///   "access_token": "...",
///   "refresh_token": "...",
///   "user": { "id": "...", "name": "...", "email": "..." }
/// }
@freezed
abstract class LoginResponseModel with _$LoginResponseModel {
  const factory LoginResponseModel({
    @JsonKey(name: 'access_token') required String accessToken,
    @JsonKey(name: 'refresh_token') required String refreshToken,
    required UserModel user,
  }) = _LoginResponseModel;

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseModelFromJson(json);
}
