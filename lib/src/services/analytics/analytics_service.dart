import 'dart:convert';

import 'package:foodie_merchant/src/data/model/analytics/merchant_analytics_map.dart';
import 'package:foodie_merchant/src/services/security/oauth2_service.dart';
import 'package:foodie_merchant/src/services/service_locator.dart';
import 'package:foodie_merchant/src/util/constant.dart';

import 'package:http/http.dart' as http;

class AnalyticsService{
  OAuth2Service _oAuth2Service = locator<OAuth2Service>();
  String backendEndpoint = Constant.backendEndpoint;

  Future<MerchantAnalyticsMap> findMerchantOrdersToComplete() async {
    final http.Response response = await _oAuth2Service.getClient().get(
        '$backendEndpoint/analytics/merchant/pending/count',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        });

    MerchantAnalyticsMap merchantAnalyticsMap = MerchantAnalyticsMap.empty();
    if (response.statusCode == 200) {
      var data = json.decode(utf8.decode(response.bodyBytes));
      merchantAnalyticsMap = MerchantAnalyticsMap.fromJson(data);
    }
    return merchantAnalyticsMap;
  }
}