import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:foodie_merchant/src/data/model/reset_password.dart';
import 'package:foodie_merchant/src/data/model/user.dart';
import 'package:foodie_merchant/src/data/model/user_profile.dart';
import 'package:foodie_merchant/src/data/model/user_verification.dart';
import 'package:foodie_merchant/src/services/security/oauth2_service.dart';
import 'package:foodie_merchant/src/services/service_locator.dart';
import 'package:foodie_merchant/src/util/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  OAuth2Service _oAuth2Service = locator<OAuth2Service>();
  String backendEndpoint = Constant.backendEndpoint;

  Future<http.Response> initializeUser(User user) async {
    return http.post(
      Uri.parse('$backendEndpoint/users'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(user.toJson()),
    );
  }

  Future<http.Response> verifyUser(UserVerification userVerification) async {
    return http.post(
      Uri.parse('$backendEndpoint/users/verify'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(userVerification.toJson()),
    );
  }

  Future<http.Response> findCurrentUser() async {
    return _oAuth2Service
        .getClient()
        .get(Uri.parse('$backendEndpoint/users'), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    });
  }

  Future<http.Response> updateDeviceInfo(User user) async {
    return _oAuth2Service.getClient().post(
          Uri.parse('$backendEndpoint/users/update/device'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(user.toJson()),
        );
  }

  Future<http.Response> resetPassword(UserResetPassword resetPassword) async {
    return http.post(
      Uri.parse('$backendEndpoint/users/changePassword'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(resetPassword.toJson()),
    );
  }

  void logoutUser() {
    final storage = new FlutterSecureStorage();
    storage.deleteAll();
    _clearLocalStorage();
  }

  Future<http.Response> updateUser(User user) {
    return _oAuth2Service.getClient().put(
          Uri.parse('$backendEndpoint/users'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(user.toJson()),
        );
  }

  Future<http.Response> checkUserExist(String phoneNumber) {
    return http.get(Uri.parse('$backendEndpoint/users/userExists/$phoneNumber'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        });
  }

  Future<http.Response> updateUserAsCustomer() {
    return http.post(
      Uri.parse('$backendEndpoint/users/role/customer'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
  }

  setUpUserProfile(UserProfile userProfile, var parsedJwt) {
    userProfile.name = parsedJwt['given_name'];
    userProfile.countryCode = parsedJwt['country_code'];
    userProfile.phoneNumber = parsedJwt['preferred_username'];
    userProfile.phoneNumberWithCountryCode =
        parsedJwt['country_code'].toString() +
            parsedJwt['preferred_username'].toString();
    userProfile.email = parsedJwt['email'];
    userProfile.currency = parsedJwt['currency'];
    var realmAccess = parsedJwt['realm_access'];
    if (realmAccess != null) {
      var dynamicRoleList = parsedJwt['realm_access']['roles'];
      List<String> roleList = [];
      for (int i = 0; i < dynamicRoleList.length; i++) {
        roleList.add(dynamicRoleList[i].toString());
      }
      userProfile.roles = roleList;
    } else {
      userProfile.roles = [];
    }
    userProfile.notifyCreation();
  }

  _clearLocalStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(Constant.clientCredentialKey);
  }
}
