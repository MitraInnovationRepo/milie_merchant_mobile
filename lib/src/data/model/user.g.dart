// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
    json['countryCode'] as String,
    json['phoneNumber'] as String,
    json['name'] as String,
    json['email'] as String,
    json['emailVerified'] as bool,
    json['password'] as String,
    json['role'] as String,
    json['fireBaseRegistration'] as String,
    json['deviceId'] as String,
    (json['userAddressList'] as List)
        ?.map((e) =>
            e == null ? null : UserAddress.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'countryCode': instance.countryCode,
      'phoneNumber': instance.phoneNumber,
      'name': instance.name,
      'email': instance.email,
      'emailVerified': instance.emailVerified,
      'password': instance.password,
      'role': instance.role,
      'fireBaseRegistration': instance.fireBaseRegistration,
      'deviceId': instance.deviceId,
      'userAddressList': instance.userAddressList,
    };
