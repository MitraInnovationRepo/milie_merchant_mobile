import 'package:flutter/material.dart';
import 'package:foodie_merchant/src/data/enums/delivery_option.dart';
import 'package:foodie_merchant/src/data/enums/order_status.dart';
import 'package:foodie_merchant/src/data/model/order_detail_view.dart';
import 'package:foodie_merchant/src/data/model/order_view.dart';
import 'package:foodie_merchant/src/screens/order/order_content.dart';
import 'package:foodie_merchant/src/screens/order/order_details_dialog.dart';
import 'package:foodie_merchant/src/screens/order/order_header.dart';
import 'package:foodie_merchant/src/services/order/order_service.dart';
import 'package:foodie_merchant/src/services/service_locator.dart';
import 'package:overlay_support/overlay_support.dart';

import 'order_item.dart';
import 'order_list_skeleton_view.dart';

class PickupReadyOrder extends StatefulWidget {
  @override
  _PickupReadyOrderPageState createState() => _PickupReadyOrderPageState();
}

class _PickupReadyOrderPageState extends State<PickupReadyOrder> {
  List<OrderView> _readyToPickupOrderList = [];
  List<OrderItem> _readyToPickupOrderItems = [];
  bool enableProgress = false;
  OrderService _orderService = locator<OrderService>();
  bool orderProcessing = false;

  @override
  void initState() {
    super.initState();
    fetchReadyToPickupOrders();
  }

  Future<void> fetchReadyToPickupOrders() async {
    setState(() {
      enableProgress = true;
    });

    List<OrderView> _readyToPickupOrderList =
        await _orderService.findMerchantOrder(OrderStatus.readyToPickUp.index);
    if (mounted) {
      setState(() {
        this._readyToPickupOrderList = _readyToPickupOrderList;
        setupReadyToPickupOrderItemList();
        enableProgress = false;
      });
    }
    return Future<void>(() {});
  }

  setupReadyToPickupOrderItemList() {
    _readyToPickupOrderItems = [];
    _readyToPickupOrderList.forEach((element) {
      OrderItem orderItem = OrderItem(
          false, // isExpanded ?
          element);
      _readyToPickupOrderItems.add(orderItem);
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        child: enableProgress
            ? OrderListSkeletonView()
            : _readyToPickupOrderItems.length > 0
                ? Container(
                    height: MediaQuery.of(context).size.height,
                    child: ListView(
                      children: [
                        Padding(
                            padding: EdgeInsets.all(10.0),
                            child: ExpansionPanelList(
                              expansionCallback: (int index, bool isExpanded) {
                                setState(() {
                                  _readyToPickupOrderItems[index].isExpanded =
                                      !_readyToPickupOrderItems[index]
                                          .isExpanded;
                                });
                              },
                              children: _readyToPickupOrderItems
                                  .map((OrderItem item) {
                                return ExpansionPanel(
                                  canTapOnHeader: true,
                                  headerBuilder:
                                      (BuildContext context, bool isExpanded) {
                                    return ListTile(
                                        title: OrderHeader(
                                      order: item.order,
                                      showOrderDetails: showOrderDetails,
                                    ));
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
                                              item.order.deliveryOption ==
                                                      DeliveryOptions
                                                          .pickup.index
                                                  ? "ORDER COMPLETE"
                                                  : "PICKED UP BY RIDER",
                                              completeOrder),
                                          showOrderDetails: showOrderDetails,
                                          isHistory: false),
                                );
                              }).toList(),
                            ))
                      ],
                    ))
                : Container(
                    height: MediaQuery.of(context).size.height,
                    child: ListView(children: [
                      Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: Text("No pick up ready orders at the moment",
                              textAlign: TextAlign.center))
                    ])),
        onRefresh: fetchReadyToPickupOrders);
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

  void completeOrder(OrderView order) async {
    setState(() {
      orderProcessing = true;
    });
    if (order.deliveryOption == DeliveryOptions.pickup.index) {
      int status =
          await this._orderService.updateOrderToOrderDelivered(order.id);
      setState(() {
        orderProcessing = false;
      });
      if (status == 200) {
        showSimpleNotification(
          Text("Order successfully delivered"),
          background: Theme.of(context).backgroundColor,
        );
      }
    } else {
      int status = await this._orderService.updateOrderToRiderPicked(order.id);
      setState(() {
        orderProcessing = false;
      });
      if (status == 200) {
        showSimpleNotification(
          Text("Order successfully delivered to the rider"),
          background: Theme.of(context).backgroundColor,
        );
      }
    }
    fetchReadyToPickupOrders();
  }
}
