// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_addon.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderAddon _$OrderAddonFromJson(Map<String, dynamic> json) {
  return OrderAddon(
    json['productAddon'] == null
        ? null
        : ProductAddon.fromJson(json['productAddon'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$OrderAddonToJson(OrderAddon instance) =>
    <String, dynamic>{
      'productAddon': instance.productAddon,
    };
