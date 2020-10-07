import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:foodie_merchant/src/data/model/shop.dart';

import 'package:foodie_merchant/src/services/security/oauth2_service.dart';
import 'package:foodie_merchant/src/services/service_locator.dart';
import 'package:foodie_merchant/src/util/constant.dart';

class ShopService {
  String backendEndpoint = Constant.backendEndpoint;
  OAuth2Service _oAuth2Service = locator<OAuth2Service>();

  Future<http.Response> saveShop(Shop shop) async {
    return _oAuth2Service.getClient().post(
          '$backendEndpoint/shops',
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(shop.toJson()),
        );
  }

  Future<http.Response> updateShop(Shop shop) async {
    return _oAuth2Service.getClient().put(
          '$backendEndpoint/shops',
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(shop.toJson()),
        );
  }

  Future<http.Response> updateShopStatus(int status) async {
    return _oAuth2Service.getClient().put(
      '$backendEndpoint/shops/status/$status',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
  }

  Future<Shop> fetchShopByUser() async {
    final http.Response response = await _oAuth2Service
        .getClient()
        .get("$backendEndpoint/shops/mine", headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    });

    Shop shop;
    if (response.statusCode == 200) {
      var data = json.decode(utf8.decode(response.bodyBytes));
      shop = Shop.fromJson(data);
    }
    return shop;
  }
}
