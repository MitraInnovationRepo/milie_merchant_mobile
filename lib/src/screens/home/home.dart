import 'package:flutter/material.dart';
import 'package:milie_merchant_mobile/src/data/enums/shop_status.dart';
import 'package:milie_merchant_mobile/src/data/model/analytics/merchant_analytics_map.dart';
import 'package:milie_merchant_mobile/src/data/model/shop.dart';
import 'package:milie_merchant_mobile/src/data/model/user_profile.dart';
import 'package:milie_merchant_mobile/src/screens/home/pending_order_chart.dart';
import 'package:milie_merchant_mobile/src/screens/home/promotion_slider.dart';
import 'package:milie_merchant_mobile/src/screens/order/order_requests.dart';
import 'package:milie_merchant_mobile/src/screens/shop/shop_service.dart';
import 'package:milie_merchant_mobile/src/services/analytics/analytics_service.dart';
import 'package:milie_merchant_mobile/src/services/service_locator.dart';
import 'package:provider/provider.dart';
import 'package:toggle_switch/toggle_switch.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<Home> {
  ShopService _shopService = locator<ShopService>();
  AnalyticsService _analyticsService = locator<AnalyticsService>();
  Shop _shop;
  MerchantAnalyticsMap _merchantAnalyticsMap;

  @override
  void initState() {
    super.initState();
    _fetchShopDetails();
    _getMerchantNotHandledOrders();
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
    MerchantAnalyticsMap _merchantAnalyticsMap =
        await this._analyticsService.findMerchantOrdersToComplete();
    setState(() {
      this._merchantAnalyticsMap = _merchantAnalyticsMap;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          brightness: Brightness.dark,
          toolbarHeight: 0.0,
        ),
        body: SingleChildScrollView(
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.only(bottom: 10),
                      child: (_shop == null
                          ? Container()
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ToggleSwitch(
                                  minWidth: 90.0,
                                  fontSize: 16.0,
                                  initialLabelIndex:
                                      _shop.status == ShopStatus.active.index
                                          ? 0
                                          : 1,
                                  activeBgColor:
                                      _shop.status == ShopStatus.active.index
                                          ? Colors.green
                                          : Colors.red,
                                  activeFgColor: Colors.white,
                                  inactiveBgColor: Colors.grey[400],
                                  inactiveFgColor: Colors.grey[900],
                                  labels: ['Active', 'Inactive'],
                                  onToggle: (index) {
                                    updateShopStatus(index);
                                  },
                                ),
                                Text(_shop.name + " - " + _shop.displayCity,
                                    style: TextStyle(fontSize: 22)),
                                _shop.status == 1
                                    ? Text("Online",
                                        style: TextStyle(
                                            color: Colors.green, fontSize: 18))
                                    : Text("Offline",
                                        style: TextStyle(
                                            color: Colors.red, fontSize: 18))
                              ],
                            )),
                    ),
                    Divider(),
                    PromotionSlider(),
                    Divider(),
                    if (_merchantAnalyticsMap != null)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 18.0),
                        child: Text(
                          "Orders to handle",
                          style: TextStyle(fontSize: 24, color: Colors.black87),
                        ),
                      ),
                    if (_merchantAnalyticsMap != null)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            alignment: Alignment.topRight,
                            height: 120,
                            width: MediaQuery.of(context).size.width * 0.3,
                            decoration: new BoxDecoration(
                                gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.grey[500],
                                      Colors.grey[100]
                                    ]),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.3),
                                    spreadRadius: 3,
                                    blurRadius: 10,
                                    offset: Offset(
                                        0, 2), // changes position of shadow
                                  ),
                                ],
                                borderRadius: new BorderRadius.all(
                                  Radius.circular(12.0),
                                )),
                            child: Stack(
                              children: [
                                Image.network(
                                  'https://i.imgur.com/EqrN0v8.png',
                                  width: double.infinity,
                                  fit: BoxFit.scaleDown,
                                ),
                                Container(
                                  color: Color(0xFFFFFFFF).withOpacity(0.5),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        "Pending ",
                                        style: TextStyle(
                                            fontSize: 24,
                                            color: Colors.grey[800]),
                                      ),
                                      Text(
                                        "3 ",
                                        style: TextStyle(
                                            fontSize: 32,
                                            color: Colors.black87),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: 120,
                            width: MediaQuery.of(context).size.width * 0.3,
                            decoration: new BoxDecoration(
                                gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.grey[500],
                                      Colors.grey[100]
                                    ]),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.3),
                                    spreadRadius: 3,
                                    blurRadius: 10,
                                    offset: Offset(
                                        0, 2), // changes position of shadow
                                  ),
                                ],
                                borderRadius: new BorderRadius.all(
                                  Radius.circular(12.0),
                                )),
                            child: Stack(
                              children: [
                                Image.network(
                                  'https://i.imgur.com/b8gVNI6.png',
                                  width: double.infinity,
                                  fit: BoxFit.scaleDown,
                                ),
                                Container(
                                  color: Color(0xFFFFFFFF).withOpacity(0.5),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        "Preparing ",
                                        style: TextStyle(
                                            fontSize: 24,
                                            color: Colors.grey[800]),
                                      ),
                                      Text(
                                        "4 ",
                                        style: TextStyle(
                                            fontSize: 32,
                                            color: Colors.black87),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: 120,
                            width: MediaQuery.of(context).size.width * 0.3,
                            decoration: new BoxDecoration(
                                gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.grey[500],
                                      Colors.grey[100]
                                    ]),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.3),
                                    spreadRadius: 3,
                                    blurRadius: 10,
                                    offset: Offset(
                                        0, 2), // changes position of shadow
                                  ),
                                ],
                                borderRadius: new BorderRadius.all(
                                  Radius.circular(12.0),
                                )),
                            child: Stack(
                              children: [
                                Image.network(
                                  'https://i.imgur.com/fATru6k.png',
                                  width: double.infinity,
                                  fit: BoxFit.scaleDown,
                                ),
                                Container(
                                  color: Color(0xFFFFFFFF).withOpacity(0.5),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        "Ready to go ",
                                        style: TextStyle(
                                            fontSize: 24,
                                            color: Colors.grey[800]),
                                      ),
                                      Text(
                                        "1 ",
                                        style: TextStyle(
                                            fontSize: 32,
                                            color: Colors.black87),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    // Row(
                    //   children: [
                    //     if (_merchantAnalyticsMap != null)
                    //       Column(
                    //         children: [
                    //           Container(
                    //             height:
                    //                 MediaQuery.of(context).size.height * 0.4,
                    //             width: MediaQuery.of(context).size.width * 0.45,
                    //             margin: EdgeInsets.only(top: 50),
                    //             child: PendingOrderChart.setup(
                    //                 _merchantAnalyticsMap),
                    //           ),
                    //           Text("ORDERS TO HANDLE")
                    //         ],
                    //       )
                    //   ],
                    // ),
                  ],
                ))));
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
