import 'dart:convert';
import 'package:foodie_merchant/src/data/model/order_reject_response.dart';
import 'package:http/http.dart' as http;
import 'package:foodie_merchant/src/data/model/order_view.dart';
import 'package:foodie_merchant/src/services/security/oauth2_service.dart';
import 'package:foodie_merchant/src/services/service_locator.dart';
import 'package:foodie_merchant/src/util/constant.dart';

class OrderService {
  OAuth2Service _oAuth2Service = locator<OAuth2Service>();
  String backendEndpoint = Constant.backendEndpoint;

  Future<List<OrderView>> findMerchantOrder(int status) async {
    final http.Response response = await _oAuth2Service.getClient().get(
        '$backendEndpoint/orders/shop/$status',
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

  Future<List<OrderView>> findPendingOrders() async {
    final http.Response response = await _oAuth2Service.getClient().get(
        '$backendEndpoint/orders/shop/pending',
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

  Future<List<OrderView>> findCompletedOrders() async {
    final http.Response response = await _oAuth2Service.getClient().get(
        '$backendEndpoint/orders/shop/completed',
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

  Future<List<OrderView>> findUpcomingOrders() async {
    final http.Response response = await _oAuth2Service.getClient().get(
        '$backendEndpoint/orders/shop/upcoming',
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

  Future<OrderRejectResponse> approveOrder(int orderId) async {
    final http.Response response = await _oAuth2Service.getClient().put(
      '$backendEndpoint/orders/shop/approve/$orderId',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    OrderRejectResponse orderRejectResponse;
    if (response.statusCode == 200) {
      var data = json.decode(utf8.decode(response.bodyBytes));
      orderRejectResponse = OrderRejectResponse.fromJson(data);
    }
    return orderRejectResponse;
  }

  Future<OrderRejectResponse> rejectOrder(int orderId) async {
    final http.Response response = await _oAuth2Service.getClient().put(
      '$backendEndpoint/orders/shop/reject/$orderId',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    OrderRejectResponse orderRejectResponse;
    if (response.statusCode == 200) {
      var data = json.decode(utf8.decode(response.bodyBytes));
      orderRejectResponse = OrderRejectResponse.fromJson(data);
    }
    return orderRejectResponse;
  }

  Future<int> updateOrderToFoodReady(int orderId) async {
    final http.Response response = await _oAuth2Service.getClient().put(
      '$backendEndpoint/orders/shop/food-ready/$orderId',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    return response.statusCode;
  }

  Future<int> updateOrderToRiderPicked(int orderId) async {
    final http.Response response = await _oAuth2Service.getClient().put(
      '$backendEndpoint/orders/shop/rider-picked/$orderId',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    return response.statusCode;
  }

  Future<int> updateOrderToOrderDelivered(int orderId) async {
    final http.Response response = await _oAuth2Service.getClient().put(
      '$backendEndpoint/orders/shop/customer-picked/$orderId',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    return response.statusCode;
  }
}
