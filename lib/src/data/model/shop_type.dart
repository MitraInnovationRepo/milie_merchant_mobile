import 'package:json_annotation/json_annotation.dart';

part 'shop_type.g.dart';

@JsonSerializable()
class ShopType{
  int id;
  String image;
  String name;

  ShopType(this.id, this.name, this.image);

  ShopType.empty();

  factory ShopType.fromJson(Map<String, dynamic> json) => _$ShopTypeFromJson(json);

  Map<String, dynamic> toJson() => _$ShopTypeToJson(this);
}