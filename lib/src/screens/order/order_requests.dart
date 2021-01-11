import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:foodie_merchant/src/data/enums/order_status.dart';
import 'package:foodie_merchant/src/data/model/analytics/merchant_analytics_map.dart';
import 'package:foodie_merchant/src/data/notifier/orders_to_handler_notifier.dart';
import 'package:foodie_merchant/src/data/notifier/tab_notifier.dart';
import 'package:foodie_merchant/src/screens/order/pending_order.dart';
import 'package:foodie_merchant/src/screens/order/pickup_ready_order.dart';
import 'package:foodie_merchant/src/screens/order/preparing_order.dart';
import 'package:foodie_merchant/src/screens/order/upcoming_order.dart';
import 'package:foodie_merchant/src/services/analytics/analytics_service.dart';
import 'package:foodie_merchant/src/services/service_locator.dart';
import 'package:provider/provider.dart';
import 'package:tabbar/tabbar.dart';

class OrderRequests extends StatefulWidget {
  @override
  _OrderRequestsPageState createState() => _OrderRequestsPageState();
}

class _OrderRequestsPageState extends State<OrderRequests> {
  final controller = PageController();

  @override
  void initState() {
    super.initState();
    Provider.of<TabNotifier>(context, listen: false).addListener(_tabChange);
  }

  _tabChange() {
    TabNotifier tabNotifier = Provider.of<TabNotifier>(context, listen: false);
    this.controller.jumpToPage(tabNotifier.currentOrderTab);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
        bottom: PreferredSize(
            preferredSize: Size.fromHeight(1),
            child: Consumer<OrdersToHandleNotifier>(
                builder: (context, ordersToHandleNotifier, child) {
              return TabbarHeader(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                indicatorColor: Theme.of(context).indicatorColor,
                controller: controller,
                tabs: [
                  Tab(icon: orderCountHeader("PENDING", ordersToHandleNotifier.pendingCount ?? 0)),
                  Tab(icon: orderCountHeader("PREPARING", ordersToHandleNotifier.preparingCount ?? 0)),
                  Tab(icon: orderCountHeader("READY", ordersToHandleNotifier.readyCount ?? 0)),
                  Tab(icon: orderCountHeader("UPCOMING", ordersToHandleNotifier.scheduledCount ?? 0)),
                ],
              );
            })),
      ),
      body: TabbarContent(
        controller: controller,
        children: <Widget>[
          PendingOrder(this.controller),
          PreparingOrder(this.controller),
          PickupReadyOrder(),
          UpcomingOrder()
        ],
      ),
    );
  }

  Widget orderCountHeader(String text, int count){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Text(
            text
          ),
        ),
        Badge(
          position: BadgePosition.topRight(
              top: 0, right: 3),
          animationDuration:
          Duration(milliseconds: 300),
          animationType: BadgeAnimationType.slide,
          badgeContent: Text(
            count.toString(),
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}

class OrderHistoryItem {
  bool isExpanded;
  final Widget header;
  final Widget body;
  final Icon icon;

  OrderHistoryItem(this.isExpanded, this.header, this.body, this.icon);
}
