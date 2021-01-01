import 'package:json_annotation/json_annotation.dart';
import 'package:foodie_merchant/src/data/model/order_detail_view.dart';
import 'package:foodie_merchant/src/data/model/shop.dart';
import 'package:foodie_merchant/src/data/model/user.dart';

part 'order_view.g.dart';

@JsonSerializable()
class OrderView {
  int id;
  Shop shop;
  User user;
  double itemTotal;
  double addonTotal;
  double additionalTotal;
  double deliveryTotal;
  double itemSubTotal;
  int deliveryOption;
  int paymentMethod;
  double subTotal;
  String addressType;
  String address;
  double latitude;
  double longitude;
  int orderStatus;
  String currency;
  bool scheduleDelivery;
  DateTime scheduledTime;
  DateTime orderAcceptedTime;
  DateTime foodPreparedTime;
  String cabNo;

  DateTime createdDate;
  DateTime lastModifiedDate;
  String promoCode;

  List<OrderDetailView> orderDetailList;

  OrderView(this.id,
      this.shop,
      this.user,
      this.itemTotal,
      this.addonTotal,
      this.additionalTotal,
      this.deliveryTotal,
      this.itemSubTotal,
      this.deliveryOption,
      this.subTotal,
      this.addressType,
      this.address,
      this.latitude,
      this.longitude,
      this.orderStatus,
      this.currency,
      this.paymentMethod,
      this.createdDate,
      this.orderDetailList,
      this.scheduleDelivery,
      this.scheduledTime,
      this.orderAcceptedTime,
      this.foodPreparedTime,
      this.promoCode,
      this.cabNo,
      this.lastModifiedDate);

  OrderView.empty();

  factory OrderView.fromJson(Map<String, dynamic> json) => _$OrderViewFromJson(json);

  Map<String, dynamic> toJson() => _$OrderViewToJson(this);
}