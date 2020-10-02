import 'package:json_annotation/json_annotation.dart';
import 'package:milie_merchant_mobile/src/data/model/address.dart';
import 'package:milie_merchant_mobile/src/data/model/order_detail.dart';
import 'package:milie_merchant_mobile/src/data/model/shop.dart';
import 'package:milie_merchant_mobile/src/data/model/user.dart';

part 'order.g.dart';

@JsonSerializable()
class Order {
  int id;
  Shop shop;
  User user;
  double itemTotal;
  double addonTotal;
  double additionalTotal;
  double deliveryTotal;
  int deliveryOption;
  int paymentMethod;
  double subTotal;
  String addressType;
  Address address;
  int orderStatus;
  String currency;
  bool scheduleDelivery;
  DateTime scheduledTime;

  DateTime createdDate;
  String promoCode;

  List<OrderDetail> orderDetailList;

  Order(this.id,
      this.shop,
      this.user,
      this.itemTotal,
      this.addonTotal,
      this.additionalTotal,
      this.deliveryTotal,
      this.deliveryOption,
      this.subTotal,
      this.addressType,
      this.address,
      this.orderStatus,
      this.currency,
      this.paymentMethod,
      this.createdDate,
      this.orderDetailList,
      this.scheduleDelivery,
      this.scheduledTime,
      this.promoCode);

  Order.empty();

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);

  Map<String, dynamic> toJson() => _$OrderToJson(this);
}