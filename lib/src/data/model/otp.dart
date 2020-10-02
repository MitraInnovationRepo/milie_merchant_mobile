import 'package:json_annotation/json_annotation.dart';

part 'otp.g.dart';

@JsonSerializable()
class OTP{
  String smsId;
  String value;

  OTP(this.smsId, this.value);

  factory OTP.fromJson(Map<String, dynamic> json) => _$OTPFromJson(json);

  Map<String, dynamic> toJson() => _$OTPToJson(this);
}