import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:foodie_merchant/src/data/model/driver_information.dart';
import 'package:foodie_merchant/src/services/security/oauth2_service.dart';
import 'package:foodie_merchant/src/services/service_locator.dart';
import 'package:foodie_merchant/src/util/constant.dart';

class DeliveryService {
  OAuth2Service _oAuth2Service = locator<OAuth2Service>();
  String backendEndpoint = Constant.backendEndpoint;
  String deliveryEndpoint = Constant.deliveryEndpoint;

  Future<DriverInformation> getDriverInformation(String cabNo) async {
    final http.Response response = await _oAuth2Service.getClient().get(
        '$backendEndpoint/delivery/driver/$cabNo',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        }
    );
    DriverInformation driverInformation;
    if (response.statusCode == 200) {
      var data = json.decode(utf8.decode(response.bodyBytes));
      driverInformation = DriverInformation.fromJson(data);
    }
    return driverInformation;
  }

  String getBasicAuth(){
    String username = Constant.deliveryAPIUserName;
    String password = Constant.deliveryAPIPassword;
    return 'Basic ' + base64Encode(utf8.encode('$username:$password'));
  }
}
