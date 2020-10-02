// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_additional.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderAdditional _$OrderAdditionalFromJson(Map<String, dynamic> json) {
  return OrderAdditional(
    json['productAdditional'] == null
        ? null
        : ProductAdditional.fromJson(
            json['productAdditional'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$OrderAdditionalToJson(OrderAdditional instance) =>
    <String, dynamic>{
      'productAdditional': instance.productAdditional,
    };
