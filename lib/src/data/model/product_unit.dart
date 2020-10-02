import 'package:json_annotation/json_annotation.dart';

part 'product_unit.g.dart';

@JsonSerializable()
class ProductUnit {
  int id;
  String name;

  ProductUnit(this.id, this.name);

  ProductUnit.empty();

  factory ProductUnit.fromJson(Map<String, dynamic> json) =>
      _$ProductUnitFromJson(json);

  Map<String, dynamic> toJson() => _$ProductUnitToJson(this);
}
