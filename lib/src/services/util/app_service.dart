import 'dart:io' show Platform;

import 'package:http/http.dart' as http;
import 'package:foodie_merchant/src/util/constant.dart';

class AppService {
  String backendEndpoint = Constant.backendEndpoint;

  Future<http.Response> getCurrentActiveVersion() async {
    String appVersion = Platform.isAndroid
        ? Constant.androidAppVersion
        : Constant.iosAppVersion;
    String platform = Platform.isAndroid ? "android" : "ios";
    return http.get(
        Uri.parse('$backendEndpoint/metadata/update/$appVersion/$platform'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Application-Name': 'foodie-merchant'
        });
  }
}
