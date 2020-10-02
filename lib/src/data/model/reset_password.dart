import 'package:json_annotation/json_annotation.dart';

part 'reset_password.g.dart';

@JsonSerializable()
class UserResetPassword{
  String password;
  String username;

  UserResetPassword(this.password, this.username);

  factory UserResetPassword.fromJson(Map<String, dynamic> json) => _$UserResetPasswordFromJson(json);

  Map<String, dynamic> toJson() => _$UserResetPasswordToJson(this);
}