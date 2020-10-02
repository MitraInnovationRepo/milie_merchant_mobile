import 'package:json_annotation/json_annotation.dart';

part 'product_addon.g.dart';

@JsonSerializable()
class ProductAddon {
  int id;
  String name;
  double price;
  int status;

  ProductAddon(this.id, this.name, this.price, this.status);

  ProductAddon.empty();

  factory ProductAddon.fromJson(Map<String, dynamic> json) =>
      _$ProductAddonFromJson(json);

  Map<String, dynamic> toJson() => _$ProductAddonToJson(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductAddon &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
