// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_additional.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductAdditional _$ProductAdditionalFromJson(Map<String, dynamic> json) {
  return ProductAdditional(
    json['id'] as int,
    json['name'] as String,
    (json['price'] as num)?.toDouble(),
    json['status'] as int,
  );
}

Map<String, dynamic> _$ProductAdditionalToJson(ProductAdditional instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'price': instance.price,
      'status': instance.status,
    };
