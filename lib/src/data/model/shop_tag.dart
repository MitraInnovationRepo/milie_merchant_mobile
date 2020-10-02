import 'package:json_annotation/json_annotation.dart';

part 'shop_tag.g.dart';

@JsonSerializable()
class ShopTag {
  int id;
  String tagName;

  ShopTag(this.id, this.tagName);

  ShopTag.empty();

  factory ShopTag.fromJson(Map<String, dynamic> json) =>
      _$ShopTagFromJson(json);

  Map<String, dynamic> toJson() => _$ShopTagToJson(this);
}
