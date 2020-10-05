import 'package:flutter/material.dart';
import 'package:milie_merchant_mobile/src/screens/order/pending_order.dart';
import 'package:milie_merchant_mobile/src/screens/order/pickup_ready_order.dart';
import 'package:milie_merchant_mobile/src/screens/order/preparing_order.dart';
import 'package:milie_merchant_mobile/src/screens/order/upcoming_order.dart';
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: TabbarHeader(
            backgroundColor: Theme.of(context).primaryColor,
            foregroundColor: Colors.white,
            indicatorColor: Theme.of(context).indicatorColor,
            controller: controller,
            tabs: [
              Tab(text: "PENDING"),
              Tab(text: "PREPARING"),
              Tab(text: "READY"),
              Tab(text: "UPCOMING")
            ],
          ),
        ),
      ),
      body: TabbarContent(
        controller: controller,
        children: <Widget>[
          PendingOrder(),
          PreparingOrder(),
          PickupReadyOrder(),
          UpcomingOrder()
        ],
      ),
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
