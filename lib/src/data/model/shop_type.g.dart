// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shop_type.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShopType _$ShopTypeFromJson(Map<String, dynamic> json) {
  return ShopType(
    json['id'] as int,
    json['name'] as String,
    json['image'] as String,
  );
}

Map<String, dynamic> _$ShopTypeToJson(ShopType instance) => <String, dynamic>{
      'id': instance.id,
      'image': instance.image,
      'name': instance.name,
    };
