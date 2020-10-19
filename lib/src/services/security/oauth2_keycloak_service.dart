import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:foodie_merchant/src/util/constant.dart';
import 'package:oauth2/oauth2.dart' as oauth2;
import 'package:oauth2/oauth2.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'oauth2_service.dart';

class OAuth2KeycloakService extends OAuth2Service {
  final authorizationEndpoint = Uri.parse(Constant.keycloakEndpoint +
      "/auth/realms/foodie/protocol/openid-connect/token");
  final clientId = "foodie-mobile";
  final clientSecret = Constant.clientSecret;
  oauth2.Client client;

  @override
  Future<Credentials> authenticate(String username, String password) async {
    var credentials;
    try {
      List<String> scopes = [];
      scopes.add("offline_access");
      client = await oauth2.resourceOwnerPasswordGrant(
          authorizationEndpoint, username, password,
          identifier: clientId, secret: clientSecret, scopes: scopes);
      final storage = new FlutterSecureStorage();
      credentials = client.credentials;
      storage.write(key: "access_token", value: credentials.accessToken);
      String credential = credentials.toJson().toString();
      _storeCredential(credential);
    } on AuthorizationException catch (e) {
      print(e.description);
    }
    return credentials;
  }

  @override
  Map<String, dynamic> parseJwt(String token) {
    final parts = token.split('.');
    if (parts.length != 3) {
      throw Exception('invalid token');
    }

    final payload = _decodeBase64(parts[1]);
    final payloadMap = json.decode(payload);
    if (payloadMap is! Map<String, dynamic>) {
      throw Exception('invalid payload');
    }

    return payloadMap;
  }

  String _decodeBase64(String str) {
    String output = str.replaceAll('-', '+').replaceAll('_', '/');

    switch (output.length % 4) {
      case 0:
        break;
      case 2:
        output += '==';
        break;
      case 3:
        output += '=';
        break;
      default:
        throw Exception('Illegal base64url string!"');
    }
    return utf8.decode(base64Url.decode(output));
  }

  @override
  bool shouldLogout() {
    if (!client.credentials.isExpired) {
      return false;
    } else if (client.credentials.canRefresh) {
      this.refresh();
      return false;
    }
    return true;
  }

  @override
  oauth2.Client getClient() {
    if (this.client.credentials.isExpired &&
        this.client.credentials.canRefresh) {
      try {
        List<String> scopes = [];
        scopes.add("offline_access");
        this.client.refreshCredentials(scopes);
        String refreshedCredential = client.credentials.toJson().toString();
        final storage = new FlutterSecureStorage();
        storage.write(key: "access_token", value: refreshedCredential);
        _storeCredential(refreshedCredential);
      } catch (e) {}
    }
    return this.client;
  }

  @override
  void refresh() {
    this.client.refreshCredentials();
  }

  initClient(String clientCredential) {
    Credentials credentials = oauth2.Credentials.fromJson(clientCredential);
    this.client = new oauth2.Client(credentials,
        identifier: clientId, secret: clientSecret);
  }

  void _storeCredential(String credential) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(Constant.clientCredentialKey);
    prefs.setString(Constant.clientCredentialKey, credential);
  }
}
