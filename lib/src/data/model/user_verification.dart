import 'package:json_annotation/json_annotation.dart';

part 'user_verification.g.dart';

@JsonSerializable()
class UserVerification{
  String smsId;
  String phoneNumber;
  String value;

  UserVerification(this.smsId, this.phoneNumber, this.value);

  factory UserVerification.fromJson(Map<String, dynamic> json) => _$UserVerificationFromJson(json);

  Map<String, dynamic> toJson() => _$UserVerificationToJson(this);
}