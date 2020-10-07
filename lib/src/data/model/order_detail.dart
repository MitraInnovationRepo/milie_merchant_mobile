import 'package:json_annotation/json_annotation.dart';
import 'package:foodie_merchant/src/data/model/product.dart';
import 'package:foodie_merchant/src/data/model/product_additional.dart';
import 'package:foodie_merchant/src/data/model/product_addon.dart';

part 'order_detail.g.dart';

@JsonSerializable()
class OrderDetail {
  int id;
  double quantity;
  double total;
  Product product;
  double addonTotal;
  double additionalTotal;
  String description;
  List<ProductAddon> addonList;
  List<ProductAdditional> additionalList;

  OrderDetail(this.id, this.quantity, this.total, this.product, this.addonList, this.additionalList, this.description);

  OrderDetail.empty();

  factory OrderDetail.fromJson(Map<String, dynamic> json) => _$OrderDetailFromJson(json);

  Map<String, dynamic> toJson() => _$OrderDetailToJson(this);
}
