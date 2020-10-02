// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Order _$OrderFromJson(Map<String, dynamic> json) {
  return Order(
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
    json['deliveryOption'] as int,
    (json['subTotal'] as num)?.toDouble(),
    json['addressType'] as String,
    json['address'] == null
        ? null
        : Address.fromJson(json['address'] as Map<String, dynamic>),
    json['orderStatus'] as int,
    json['currency'] as String,
    json['paymentMethod'] as int,
    json['createdDate'] == null
        ? null
        : DateTime.parse(json['createdDate'] as String),
    (json['orderDetailList'] as List)
        ?.map((e) =>
            e == null ? null : OrderDetail.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    json['scheduleDelivery'] as bool,
    json['scheduledTime'] == null
        ? null
        : DateTime.parse(json['scheduledTime'] as String),
    json['promoCode'] as String,
  );
}

Map<String, dynamic> _$OrderToJson(Order instance) => <String, dynamic>{
      'id': instance.id,
      'shop': instance.shop,
      'user': instance.user,
      'itemTotal': instance.itemTotal,
      'addonTotal': instance.addonTotal,
      'additionalTotal': instance.additionalTotal,
      'deliveryTotal': instance.deliveryTotal,
      'deliveryOption': instance.deliveryOption,
      'paymentMethod': instance.paymentMethod,
      'subTotal': instance.subTotal,
      'addressType': instance.addressType,
      'address': instance.address,
      'orderStatus': instance.orderStatus,
      'currency': instance.currency,
      'scheduleDelivery': instance.scheduleDelivery,
      'scheduledTime': instance.scheduledTime?.toIso8601String(),
      'createdDate': instance.createdDate?.toIso8601String(),
      'promoCode': instance.promoCode,
      'orderDetailList': instance.orderDetailList,
    };
