import 'package:json_annotation/json_annotation.dart';
import 'package:milie_merchant_mobile/src/data/model/address.dart';

part 'user_address.g.dart';

@JsonSerializable()
class UserAddress{
  String name;
  Address address;
  bool favorite;

  UserAddress(this.name, this.favorite, this.address);

  UserAddress.empty();

  factory UserAddress.fromJson(Map<String, dynamic> json) => _$UserAddressFromJson(json);

  Map<String, dynamic> toJson() => _$UserAddressToJson(this);
}