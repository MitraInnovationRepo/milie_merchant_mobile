import 'package:json_annotation/json_annotation.dart';

part 'product_type.g.dart';

@JsonSerializable()
class ProductType {
  int id;
  String image;
  String name;

  ProductType(this.id, this.name, this.image);

  ProductType.empty();

  factory ProductType.fromJson(Map<String, dynamic> json) =>
      _$ProductTypeFromJson(json);

  Map<String, dynamic> toJson() => _$ProductTypeToJson(this);
}
