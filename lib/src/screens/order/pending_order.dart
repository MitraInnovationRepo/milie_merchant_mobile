import 'package:flutter/material.dart';
import 'package:milie_merchant_mobile/src/data/enums/order_status.dart';
import 'package:milie_merchant_mobile/src/data/model/order_detail_view.dart';
import 'package:milie_merchant_mobile/src/data/model/order_view.dart';
import 'package:milie_merchant_mobile/src/screens/order/order_content.dart';
import 'package:milie_merchant_mobile/src/screens/order/order_details_dialog.dart';
import 'package:milie_merchant_mobile/src/screens/order/order_header.dart';
import 'package:milie_merchant_mobile/src/screens/order/order_list_skeleton_view.dart';
import 'package:milie_merchant_mobile/src/services/order/order_service.dart';
import 'package:milie_merchant_mobile/src/services/service_locator.dart';
import 'package:overlay_support/overlay_support.dart';

import 'order_item.dart';

class PendingOrder extends StatefulWidget {
  @override
  _PendingOrderPageState createState() => _PendingOrderPageState();
}

class _PendingOrderPageState extends State<PendingOrder> {
  List<OrderView> _pendingOrderList = [];
  List<OrderItem> _pendingOrderItems = [];
  bool enableProgress = false;
  OrderService _orderService = locator<OrderService>();

  @override
  void initState() {
    super.initState();
    fetchPendingOrders();
  }

  fetchPendingOrders() async {
    setState(() {
      enableProgress = true;
    });

    List<OrderView> _pendingOrderList =
        await _orderService.findMerchantOrder(OrderStatus.pending.index);
    if (mounted) {
      setState(() {
        this._pendingOrderList = _pendingOrderList;
        setupPendingOrderItemList();
        enableProgress = false;
      });
    }
  }

  setupPendingOrderItemList() {
    _pendingOrderList.forEach((element) {
      OrderItem orderItem = OrderItem(
          false, // isExpanded ?
          element);
      _pendingOrderItems.add(orderItem);
    });
  }

  @override
  Widget build(BuildContext context) {
    return enableProgress
        ? OrderListSkeletonView()
        : Container(
            height: MediaQuery.of(context).size.height * 0.5,
            child: ListView(
              children: [
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: ExpansionPanelList(
                    expansionCallback: (int index, bool isExpanded) {
                      setState(() {
                        _pendingOrderItems[index].isExpanded =
                            !_pendingOrderItems[index].isExpanded;
                      });
                    },
                    children: _pendingOrderItems.map((OrderItem item) {
                      return ExpansionPanel(
                        canTapOnHeader: true,
                        headerBuilder: (BuildContext context, bool isExpanded) {
                          return ListTile(
                              title: OrderHeader(
                                  order: item.order,
                                  showOrderDetails: showOrderDetails));
                        },
                        isExpanded: item.isExpanded,
                        body: OrderContent(
                            showExpandedOrder: true,
                            order: item.order,
                            primaryAction: OrderAction("ACCEPT", acceptOrder),
                            secondaryAction: OrderAction("REJECT", rejectOrder),
                            showOrderDetails: showOrderDetails),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ));
  }

  acceptOrder(OrderView order) async {
    int status = await _orderService.approveOrder(order.id);
    if (status == 200) {
      showSimpleNotification(
        Text("Order Approved"),
        background: Theme.of(context).backgroundColor,
      );
      fetchPendingOrders();
    }
  }

  rejectOrder(OrderView order) async {
    int status = await _orderService.rejectOrder(order.id);
    if (status == 200) {
      showSimpleNotification(
        Text("Order Rejected"),
        background: Colors.amber,
      );
      fetchPendingOrders();
    }
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
}
