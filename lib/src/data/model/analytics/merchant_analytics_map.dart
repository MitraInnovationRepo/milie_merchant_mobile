import 'package:json_annotation/json_annotation.dart';

part 'merchant_analytics_map.g.dart';

@JsonSerializable()
class MerchantAnalyticsMap{
  Map<int, int> orderMap;

  MerchantAnalyticsMap.empty();

  MerchantAnalyticsMap(this.orderMap);

  factory MerchantAnalyticsMap.fromJson(Map<String, dynamic> json) => _$MerchantAnalyticsMapFromJson(json);

  Map<String, dynamic> toJson() => _$MerchantAnalyticsMapToJson(this);
}