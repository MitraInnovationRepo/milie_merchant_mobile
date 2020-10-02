// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reset_password.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserResetPassword _$UserResetPasswordFromJson(Map<String, dynamic> json) {
  return UserResetPassword(
    json['password'] as String,
    json['username'] as String,
  );
}

Map<String, dynamic> _$UserResetPasswordToJson(UserResetPassword instance) =>
    <String, dynamic>{
      'password': instance.password,
      'username': instance.username,
    };
