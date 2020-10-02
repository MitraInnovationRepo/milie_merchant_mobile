import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:milie_merchant_mobile/src/data/model/user_profile.dart';
import 'package:milie_merchant_mobile/src/screens/login.dart';
import 'package:milie_merchant_mobile/src/services/service_locator.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft,DeviceOrientation.landscapeRight]);
  setupServiceLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => UserProfile.empty()),
        ],
        child: OverlaySupport(
            child: MaterialApp(
              title: 'Mitra',
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
              debugShowCheckedModeBanner: true,
              home: Login(),
            )));
  }
}
