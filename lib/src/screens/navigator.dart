import 'dart:async';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodie_merchant/src/data/model/user.dart';
import 'package:foodie_merchant/src/screens/home/home.dart';
import 'package:foodie_merchant/src/screens/order/order_history.dart';
import 'package:foodie_merchant/src/screens/order/order_requests.dart';
import 'package:foodie_merchant/src/screens/product/product_type_catalog.dart';
import 'package:foodie_merchant/src/services/service_locator.dart';
import 'package:foodie_merchant/src/services/user/user_service.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class HomeNavigator extends StatefulWidget {
  HomeNavigator({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomeNavigatorState createState() => _HomeNavigatorState();
}

class _HomeNavigatorState extends State<HomeNavigator> {
  final FirebaseMessaging _fcm = FirebaseMessaging();
  StreamSubscription iosSubscription;
  UserService _userService = locator<UserService>();

  PersistentTabController _controller;

  List<Widget> _buildScreens() {
    return [Home(), OrderRequests(), OrderHistory(), ProductTypeCatalog()];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(Icons.home),
        title: ("Home"),
        activeColor: Theme.of(context).primaryColor,
        inactiveColor: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.list),
        title: ("Order Requests"),
        activeColor: Theme.of(context).primaryColor,
        inactiveColor: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.history),
        title: ("Order History"),
        activeColor: Theme.of(context).primaryColor,
        inactiveColor: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.fastfood),
        title: ("Menu"),
        activeColor: Theme.of(context).primaryColor,
        inactiveColor: CupertinoColors.systemGrey,
      )
    ];
  }

  @override
  void initState() {
    super.initState();
    if (Platform.isIOS) {
      iosSubscription = _fcm.onIosSettingsRegistered.listen((data) {
        // save the token  OR subscribe to a topic here
      });
      _fcm.requestNotificationPermissions(IosNotificationSettings());
    }
    _fcm.onTokenRefresh.listen((newToken) {
      User deviceUpdateUser = new User.empty();
      deviceUpdateUser.fireBaseRegistration = newToken;
      this._userService.updateDeviceInfo(deviceUpdateUser);
    });
    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        String messageBody = _getMessage(message);
        showSimpleNotification(
          InkWell(
            onTap: () => {
            },
            child: Text(
              messageBody,
              style: TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
          elevation: 10,
          slideDismiss: true,
          autoDismiss: false,
          leading: Icon(Icons.fastfood, color: Colors.white),
          background: Theme.of(context).accentColor,
        );
      },
      onLaunch: (Map<String, dynamic> message) async {

      },
      onResume: (Map<String, dynamic> message) async {

      },
    );
  }

  _getMessage(Map<String, dynamic> message) {
    return Platform.isIOS
        ? message['aps']['alert']['body']
        : message['notification']['body'];
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      controller: _controller,
      screens: _buildScreens(),
      items: _navBarsItems(),
      confineInSafeArea: true,
      backgroundColor: Theme.of(context).bottomAppBarColor,
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset: true,
      // This needs to be true if you want to move up the screen when keyboard appears.
      stateManagement: true,
      hideNavigationBarWhenKeyboardShows: true,
      // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument.
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(0.0), topRight: Radius.circular(0.0)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 10,
            offset: Offset(0, 4), // changes position of shadow
          ),
        ],
        colorBehindNavBar: Colors.white,
      ),
      popAllScreensOnTapOfSelectedTab: true,
      itemAnimationProperties: ItemAnimationProperties(
        // Navigation Bar's items animation properties.
        duration: Duration(milliseconds: 200),
        curve: Curves.ease,
      ),
      screenTransitionAnimation: ScreenTransitionAnimation(
        // Screen transition animation on change of selected tab.
        animateTabTransition: true,
        curve: Curves.ease,
        duration: Duration(milliseconds: 200),
      ),
      navBarStyle:
          NavBarStyle.style6, // Choose the nav bar style with this property.
    );
  }
}
