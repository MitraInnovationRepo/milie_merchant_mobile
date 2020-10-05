// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_analytics_map.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MerchantAnalyticsMap _$MerchantAnalyticsMapFromJson(Map<String, dynamic> json) {
  return MerchantAnalyticsMap(
    (json['orderMap'] as Map<String, dynamic>)?.map(
      (k, e) => MapEntry(int.parse(k), e as int),
    ),
  );
}

Map<String, dynamic> _$MerchantAnalyticsMapToJson(
        MerchantAnalyticsMap instance) =>
    <String, dynamic>{
      'orderMap': instance.orderMap?.map((k, e) => MapEntry(k.toString(), e)),
    };
