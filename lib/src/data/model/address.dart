import 'package:json_annotation/json_annotation.dart';

part 'address.g.dart';

@JsonSerializable()
class Address{
  String name;
  String billingAddress;
  double latitude;
  double longitude;
  bool favorite;

  Address(this.name, this.billingAddress, this.latitude, this.longitude, this.favorite);

  Address.empty();

  factory Address.fromJson(Map<String, dynamic> json) => _$AddressFromJson(json);

  Map<String, dynamic> toJson() => _$AddressToJson(this);
}