import 'package:json_annotation/json_annotation.dart';
import 'package:foodie_merchant/src/data/model/order_additional.dart';
import 'package:foodie_merchant/src/data/model/order_addon.dart';
import 'package:foodie_merchant/src/data/model/product.dart';

part 'order_detail_view.g.dart';

@JsonSerializable()
class OrderDetailView {
  int id;
  double quantity;
  double total;
  Product product;
  double addonTotal;
  double additionalTotal;
  double subTotal;
  String description;
  List<OrderAddon> addonList;
  List<OrderAdditional> additionalList;

  OrderDetailView(this.id, this.quantity, this.total, this.product, this.addonTotal, this.additionalTotal, this.subTotal, this.addonList, this.additionalList, this.description);

  OrderDetailView.empty();

  factory OrderDetailView.fromJson(Map<String, dynamic> json) => _$OrderDetailViewFromJson(json);

  Map<String, dynamic> toJson() => _$OrderDetailViewToJson(this);
}
