import 'package:flutter/material.dart';
import 'package:foodie_merchant/src/data/model/order_detail_view.dart';
import 'package:foodie_merchant/src/data/model/order_reject_response.dart';
import 'package:foodie_merchant/src/data/model/order_view.dart';
import 'package:foodie_merchant/src/data/notifier/pending_order_notifier.dart';
import 'package:foodie_merchant/src/screens/order/order_content.dart';
import 'package:foodie_merchant/src/screens/order/order_details_dialog.dart';
import 'package:foodie_merchant/src/screens/order/order_header.dart';
import 'package:foodie_merchant/src/screens/order/order_list_skeleton_view.dart';
import 'package:foodie_merchant/src/screens/order/order_requests.dart';
import 'package:foodie_merchant/src/services/order/order_service.dart';
import 'package:foodie_merchant/src/services/service_locator.dart';
import 'package:foodie_merchant/src/util/constant.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';

import 'order_item.dart';

class PendingOrder extends StatefulWidget {
  PendingOrder(this.controller);

  final PageController controller;

  @override
  _PendingOrderPageState createState() => _PendingOrderPageState();
}

class _PendingOrderPageState extends State<PendingOrder> {
  List<OrderView> _pendingOrderList = [];
  bool enableProgress = false;
  OrderService _orderService = locator<OrderService>();
  bool orderProcessing = false;
  PageController controller;

  @override
  void initState() {
    super.initState();
    this.controller = widget.controller;
  }

  Future<void> fetchPendingOrders() async {
    setState(() {
      enableProgress = true;
    });

    List<OrderView> _pendingOrderList = await _orderService.findPendingOrders();
    if (mounted) {
      setState(() {
        this._pendingOrderList = _pendingOrderList;
        setupPendingOrderItemList();
        enableProgress = false;
      });
    }
    return Future<void>(() {});
  }

  setupPendingOrderItemList() {
    PendingOrderNotifier pendingOrderNotifier =
        Provider.of<PendingOrderNotifier>(context, listen: false);
    pendingOrderNotifier.setPendingOrderItems(_pendingOrderList);
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        child: Consumer<PendingOrderNotifier>(
            builder: (context, pendingOrderNotifier, child) {
          return enableProgress
              ? OrderListSkeletonView()
              : Provider.of<PendingOrderNotifier>(context)
                          .pendingOrderItems
                          .length >
                      0
                  ? Container(
                      height: MediaQuery.of(context).size.height * 0.8,
                      child: ListView(children: [
                        Padding(
                            padding: EdgeInsets.all(10.0),
                            child: ExpansionPanelList(
                              expansionCallback: (int index, bool isExpanded) {
                                setState(() {
                                  pendingOrderNotifier
                                          .pendingOrderItems[index].isExpanded =
                                      !pendingOrderNotifier
                                          .pendingOrderItems[index].isExpanded;
                                });
                              },
                              children: pendingOrderNotifier.pendingOrderItems
                                  .map((OrderItem item) {
                                return ExpansionPanel(
                                  canTapOnHeader: true,
                                  headerBuilder:
                                      (BuildContext context, bool isExpanded) {
                                    return ListTile(
                                        title: OrderHeader(
                                            order: item.order,
                                            showOrderDetails:
                                                showOrderDetails));
                                  },
                                  isExpanded: item.isExpanded,
                                  body: orderProcessing
                                      ? Center(
                                          child: LinearProgressIndicator(),
                                        )
                                      : OrderContent(
                                          showExpandedOrder: true,
                                          order: item.order,
                                          primaryAction: OrderAction(
                                              "ACCEPT", acceptOrder),
                                          secondaryAction: OrderAction(
                                              "REJECT", rejectOrder),
                                          showOrderDetails: showOrderDetails,
                                          isHistory: false),
                                );
                              }).toList(),
                            ))
                      ]))
                  : Container(
                      height: MediaQuery.of(context).size.height,
                      child: ListView(children: [
                        Padding(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: Text("No pending orders at the moment",
                                textAlign: TextAlign.center))
                      ]));
        }),
        onRefresh: fetchPendingOrders);
  }

  acceptOrder(OrderView order) async {
    setState(() {
      orderProcessing = true;
    });
    OrderRejectResponse orderRejectResponse =
        await _orderService.approveOrder(order.id);
    setState(() {
      orderProcessing = false;
    });
    if (orderRejectResponse.status != 100) {
      showSimpleNotification(
        Text("Order Approved"),
        background: Theme.of(context).backgroundColor,
      );
      this.controller.jumpToPage(1);
    } else {
      showSimpleNotification(Text(orderRejectResponse.message),
          background: Colors.amber);
    }
    fetchPendingOrders();
  }

  rejectOrder(OrderView order) async {
    showRejectConfirmationDialog(context, order);
  }

  void showOrderDetails(BuildContext context, OrderView order,
      List<OrderDetailView> orderDetailList, double height) {
    showDialog(
        context: context,
        builder: (BuildContext context) => OrderDetailsDialog(
              orderDetailList: orderDetailList,
              height: height,
              order: order,
            ));
  }

  showRejectConfirmationDialog(BuildContext context, OrderView order) {
    Widget cancelButton = FlatButton(
      child: Text("Dismiss"),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop('dialog');
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Continue"),
      onPressed: () async {
        OrderRejectResponse orderRejectResponse =
            await _orderService.rejectOrder(order.id);
        if (orderRejectResponse.status != 100) {
          showSimpleNotification(
            Text("Order Rejected"),
            background: Theme.of(context).backgroundColor,
          );
        } else {
          showSimpleNotification(Text(orderRejectResponse.message),
              background: Colors.amber);
        }
        Navigator.of(context, rootNavigator: true).pop('dialog');
        fetchPendingOrders();
      },
    );

    AlertDialog alert = AlertDialog(
      title: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Icon(Icons.no_food),
          ),
          Text("Cancel Order"),
        ],
      ),
      content: Text(
          "Would you like to cancel order ${Constant.orderPrefix}${order.id}"),
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
}
