import 'package:oauth2/oauth2.dart';

abstract class OAuth2Service{
  Future<Credentials> authenticate(String username, String password);

  Map<String, dynamic> parseJwt(String token);

  void refresh();

  bool shouldLogout();

  Client getClient();

  void initClient(String clientCredential);

}