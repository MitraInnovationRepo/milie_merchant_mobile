// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_verification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserVerification _$UserVerificationFromJson(Map<String, dynamic> json) {
  return UserVerification(
    json['smsId'] as String,
    json['phoneNumber'] as String,
    json['value'] as String,
  );
}

Map<String, dynamic> _$UserVerificationToJson(UserVerification instance) =>
    <String, dynamic>{
      'smsId': instance.smsId,
      'phoneNumber': instance.phoneNumber,
      'value': instance.value,
    };
