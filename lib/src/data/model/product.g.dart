// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Product _$ProductFromJson(Map<String, dynamic> json) {
  return Product(
    json['id'] as int,
    json['title'] as String,
    json['productType'] == null
        ? null
        : ProductType.fromJson(json['productType'] as Map<String, dynamic>),
    json['shop'] == null
        ? null
        : Shop.fromJson(json['shop'] as Map<String, dynamic>),
    json['description'] as String,
    json['imageUrl'] as String,
    (json['minOrderQuantity'] as num)?.toDouble(),
    (json['maxOrderQuantity'] as num)?.toDouble(),
    (json['unitPrice'] as num)?.toDouble(),
    json['status'] as int,
    json['productUnit'] == null
        ? null
        : ProductUnit.fromJson(json['productUnit'] as Map<String, dynamic>),
    (json['unitSize'] as num)?.toDouble(),
    (json['productAddonList'] as List)
        ?.map((e) =>
            e == null ? null : ProductAddon.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    (json['productAdditionalList'] as List)
        ?.map((e) => e == null
            ? null
            : ProductAdditional.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$ProductToJson(Product instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'productType': instance.productType,
      'unitPrice': instance.unitPrice,
      'shop': instance.shop,
      'description': instance.description,
      'status': instance.status,
      'maxOrderQuantity': instance.maxOrderQuantity,
      'minOrderQuantity': instance.minOrderQuantity,
      'imageUrl': instance.imageUrl,
      'productUnit': instance.productUnit,
      'unitSize': instance.unitSize,
      'productAddonList': instance.productAddonList,
      'productAdditionalList': instance.productAdditionalList,
    };
