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

class PreparingOrder extends StatefulWidget {
  @override
  _PreparingOrderPageState createState() => _PreparingOrderPageState();
}

class _PreparingOrderPageState extends State<PreparingOrder> {
  List<OrderView> _preparingOrderList = [];
  List<OrderItem> _preparingOrderItems = [];
  bool enableProgress = false;
  OrderService _orderService = locator<OrderService>();
  bool orderProcessing = false;

  @override
  void initState() {
    super.initState();
    fetchPreparingOrders();
  }

  fetchPreparingOrders() async {
    setState(() {
      enableProgress = true;
    });

    List<OrderView> _preparingOrderList =
        await _orderService.findMerchantOrder(OrderStatus.preparing.index);
    if (mounted) {
      setState(() {
        this._preparingOrderList = _preparingOrderList;
        setupPreparingOrderItemList();
        enableProgress = false;
      });
    }
  }

  setupPreparingOrderItemList() {
    _preparingOrderItems = [];
    _preparingOrderList.forEach((element) {
      OrderItem orderItem = OrderItem(false, element);
      _preparingOrderItems.add(orderItem);
    });
  }

  @override
  Widget build(BuildContext context) {
    return enableProgress
        ? OrderListSkeletonView()
        : _preparingOrderItems.length > 0
            ? Container(
                height: MediaQuery.of(context).size.height,
                child: ListView(children: [
                  Padding(
                      padding: EdgeInsets.all(10.0),
                      child: ExpansionPanelList(
                        expansionCallback: (int index, bool isExpanded) {
                          setState(() {
                            _preparingOrderItems[index].isExpanded =
                                !_preparingOrderItems[index].isExpanded;
                          });
                        },
                        children: _preparingOrderItems.map((OrderItem item) {
                          return ExpansionPanel(
                            canTapOnHeader: true,
                            headerBuilder:
                                (BuildContext context, bool isExpanded) {
                              return ListTile(
                                  title: OrderHeader(
                                      order: item.order,
                                      showOrderDetails: showOrderDetails));
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
                                        "FOOD IS READY", updateToFoodIsReady),
                                    showOrderDetails: showOrderDetails),
                          );
                        }).toList(),
                      ))
                ]))
            : Center(
                child: Container(
                  child: Text("No preparing orders at the moment"),
                ),
              );
  }

  updateToFoodIsReady(OrderView order) async {
    setState(() {
      orderProcessing = true;
    });
    int status = await _orderService.updateOrderToFoodReady(order.id);
    setState(() {
      orderProcessing = false;
    });
    if (status == 200) {
      showSimpleNotification(
        Text("Order is updated to Food Ready"),
        background: Theme.of(context).backgroundColor,
      );
      fetchPreparingOrders();
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
