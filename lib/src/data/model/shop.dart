import 'package:json_annotation/json_annotation.dart';
import 'package:milie_merchant_mobile/src/data/model/shop_tag.dart';
import 'package:milie_merchant_mobile/src/data/model/shop_type.dart';

import 'address.dart';

part 'shop.g.dart';

@JsonSerializable()
class Shop{
  int id;
  String name;
  ShopType shopType;
  String phoneNumber;
  String description;
  String slogan;
  double longitude;
  double latitude;
  Address address;
  String imageName;
  String secondaryPhoneNumber;
  double minimumOrderAmount;
  int deliveryTimeInHours;
  double deliveryCharges;
  String displayCity;
  List<ShopTag> shopTagList;
  bool favorite;
  int status;
  double rating;
  int totalRatingFeedBacks;
  double maxDeliveryDistance;

  Shop.empty();

  Shop(this.id, this.name, this.shopType, this.phoneNumber, this.description,
      this.slogan, this.longitude, this.latitude, this.address, this.imageName,
      this.secondaryPhoneNumber, this.minimumOrderAmount, this.deliveryTimeInHours,
      this.deliveryCharges, this.displayCity, this.shopTagList, this.favorite,
      this.status, this.rating, this.totalRatingFeedBacks, this.maxDeliveryDistance);

  factory Shop.fromJson(Map<String, dynamic> json) => _$ShopFromJson(json);

  Map<String, dynamic> toJson() => _$ShopToJson(this);
}