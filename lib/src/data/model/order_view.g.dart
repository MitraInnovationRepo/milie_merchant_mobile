// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_view.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderView _$OrderViewFromJson(Map<String, dynamic> json) {
  return OrderView(
    json['id'] as int,
    json['shop'] == null
        ? null
        : Shop.fromJson(json['shop'] as Map<String, dynamic>),
    json['user'] == null
        ? null
        : User.fromJson(json['user'] as Map<String, dynamic>),
    (json['itemTotal'] as num)?.toDouble(),
    (json['addonTotal'] as num)?.toDouble(),
    (json['additionalTotal'] as num)?.toDouble(),
    (json['deliveryTotal'] as num)?.toDouble(),
    (json['itemSubTotal'] as num)?.toDouble(),
    json['deliveryOption'] as int,
    (json['subTotal'] as num)?.toDouble(),
    json['addressType'] as String,
    json['address'] as String,
    (json['latitude'] as num)?.toDouble(),
    (json['longitude'] as num)?.toDouble(),
    json['orderStatus'] as int,
    json['currency'] as String,
    json['paymentMethod'] as int,
    json['createdDate'] == null
        ? null
        : DateTime.parse(json['createdDate'] as String),
    (json['orderDetailList'] as List)
        ?.map((e) => e == null
            ? null
            : OrderDetailView.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    json['scheduleDelivery'] as bool,
    json['scheduledTime'] == null
        ? null
        : DateTime.parse(json['scheduledTime'] as String),
    json['orderAcceptedTime'] == null
        ? null
        : DateTime.parse(json['orderAcceptedTime'] as String),
    json['foodPreparedTime'] == null
        ? null
        : DateTime.parse(json['foodPreparedTime'] as String),
    json['promoCode'] as String,
    json['cabNo'] as String,
    json['lastModifiedDate'] == null
        ? null
        : DateTime.parse(json['lastModifiedDate'] as String),
    (json['discount'] as num)?.toDouble(),
    (json['discountedSubTotal'] as num)?.toDouble(),
    json['promotionType'] as int,
    json['promotionDisplayName'] as String,
  );
}

Map<String, dynamic> _$OrderViewToJson(OrderView instance) => <String, dynamic>{
      'id': instance.id,
      'shop': instance.shop,
      'user': instance.user,
      'itemTotal': instance.itemTotal,
      'addonTotal': instance.addonTotal,
      'additionalTotal': instance.additionalTotal,
      'deliveryTotal': instance.deliveryTotal,
      'itemSubTotal': instance.itemSubTotal,
      'deliveryOption': instance.deliveryOption,
      'paymentMethod': instance.paymentMethod,
      'subTotal': instance.subTotal,
      'addressType': instance.addressType,
      'address': instance.address,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'orderStatus': instance.orderStatus,
      'currency': instance.currency,
      'scheduleDelivery': instance.scheduleDelivery,
      'scheduledTime': instance.scheduledTime?.toIso8601String(),
      'orderAcceptedTime': instance.orderAcceptedTime?.toIso8601String(),
      'foodPreparedTime': instance.foodPreparedTime?.toIso8601String(),
      'cabNo': instance.cabNo,
      'discount': instance.discount,
      'discountedSubTotal': instance.discountedSubTotal,
      'createdDate': instance.createdDate?.toIso8601String(),
      'lastModifiedDate': instance.lastModifiedDate?.toIso8601String(),
      'promoCode': instance.promoCode,
      'promotionType': instance.promotionType,
      'promotionDisplayName': instance.promotionDisplayName,
      'orderDetailList': instance.orderDetailList,
    };
