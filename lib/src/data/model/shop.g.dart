// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shop.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Shop _$ShopFromJson(Map<String, dynamic> json) {
  return Shop(
    json['id'] as int,
    json['name'] as String,
    json['shopType'] == null
        ? null
        : ShopType.fromJson(json['shopType'] as Map<String, dynamic>),
    json['phoneNumber'] as String,
    json['description'] as String,
    json['slogan'] as String,
    (json['longitude'] as num)?.toDouble(),
    (json['latitude'] as num)?.toDouble(),
    json['address'] == null
        ? null
        : Address.fromJson(json['address'] as Map<String, dynamic>),
    json['imageName'] as String,
    json['secondaryPhoneNumber'] as String,
    (json['minimumOrderAmount'] as num)?.toDouble(),
    json['deliveryTimeInHours'] as int,
    (json['deliveryCharges'] as num)?.toDouble(),
    json['displayCity'] as String,
    (json['shopTagList'] as List)
        ?.map((e) =>
            e == null ? null : ShopTag.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    json['favorite'] as bool,
    json['status'] as int,
    (json['rating'] as num)?.toDouble(),
    json['totalRatingFeedBacks'] as int,
    (json['maxDeliveryDistance'] as num)?.toDouble(),
  );
}

Map<String, dynamic> _$ShopToJson(Shop instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'shopType': instance.shopType,
      'phoneNumber': instance.phoneNumber,
      'description': instance.description,
      'slogan': instance.slogan,
      'longitude': instance.longitude,
      'latitude': instance.latitude,
      'address': instance.address,
      'imageName': instance.imageName,
      'secondaryPhoneNumber': instance.secondaryPhoneNumber,
      'minimumOrderAmount': instance.minimumOrderAmount,
      'deliveryTimeInHours': instance.deliveryTimeInHours,
      'deliveryCharges': instance.deliveryCharges,
      'displayCity': instance.displayCity,
      'shopTagList': instance.shopTagList,
      'favorite': instance.favorite,
      'status': instance.status,
      'rating': instance.rating,
      'totalRatingFeedBacks': instance.totalRatingFeedBacks,
      'maxDeliveryDistance': instance.maxDeliveryDistance,
    };
