import 'dart:async';

import 'package:flutter/material.dart';
import 'package:foodie_merchant/src/data/enums/order_status.dart';
import 'package:foodie_merchant/src/data/enums/shop_status.dart';
import 'package:foodie_merchant/src/data/model/analytics/merchant_analytics_map.dart';
import 'package:foodie_merchant/src/data/model/order_view.dart';
import 'package:foodie_merchant/src/data/model/shop.dart';
import 'package:foodie_merchant/src/data/model/user_profile.dart';
import 'package:foodie_merchant/src/data/notifier/orders_to_handler_notifier.dart';
import 'package:foodie_merchant/src/data/notifier/pending_order_notifier.dart';
import 'package:foodie_merchant/src/data/notifier/tab_notifier.dart';
import 'package:foodie_merchant/src/screens/home/promotion_slider.dart';
import 'package:foodie_merchant/src/screens/login.dart';
import 'package:foodie_merchant/src/screens/shop/shop_service.dart';
import 'package:foodie_merchant/src/services/analytics/analytics_service.dart';
import 'package:foodie_merchant/src/services/order/order_service.dart';
import 'package:foodie_merchant/src/services/service_locator.dart';
import 'package:foodie_merchant/src/services/user/user_service.dart';
import 'package:provider/provider.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:auto_size_text/auto_size_text.dart';

class Home extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<Home> {
  ShopService _shopService = locator<ShopService>();
  AnalyticsService _analyticsService = locator<AnalyticsService>();
  UserService _userService = locator<UserService>();
  Shop _shop;
  MerchantAnalyticsMap _merchantAnalyticsMap;
  Timer timer;
  bool enableProgress = false;
  OrderService _orderService = locator<OrderService>();

