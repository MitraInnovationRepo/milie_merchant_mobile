// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderDetail _$OrderDetailFromJson(Map<String, dynamic> json) {
  return OrderDetail(
    json['id'] as int,
    (json['quantity'] as num)?.toDouble(),
    (json['total'] as num)?.toDouble(),
    json['product'] == null
        ? null
        : Product.fromJson(json['product'] as Map<String, dynamic>),
    (json['addonList'] as List)
        ?.map((e) =>
            e == null ? null : ProductAddon.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    (json['additionalList'] as List)
        ?.map((e) => e == null
            ? null
            : ProductAdditional.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    json['description'] as String,
  )
    ..addonTotal = (json['addonTotal'] as num)?.toDouble()
    ..additionalTotal = (json['additionalTotal'] as num)?.toDouble();
}

Map<String, dynamic> _$OrderDetailToJson(OrderDetail instance) =>
    <String, dynamic>{
      'id': instance.id,
      'quantity': instance.quantity,
      'total': instance.total,
      'product': instance.product,
      'addonTotal': instance.addonTotal,
      'additionalTotal': instance.additionalTotal,
      'description': instance.description,
      'addonList': instance.addonList,
      'additionalList': instance.additionalList,
    };
