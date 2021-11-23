import 'package:http/http.dart' as http;
import 'package:foodie_merchant/src/services/security/oauth2_service.dart';
import 'package:foodie_merchant/src/services/service_locator.dart';
import 'package:foodie_merchant/src/util/constant.dart';

class UserEmailService {
  String backendEndpoint = Constant.backendEndpoint;
  OAuth2Service _oAuth2Service = locator<OAuth2Service>();

  Future<http.Response> resendEmail() async {
    return _oAuth2Service.getClient().post(
      Uri.parse('$backendEndpoint/email-verification/resend'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
  }
}
