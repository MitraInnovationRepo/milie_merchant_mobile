import 'package:json_annotation/json_annotation.dart';
import 'package:milie_merchant_mobile/src/data/model/product_addon.dart';

part 'order_addon.g.dart';

@JsonSerializable()
class OrderAddon {
  ProductAddon productAddon;

  OrderAddon(this.productAddon);

  OrderAddon.empty();

  factory OrderAddon.fromJson(Map<String, dynamic> json) =>
      _$OrderAddonFromJson(json);

  Map<String, dynamic> toJson() => _$OrderAddonToJson(this);
}
