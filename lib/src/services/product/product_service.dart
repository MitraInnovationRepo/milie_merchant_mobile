import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:foodie_merchant/src/data/model/product.dart';
import 'package:foodie_merchant/src/services/security/oauth2_service.dart';
import 'package:foodie_merchant/src/services/service_locator.dart';
import 'package:foodie_merchant/src/util/constant.dart';

class ProductService {
  String backendEndpoint = Constant.backendEndpoint;
  OAuth2Service _oAuth2Service = locator<OAuth2Service>();

  Future<http.Response> saveProduct(Product product) async {
    return _oAuth2Service.getClient().post(
          '$backendEndpoint/product',
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(product.toJson()),
        );
  }

  Future<http.Response> updateProduct(Product product) async {
    return _oAuth2Service.getClient().put(
          '$backendEndpoint/product',
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(product.toJson()),
        );
  }

  Future<http.Response> deleteProduct(int productId) async {
    return _oAuth2Service.getClient().delete(
          '$backendEndpoint/product/$productId',
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
        );
  }

  Future<http.Response> findProductByShop(int shopId,
      [String key = "",
      int pageNo = 0,
      int pageSize = 10,
      String sortBy = "id",
      String sortDirection = "ASC"]) async {
    sortBy = sortBy?? "id";
    sortDirection = sortDirection?? "ASC";
    return _oAuth2Service.getClient().get(
        '$backendEndpoint/product/shop/$shopId?keyword=$key&pageNo=$pageNo&pageSize=$pageSize&sortBy=$sortBy&sortDirection=$sortDirection',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        });
  }

  Future<List<Product>> findShopProductsByProductTypeId(int productTypeId) async{
    final http.Response response  = await _oAuth2Service.getClient().get('$backendEndpoint/product/shop/mine/product-type/$productTypeId', headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    });
    List<Product> list = [];
    if (response.statusCode == 200) {
      var data = json.decode(utf8.decode(response.bodyBytes));
      var rest = data as List;
      list = rest.map<Product>((json) => Product.fromJson(json)).toList();
    }
    return list;
  }

  Future<http.Response> updateProductStatus(int id, int status) async {
    return _oAuth2Service.getClient().put(
      '$backendEndpoint/product/$id/status/$status',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
  }
}
