// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_addon.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductAddon _$ProductAddonFromJson(Map<String, dynamic> json) {
  return ProductAddon(
    json['id'] as int,
    json['name'] as String,
    (json['price'] as num)?.toDouble(),
    json['status'] as int,
  );
}

Map<String, dynamic> _$ProductAddonToJson(ProductAddon instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'price': instance.price,
      'status': instance.status,
    };
