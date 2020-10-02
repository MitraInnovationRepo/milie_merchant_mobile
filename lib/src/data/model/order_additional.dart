import 'package:json_annotation/json_annotation.dart';
import 'package:milie_merchant_mobile/src/data/model/product_additional.dart';

part 'order_additional.g.dart';

@JsonSerializable()
class OrderAdditional {
  ProductAdditional productAdditional;

  OrderAdditional(this.productAdditional);

  OrderAdditional.empty();

  factory OrderAdditional.fromJson(Map<String, dynamic> json) =>
      _$OrderAdditionalFromJson(json);

  Map<String, dynamic> toJson() => _$OrderAdditionalToJson(this);
}