  @override
  void initState() {
    super.initState();
    _fetchShopDetails();
    _getMerchantNotHandledOrders();
    timer = Timer.periodic(Duration(seconds: 20), (Timer t) {
      this._getMerchantNotHandledOrders();
    });
    fetchPendingOrders();
    fetchReadyToPickupOrders();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  _fetchShopDetails() async {
    Shop _shop = await _shopService.fetchShopByUser();
    UserProfile userProfile = Provider.of<UserProfile>(context, listen: false);
    userProfile.shop = _shop;
    setState(() {
      this._shop = _shop;
    });
  }

  _getMerchantNotHandledOrders() async {
    setState(() {
      enableProgress = true;
    });
    MerchantAnalyticsMap _merchantAnalyticsMap =
        await this._analyticsService.findMerchantOrdersToComplete();

    OrdersToHandleNotifier ordersToHandleNotifier =
        Provider.of<OrdersToHandleNotifier>(context, listen: false);
    ordersToHandleNotifier.setAllCounts(_merchantAnalyticsMap);

    if (mounted) {
      setState(() {
        this._merchantAnalyticsMap = _merchantAnalyticsMap;
        this.enableProgress = false;
      });
    }
  }

  Future<void> fetchPendingOrders() async {
    setState(() {
      enableProgress = true;
    });

    List<OrderView> _pendingOrderList = await _orderService.findPendingOrders();
    if (mounted) {
      setState(() {
        setupPendingOrderItemList(_pendingOrderList);
        enableProgress = false;
      });
    }
    return Future<void>(() {});
  }

  Future<void> fetchReadyToPickupOrders() async {
    setState(() {
      enableProgress = true;
    });

    List<OrderView> _readyToPickupOrderList =
        await _orderService.findMerchantOrder(OrderStatus.readyToPickUp.index);
    if (mounted) {
      setState(() {
        setupReadyToPickUpOrderItemList(_readyToPickupOrderList);
        enableProgress = false;
      });
    }
    return Future<void>(() {});
  }

  setupPendingOrderItemList(List<OrderView> _pendingOrderList) {
    PendingOrderNotifier pendingOrderNotifier =
        Provider.of<PendingOrderNotifier>(context, listen: false);
    pendingOrderNotifier.setPendingOrderItems(_pendingOrderList);
  }

  setupReadyToPickUpOrderItemList(List<OrderView> _readyToPickUpOrderList) {
    PendingOrderNotifier pendingOrderNotifier =
        Provider.of<PendingOrderNotifier>(context, listen: false);
    pendingOrderNotifier.setReadyToPickUpItems(_readyToPickUpOrderList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.dark,
        toolbarHeight: 0.0,
      ),
      body: CustomScrollView(slivers: <Widget>[
        SliverAppBar(
          pinned: true,
          backgroundColor: Colors.white,
          toolbarHeight: MediaQuery.of(context).size.height * 0.05,
          expandedHeight: MediaQuery.of(context).size.height * 0.05,
          collapsedHeight: MediaQuery.of(context).size.height * 0.12,
          flexibleSpace: Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: (_shop == null
                ? Container()
                : Container(
                    child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ToggleSwitch(
                        totalSwitches: 2,
                        minWidth: 90.0,
                        fontSize: 16.0,
                        initialLabelIndex:
                            _shop.status == ShopStatus.active.index ? 0 : 1,
                        activeBgColor: _shop.status == ShopStatus.active.index
                            ? [Colors.green]
                            : [Colors.red],
                        activeFgColor: Colors.white,
                        inactiveBgColor: Colors.grey[400],
                        inactiveFgColor: Colors.grey[900],
                        labels: ['Active', 'Inactive'],
                        onToggle: (index) {
                          updateShopStatus(index);
                        },
                      ),
                      SizedBox(width: 15),
                      Flexible(
                          child: AutoSizeText(
                              _shop.name + " - " + _shop.displayCity,
                              style: TextStyle(fontSize: 22),
                              minFontSize: 16,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis)),
                      SizedBox(width: 15),
                      _shop.status == 1
                          ? Text("Online",
                              style:
                                  TextStyle(color: Colors.green, fontSize: 18))
                          : Text("Offline",
                              style:
                                  TextStyle(color: Colors.red, fontSize: 18)),
                      SizedBox(width: 15),
                      Row(children: [
                        RaisedButton(
                          onPressed: () {
                            _fetchShopDetails();
                            _getMerchantNotHandledOrders();
                          },
                          child: Icon(Icons.refresh),
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(color: Colors.green)),
                        ),
                        SizedBox(width: 20),
                        RaisedButton(
                          onPressed: () {
                            UserProfile userProfile = Provider.of<UserProfile>(
                                context,
                                listen: false);
                            userProfile.clearAll();
                            _userService.logoutUser();
                            Navigator.of(context, rootNavigator: true)
                                .pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (context) => Login()),
                                    (Route<dynamic> route) => false);
                          },
                          child: Text("Logout"),
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(color: Colors.green)),
                        )
                      ])
                    ],
                  ))),
          ),
        ),
        SliverToBoxAdapter(
          child: PromotionSlider(),
        ),
        if (_merchantAnalyticsMap != null)
          SliverToBoxAdapter(
              child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 10),
            child: Text(
              "Orders to handle",
              style: TextStyle(fontSize: 24, color: Colors.black87),
            ),
          )),
        if (_merchantAnalyticsMap != null)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      moveToOrders(0);
                    },
                    child: Container(
                      alignment: Alignment.topRight,
                      height: 120,
                      width: MediaQuery.of(context).size.width * 0.3,
                      decoration: new BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 1,
                              blurRadius: 2,
                              offset:
                                  Offset(0, 2), // changes position of shadow
                            ),
                          ],
                          borderRadius: new BorderRadius.all(
                            Radius.circular(12.0),
                          )),
                      child: Stack(
                        children: [
                          Image.asset(
                            'assets/home-icon1.png',
                            width: double.infinity,
                            fit: BoxFit.scaleDown,
                          ),
                          Container(
                            decoration: new BoxDecoration(
                                color: Colors.grey.withOpacity(0.3),
                                borderRadius: new BorderRadius.only(
                                  topLeft: Radius.circular(12.0),
                                  topRight: Radius.circular(12.0),
                                )),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  "Pending ",
                                  style: TextStyle(
                                      fontSize: 24, color: Colors.grey[800]),
                                ),
                                Text(
                                  _merchantAnalyticsMap.orderMap[
                                              OrderStatus.pending.index] ==
                                          null
                                      ? "0"
                                      : _merchantAnalyticsMap
                                          .orderMap[OrderStatus.pending.index]
                                          .toString(),
                                  style: TextStyle(
                                      fontSize: 32, color: Colors.black87),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      moveToOrders(1);
                    },
                    child: Container(
                      height: 120,
                      width: MediaQuery.of(context).size.width * 0.3,
                      decoration: new BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 1,
                              blurRadius: 2,
                              offset:
                                  Offset(0, 2), // changes position of shadow
                            ),
                          ],
                          borderRadius: new BorderRadius.all(
                            Radius.circular(12.0),
                          )),
                      child: Stack(
                        children: [
                          Image.asset(
                            'assets/home-icon2.png',
                            width: double.infinity,
                            fit: BoxFit.scaleDown,
                          ),
                          Container(
                            decoration: new BoxDecoration(
                                color: Colors.grey.withOpacity(0.3),
                                borderRadius: new BorderRadius.only(
                                  topLeft: Radius.circular(12.0),
                                  topRight: Radius.circular(12.0),
                                )),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  "Preparing ",
                                  style: TextStyle(
                                      fontSize: 24, color: Colors.grey[800]),
                                ),
                                Text(
                                  _merchantAnalyticsMap.orderMap[
                                              OrderStatus.preparing.index] ==
                                          null
                                      ? "0"
                                      : _merchantAnalyticsMap
                                          .orderMap[OrderStatus.preparing.index]
                                          .toString(),
                                  style: TextStyle(
                                      fontSize: 32, color: Colors.black87),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      moveToOrders(2);
                    },
                    child: Container(
                      height: 120,
                      width: MediaQuery.of(context).size.width * 0.3,
                      decoration: new BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 1,
                              blurRadius: 2,
                              offset:
                                  Offset(0, 2), // changes position of shadow
                            ),
                          ],
                          borderRadius: new BorderRadius.all(
                            Radius.circular(12.0),
                          )),
                      child: Stack(
                        children: [
                          Image.asset(
                            'assets/home-icon3.png',
                            width: double.infinity,
                            fit: BoxFit.scaleDown,
                          ),
                          Container(
                            decoration: new BoxDecoration(
                                color: Colors.grey.withOpacity(0.3),
                                borderRadius: new BorderRadius.only(
                                  topLeft: Radius.circular(12.0),
                                  topRight: Radius.circular(12.0),
                                )),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  "Ready to go ",
                                  style: TextStyle(
                                      fontSize: 24, color: Colors.grey[800]),
                                ),
                                Text(
                                  _merchantAnalyticsMap.orderMap[OrderStatus
                                              .readyToPickUp.index] ==
                                          null
                                      ? "0"
                                      : _merchantAnalyticsMap.orderMap[
                                              OrderStatus.readyToPickUp.index]
                                          .toString(),
                                  style: TextStyle(
                                      fontSize: 32, color: Colors.black87),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
      ]),
    );
  }

  moveToOrders(int tab) {
    TabNotifier tabNotifier = Provider.of<TabNotifier>(context, listen: false);
    tabNotifier.setOrderTab(tab);
    tabNotifier.tabController.jumpToTab(1);
  }

  updateShopStatus(int index) async {
    ShopStatus shopStatus;
    if (index == 0) {
      shopStatus = ShopStatus.active;
    } else {
      shopStatus = ShopStatus.closed;
    }
    await _shopService.updateShopStatus(shopStatus.index);
    _fetchShopDetails();
  }
}
