import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:foodie_merchant/src/data/notifier/orders_to_handler_notifier.dart';
import 'package:foodie_merchant/src/data/notifier/pending_order_notifier.dart';
import 'package:foodie_merchant/src/data/notifier/tab_notifier.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:foodie_merchant/src/data/model/user_profile.dart';
import 'package:foodie_merchant/src/screens/login.dart';
import 'package:foodie_merchant/src/services/service_locator.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:screen/screen.dart';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/foundation.dart';
import 'package:system_settings/system_settings.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
  setupServiceLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Screen.keepOn(true);
    final textTheme = Theme.of(context).textTheme;
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => UserProfile.empty()),
          ChangeNotifierProvider(create: (context) => TabNotifier.empty()),
          ChangeNotifierProvider(
              create: (context) => PendingOrderNotifier.empty()),
          ChangeNotifierProvider(
              create: (context) => OrdersToHandleNotifier.empty()),
        ],
        child: OverlaySupport(
            child: MaterialApp(
          title: 'Foodie',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primaryColor: Colors.teal,
            accentColor: CupertinoColors.darkBackgroundGray,
            errorColor: Colors.red,
            backgroundColor: Colors.green,
            //use this as success color
            primarySwatch: Colors.blue,
            textTheme: GoogleFonts.latoTextTheme(textTheme).copyWith(
              bodyText2: GoogleFonts.montserrat(textStyle: textTheme.bodyText2),
            ),
          ),
          home: SplashPage(),
        )));
  }
}

class SplashPage extends StatefulWidget {
  @override
  SplashPageState createState() => SplashPageState();
}

class SplashPageState extends State<SplashPage> with WidgetsBindingObserver {
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;

  void navigationToNextPage() {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => Login()),
        //User already has a role. Let him go in
        (Route<dynamic> route) => false);
    // Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
  }

  startSplashScreenTimer() async {
    var _duration = new Duration(seconds: 8);
    return new Timer(_duration, handleInterNetConnectivity);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    startSplashScreenTimer();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _connectivitySubscription.cancel();
    super.dispose();
  }

  void handleInterNetConnectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      showNetworkConnectivityAlert(context);
    } else {
      navigationToNextPage();
    }
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

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      handleInterNetConnectivity();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Container(
            child: Stack(
          children: <Widget>[
            Center(
              child: Image.asset("assets/merchant.gif",
                  gaplessPlayback: true, fit: BoxFit.fitWidth),
            )
          ],
        )));
  }
}
