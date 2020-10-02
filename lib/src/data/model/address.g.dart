// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Address _$AddressFromJson(Map<String, dynamic> json) {
  return Address(
    json['name'] as String,
    json['billingAddress'] as String,
    (json['latitude'] as num)?.toDouble(),
    (json['longitude'] as num)?.toDouble(),
    json['favorite'] as bool,
  );
}

Map<String, dynamic> _$AddressToJson(Address instance) => <String, dynamic>{
      'name': instance.name,
      'billingAddress': instance.billingAddress,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'favorite': instance.favorite,
    };
