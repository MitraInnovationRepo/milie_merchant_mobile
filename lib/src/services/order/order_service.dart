import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:milie_merchant_mobile/src/data/model/order_view.dart';
import 'package:milie_merchant_mobile/src/services/security/oauth2_service.dart';
import 'package:milie_merchant_mobile/src/services/service_locator.dart';
import 'package:milie_merchant_mobile/src/util/constant.dart';

class OrderService {
  OAuth2Service _oAuth2Service = locator<OAuth2Service>();
  String backendEndpoint = Constant.backendEndpoint;

  Future<List<OrderView>> findMerchantOrder(int status) async {
    final http.Response response = await _oAuth2Service.getClient().get(
        '$backendEndpoint/orders/merchant/$status',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        });
    List<OrderView> list = [];
    if (response.statusCode == 200) {
      var data = json.decode(utf8.decode(response.bodyBytes));
      var rest = data as List;
      list = rest.map<OrderView>((json) => OrderView.fromJson(json)).toList();
    }
    return list;
  }

  Future<int> approveOrder(int orderId) async {
    final http.Response response = await _oAuth2Service.getClient().put(
      '$backendEndpoint/orders/merchant/approve/$orderId',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    return response.statusCode;
  }

  Future<int> rejectOrder(int orderId) async {
    final http.Response response = await _oAuth2Service.getClient().put(
      '$backendEndpoint/orders/merchant/reject/$orderId',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    return response.statusCode;
  }

  Future<int> updateOrderToFoodReady(int orderId) async {
    final http.Response response = await _oAuth2Service.getClient().put(
      '$backendEndpoint/orders/merchant/food-ready/$orderId',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    return response.statusCode;
  }

  Future<int> updateOrderToRiderPicked(int orderId) async {
    final http.Response response = await _oAuth2Service.getClient().put(
      '$backendEndpoint/orders/merchant/rider-picked/$orderId',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    return response.statusCode;
  }

  Future<int> updateOrderToOrderDelivered(int orderId) async {
    final http.Response response = await _oAuth2Service.getClient().put(
      '$backendEndpoint/orders/merchant/customer-picked/$orderId',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    return response.statusCode;
  }
}
