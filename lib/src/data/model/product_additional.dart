import 'package:json_annotation/json_annotation.dart';

part 'product_additional.g.dart';

@JsonSerializable()
class ProductAdditional {
  int id;
  String name;
  double price;
  int status;

  ProductAdditional(this.id, this.name, this.price, this.status);

  ProductAdditional.empty();

  factory ProductAdditional.fromJson(Map<String, dynamic> json) =>
      _$ProductAdditionalFromJson(json);

  Map<String, dynamic> toJson() => _$ProductAdditionalToJson(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductAdditional &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
