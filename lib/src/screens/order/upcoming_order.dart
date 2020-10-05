import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:milie_merchant_mobile/src/data/enums/delivery_option.dart';
import 'package:milie_merchant_mobile/src/data/enums/payment_option.dart';
import 'package:milie_merchant_mobile/src/data/model/order_detail_view.dart';
import 'package:milie_merchant_mobile/src/data/model/order_view.dart';
import 'package:milie_merchant_mobile/src/screens/order/order_content.dart';
import 'package:milie_merchant_mobile/src/screens/order/order_details_dialog.dart';
import 'package:milie_merchant_mobile/src/screens/order/order_item.dart';
import 'package:milie_merchant_mobile/src/services/order/order_service.dart';
import 'package:milie_merchant_mobile/src/services/service_locator.dart';
import 'package:milie_merchant_mobile/src/util/constant.dart';

import 'order_list_skeleton_view.dart';

class UpcomingOrder extends StatefulWidget {
  @override
  _UpcomingOrderPageState createState() => _UpcomingOrderPageState();
}

class _UpcomingOrderPageState extends State<UpcomingOrder> {
  bool enableProgress;
  OrderService _orderService = locator<OrderService>();
  List<OrderItem> _orderItemList = [];

  @override
  void initState() {
    super.initState();
    fetchPendingOrders();
  }

  fetchPendingOrders() async {
    setState(() {
      enableProgress = true;
    });

    List<OrderView> _orderList = await _orderService.findUpcomingOrders();
    if (mounted) {
      setState(() {
        setUpMerchantOrderList(_orderList);
        enableProgress = false;
      });
    }
  }

  setUpMerchantOrderList(List<OrderView> orderList) {
    orderList.forEach((element) {
      OrderItem orderItem = OrderItem(
          false, // isExpanded ?
          element // iconPic
          );
      _orderItemList.add(orderItem);
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
                height: MediaQuery.of(context).size.height,
                child: enableProgress
                    ? OrderListSkeletonView()
                    : _orderItemList.length > 0
                        ? Container(
                            height: MediaQuery.of(context).size.height,
                            child: ListView(
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(10.0),
                                  child: ExpansionPanelList(
                                    expansionCallback:
                                        (int index, bool isExpanded) {
                                      setState(() {
                                        _orderItemList[index].isExpanded =
                                            !_orderItemList[index].isExpanded;
                                      });
                                    },
                                    children:
                                        _orderItemList.map((OrderItem item) {
                                      return ExpansionPanel(
                                        canTapOnHeader: true,
                                        headerBuilder: (BuildContext context,
                                            bool isExpanded) {
                                          return ListTile(
                                              title: orderHeader(item.order));
                                        },
                                        isExpanded: item.isExpanded,
                                        body: OrderContent(
                                            order: item.order,
                                            showExpandedOrder: false),
                                      );
                                    }).toList(),
                                  ),
                                )
                              ],
                            ))
                        : Center(
                            child: Container(
                              child: Text("No upcoming orders at the moment"),
                            ),
                          ))));
  }

  Widget orderHeader(OrderView order) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: CachedNetworkImage(
                    imageUrl: ("https://i.imgur.com/i0V7RAr.png"),
                    fit: BoxFit.fill,
                    width: 50,
                  )
              ),
              CachedNetworkImage(
                imageUrl: (order.deliveryOption == DeliveryOptions.deliver.index
                    ? "https://i.imgur.com/Po93WEl.png"
                    : "https://i.imgur.com/buDFXBx.png"),
                fit: BoxFit.fill,
                width: 50,
              ),
              SizedBox(
                width: 15.0,
              ),
              ConstrainedBox(
                constraints: BoxConstraints(
                    minHeight: 55,
                    maxWidth: MediaQuery.of(context).size.width * 0.2),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Order #" + Constant.orderPrefix + order.id.toString(),
                      style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[600]),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Row(
                      children: [
                        Text(
                          order.orderDetailList.length.toString() +
                              (order.orderDetailList.length > 1
                                  ? " items"
                                  : " item"),
                          style: TextStyle(fontSize: 20.0),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        if (order.orderDetailList.length > 0)
                          Container(
                            width: 50,
                            height: 30,
                            child: InkWell(
                              onTap: () {
                                showOrderDetails(
                                    context, order, order.orderDetailList, 0.7);
                              },
                              child: Container(
                                width: 30.0,
                                child: Icon(
                                  Icons.shopping_cart,
                                  size: 30,
                                  color: Colors.orange[500],
                                ),
                              ),
                            ),
                          ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
          ConstrainedBox(
            constraints: BoxConstraints(
                minHeight: 55,
                maxWidth: MediaQuery.of(context).size.width * 0.27),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Ordered on: " +
                      DateFormat("yyyy-MM-dd hh:mm a")
                          .format(order.createdDate),
                  style: TextStyle(fontSize: 18.0),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  "For: " + order.user.name,
                  style: TextStyle(fontSize: 18.0),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(
                  height: 5.0,
                ),
              ],
            ),
          ),
          SizedBox(
            width: 15.0,
          ),
          ConstrainedBox(
            constraints: BoxConstraints(
                minHeight: 55,
                maxWidth: MediaQuery.of(context).size.width * 0.15),
            child: RichText(
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              text: TextSpan(
                text: order.currency,
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.black,
                ),
                children: <TextSpan>[
                  TextSpan(text: ' '),
                  TextSpan(text: order.subTotal.toStringAsFixed(2)),
                  TextSpan(text: " ("),
                  TextSpan(
                    text: (PaymentOption.values
                            .where((element) =>
                                element.index == order.paymentMethod)
                            .toString()
                            .replaceAll(")", "")
                            .split('.')
                            .last)
                        .toUpperCase(),
                  ),
                  TextSpan(text: ')')
                ],
              ),
            ),
          ),
        ],
      ),
    );
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
