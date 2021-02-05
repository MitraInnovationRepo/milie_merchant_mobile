import 'dart:convert';
import 'dart:async';
import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:foodie_merchant/src/data/model/app_metadata.dart';
import 'package:foodie_merchant/src/data/model/user.dart';
import 'package:foodie_merchant/src/data/model/user_profile.dart';
import 'package:foodie_merchant/src/screens/navigator.dart';
import 'package:foodie_merchant/src/services/security/oauth2_service.dart';
import 'package:foodie_merchant/src/services/service_locator.dart';
import 'package:foodie_merchant/src/services/user/user_service.dart';
import 'package:foodie_merchant/src/services/util/app_service.dart';
import 'package:foodie_merchant/src/util/constant.dart';
import 'package:oauth2/oauth2.dart';
import 'package:overlay_support/overlay_support.dart';

import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:store_redirect/store_redirect.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/foundation.dart';
import 'package:system_settings/system_settings.dart';

class Login extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<Login> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  FocusNode phoneNumberFocusNode;
  FocusNode passwordFocusNode;
  final phoneNumberController = TextEditingController();
  final passwordController = TextEditingController();

  OAuth2Service _oAuth2Service = locator<OAuth2Service>();
  UserService _userService = locator<UserService>();
  final FirebaseMessaging _fcm = FirebaseMessaging();
  AppService _appService = locator<AppService>();
  AppMetadata appMetadata;
  bool isLoggedIn = false;
  bool shouldLogout = true;

  bool isLoginButtonEnabled = false;
  bool enableProgress = false;

  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    handleInterNetConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    _verifyLogin();
    _checkMode();
    phoneNumberFocusNode = FocusNode();
    passwordFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    switch (result) {
      case ConnectivityResult.wifi:
      case ConnectivityResult.mobile:
        break;
      case ConnectivityResult.none:
        showNetworkConnectivityAlert(context);
        break;
      default:
        showNetworkConnectivityAlert(context);
        break;
    }
  }

  showNetworkConnectivityAlert(BuildContext context) {
    Widget cancelButton = FlatButton(
      child: Text("Ok"),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop('dialog');
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Settings"),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop('dialog');
        SystemSettings.wireless();
      },
    );

    AlertDialog alert = AlertDialog(
      title: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Icon(Icons.settings),
          ),
          Text("Enable Mobile Data"),
        ],
      ),
      content: Text("Mobile data is Turned off- Turn on mobile "
          "data or use Wi-Fi to access data"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void handleInterNetConnectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      showNetworkConnectivityAlert(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (appMetadata == null) {
      return _loading();
    } else if (this.appMetadata.maintenanceMode == 1) {
      return _maintenanceBanner();
    } else if (this.appMetadata.updateAvailable == 1) {
      return _updateBanner();
    } else if (isLoggedIn && !shouldLogout) {
      return HomeNavigator();
    } else {
      return _login();
    }
  }

  _checkMode() async {
    AppMetadata appMetadata = await this.fetchCurrentVersion();
    setState(() {
      this.appMetadata = appMetadata;
      if (appMetadata.updateAvailable == 1) {
        StoreRedirect.redirect();
      }
    });
  }

  _verifyLogin() async {
    isLoggedIn = await loadCredentialFileFromStorage();
    if (isLoggedIn && !shouldLogout) {
      User user = await _fetchUserDetails(); //Fe
      UserProfile userProfile =
          Provider.of<UserProfile>(context, listen: false);
      user.userAddressList.forEach((element) {
        userProfile.userAddressMap.putIfAbsent(element.name, () => element);
      });
    }
  }

  Widget _loading() {
    return Scaffold(
        body: SpinKitDualRing(
            size: MediaQuery.of(context).size.width * 0.2, color: Colors.teal));
  }

  Widget _maintenanceBanner() {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Colors.grey.shade200,
                    offset: Offset(2, 4),
                    blurRadius: 5,
                    spreadRadius: 2)
              ],
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Theme.of(context).primaryColor,
                    Theme.of(context).accentColor
                  ])),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 80,
              ),
              Text("Maintenance",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).errorColor)),
              Divider(),
              Text(
                "We are updating the platform to serve you better. We will be back soon!",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _updateBanner() {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          height: MediaQuery.of(context).size.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 80,
              ),
              Text("New Version Available",
                  style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).errorColor)),
              Divider(),
              Text(
                "New update available! Please download the latest from the store",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _login() {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
            child: Center(
                child: enableProgress
                    ? Container(
                        height: MediaQuery.of(context).size.height,
                        child: Center(
                            child: SpinKitDualRing(
                                size: MediaQuery.of(context).size.width * 0.2,
                                color: Colors.teal)))
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                            Container(
                              height: MediaQuery.of(context).size.height * 0.4,
                              width: MediaQuery.of(context).size.width,
                              child: ClipPath(
                                child: Image.asset("assets/cover.jpg",
                                    fit: BoxFit.fitWidth),
                                clipper: BottomClipper(),
                              ),
                            ),
                            Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Column(
                                  children: [_formWidget(), _submitButton()],
                                ))
                          ]))));
  }

  Widget _phoneNumberField() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 10,
          ),
          TextFormField(
            inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r"^0*"))],
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (term) {
              phoneNumberFocusNode.unfocus();
              FocusScope.of(context).requestFocus(passwordFocusNode);
            },
            onChanged: (value) {
              isEmpty();
            },
            focusNode: phoneNumberFocusNode,
            controller: phoneNumberController,
            validator: (String val) {
              if (val.isEmpty) return "Field cannot be empty";
              return null;
            },
            autofocus: true,
            decoration: InputDecoration(
                contentPadding: EdgeInsets.all(0),
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black12, width: 0.5),
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(20.0),
                    )),
                hintText: "Phone Number",
                prefixIcon:
                    Icon(Icons.phone, color: Theme.of(context).accentColor),
                labelStyle: TextStyle(color: Colors.black),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black12, width: 1),
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(20.0),
                    ))),
          )
        ],
      ),
    );
  }

  Widget _passwordField() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 10,
          ),
          TextFormField(
            obscureText: true,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.go,
            onFieldSubmitted: (term) {
              phoneNumberFocusNode.unfocus();
              if (_formKey.currentState.validate()) {
                this.authenticate();
              }
            },
            onChanged: (value) {
              isEmpty();
            },
            onTap: () {},
            controller: passwordController,
            focusNode: passwordFocusNode,
            validator: (String val) {
              if (val.isEmpty) return "Field cannot be empty";
              return null;
            },
            decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black12, width: 0.5),
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(20.0),
                    )),
                contentPadding: EdgeInsets.all(0),
                hintText: "Password",
                labelStyle: TextStyle(color: Colors.black),
                prefixIcon:
                    Icon(Icons.lock, color: Theme.of(context).accentColor),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black12, width: 1),
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(20.0),
                    ))),
          )
        ],
      ),
    );
  }

  Widget _submitButton() {
    return InkWell(
        onTap: () {
          if (_formKey.currentState.validate()) {
            this.authenticate();
          }
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.symmetric(vertical: 20),
          padding: EdgeInsets.symmetric(vertical: 10),
          alignment: Alignment.center,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              color:
                  this.isLoginButtonEnabled ? Colors.black : Colors.grey[500]),
          child: Text(
            'Login',
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        ));
  }

  Widget _formWidget() {
    return Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            _phoneNumberField(),
            _passwordField(),
          ],
        ));
  }

  void authenticate() {
    setState(() {
      enableProgress = true;
    });

    _oAuth2Service
        .authenticate(phoneNumberController.text, passwordController.text)
        .then((val) async {
      if (val != null && !val.isExpired) {
        var parsedJwt = this._oAuth2Service.parseJwt(val.accessToken);
        await _setupUserProfile(
            parsedJwt); //Parse JWT received from keycloak and set User Profile

        User user = await _fetchUserDetails();
        UserProfile userProfile =
            Provider.of<UserProfile>(context, listen: false);
        user.userAddressList.forEach((element) {
          userProfile.userAddressMap.putIfAbsent(element.name, () => element);
        });

        if (user.role != null && userProfile.roles.contains("merchant")) {
          await this.checkUserDeviceData(
              user); //Check if device id, Firebase registration id has changed
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => HomeNavigator()),
              //User already has a role. Let him go in
              (Route<dynamic> route) => false);
        } else {
          setState(() {
            enableProgress = false;
          });
          showSimpleNotification(
            Text("Invalid Credentials"),
            background: Theme.of(context).errorColor,
          );
        }
      } else {
        setState(() {
          enableProgress = false;
        });
        showSimpleNotification(
          Text("Invalid Credentials"),
          background: Theme.of(context).errorColor,
        );
      }
    });
  }

  Future<void> checkUserDeviceData(User user) async {
    bool shouldUpdate = false;
    String fireBaseRegistrationId = await _fcm.getToken();
    User deviceUpdateUser = new User.empty();
    if (user.fireBaseRegistration == null ||
        user.fireBaseRegistration != fireBaseRegistrationId) {
      deviceUpdateUser.fireBaseRegistration = fireBaseRegistrationId;
      shouldUpdate = true;
    }
    String deviceId = await _getDeviceId(context);
    if (user.deviceId == null || user.deviceId != deviceId) {
      //TODO OTP verification
      deviceUpdateUser.deviceId = deviceId;
      shouldUpdate = true;
    }
    if (shouldUpdate) {
      var response = await _userService.updateDeviceInfo(deviceUpdateUser);
      if (response.statusCode == 200) {
        print("device info updated");
      }
    }
  }

  Future<String> _getDeviceId(BuildContext context) async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      IosDeviceInfo iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else {
      AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.androidId; // unique ID on Android
    }
  }

  Future<bool> _setupUserProfile(var parsedJwt) async {
    UserProfile userProfile = Provider.of<UserProfile>(context, listen: false);
    _userService.setUpUserProfile(userProfile, parsedJwt);
    return userProfile.roles.length > 0 &&
        userProfile.roles.contains(Constant.merchantRole);
  }

  Future<User> _fetchUserDetails() async {
    final http.Response response = await _userService.findCurrentUser();
    User user;
    if (response.statusCode == 200) {
      var data = json.decode(utf8.decode(response.bodyBytes));
      user = User.fromJson(data);
    }
    return user;
  }

  Future<AppMetadata> fetchCurrentVersion() async {
    final http.Response response = await _appService.getCurrentActiveVersion();
    AppMetadata appMetadata;
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      appMetadata = AppMetadata.fromJson(data);
    }
    return appMetadata;
  }

  Future<bool> loadCredentialFileFromStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String restoredCredential = prefs.getString(Constant.clientCredentialKey);
    if (restoredCredential != null && restoredCredential.length > 0) {
      _oAuth2Service.initClient(restoredCredential);
      Credentials credential = _oAuth2Service.getClient().credentials;
      var parsedJwt = this._oAuth2Service.parseJwt(credential.accessToken);
      bool isRolesValid = await _setupUserProfile(parsedJwt);
      if (!isRolesValid) {
        return false;
      }
      this.shouldLogout = _oAuth2Service.shouldLogout();
      return true;
    } else {
      return false;
    }
  }

  isEmpty() {
    setState(() {
      this.isLoginButtonEnabled = phoneNumberController.text.isNotEmpty &&
          passwordController.text.isNotEmpty;
    });
  }
}

class BottomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0.0, size.height - 20);
    path.lineTo(size.width, size.height - 80);
    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
