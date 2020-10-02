// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'otp.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OTP _$OTPFromJson(Map<String, dynamic> json) {
  return OTP(
    json['smsId'] as String,
    json['value'] as String,
  );
}

Map<String, dynamic> _$OTPToJson(OTP instance) => <String, dynamic>{
      'smsId': instance.smsId,
      'value': instance.value,
    };
