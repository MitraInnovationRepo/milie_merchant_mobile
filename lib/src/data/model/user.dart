import 'package:json_annotation/json_annotation.dart';
import 'package:milie_merchant_mobile/src/data/model/user_address.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  String countryCode;
  String phoneNumber;
  String name;
  String email;
  bool emailVerified;
  String password;
  String role;
  String fireBaseRegistration;
  String deviceId;
  List<UserAddress> userAddressList = [];

  User(this.countryCode, this.phoneNumber, this.name, this.email, this.emailVerified,
       this.password, this.role, this.fireBaseRegistration, this.deviceId, this.userAddressList);

  User.empty();

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
