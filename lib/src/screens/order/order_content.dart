import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodie_merchant/src/data/enums/delivery_option.dart';
import 'package:foodie_merchant/src/data/model/order_detail_view.dart';
import 'package:foodie_merchant/src/data/model/order_view.dart';
import 'package:foodie_merchant/src/screens/util/driver_info_card.dart';
import 'package:foodie_merchant/src/screens/widget/square_button.dart';
import 'package:foodie_merchant/src/data/enums/payment_option.dart';
import 'package:foodie_merchant/src/util/constant.dart';

class OrderAction {
  String title;
  Function action;

  OrderAction(this.title, this.action);
}

class OrderContent extends StatelessWidget {
  final OrderView order;
  final OrderAction primaryAction;
  final OrderAction secondaryAction;
  final Function showOrderDetails;
  final bool showExpandedOrder;

  OrderContent(
      {Key key,
      this.order,
      this.primaryAction,
      this.secondaryAction,
      this.showOrderDetails,
      this.showExpandedOrder})
      : super(key: key);



  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
      child: Column(
        children: [
          Divider(
            color: Colors.black54,
            height: 5.0,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (order.foodPreparedTime != null &&
                  order.deliveryOption == DeliveryOptions.deliver.index)
                Padding(
                  padding:
                      const EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
                  child: Row(
                    children: [
                      Text("Rider: ",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                              fontSize: 20)),
                      SizedBox(
                        width: 10.0,
                      ),
                      DriverInfoCard(cabNo: order.cabNo),
                    ],
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CostDetails(order: order),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              if (primaryAction != null)
                                InkWell(
                                  onTap: () => primaryAction.action(order),
                                  child: SquareButton(
                                      title: primaryAction.title,
                                      backgroundColor:
                                          Theme.of(context).accentColor),
                                ),
                              SizedBox(
                                width: 50.0,
                              ),
                              if (secondaryAction != null)
                                InkWell(
                                  onTap: () => secondaryAction.action(order),
                                  child: SquareButton(
                                      title: secondaryAction.title,
                                      backgroundColor:
                                          Theme.of(context).primaryColor),
                                ),
                            ],
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                      padding: EdgeInsets.all(6),
                                      child: Text(order.user.name,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold))),
                                  Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.2,
                                      padding: EdgeInsets.all(6),
                                      child: Text(order.address,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                          style: TextStyle(
                                              color: Colors.black54,
                                              fontSize: 16))),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.phone,
                                        size: 20,
                                        color: Colors.black54,
                                      ),
                                      SizedBox(
                                        width: 5.0,
                                      ),
                                      InkWell(
                                        child: new Text(order.user.phoneNumber,
                                            style: TextStyle(
                                                color: Colors.black54,
                                                fontSize: 16)),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: 20.0,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                color: Colors.grey[400],
                height: 5.0,
              ),
              SizedBox(
                height: 5.0,
              ),
              if (showExpandedOrder)
                SingleChildScrollView(
                  child: Container(
                    child: Column(
                      children: [
                        for (OrderDetailView orderDetail
                            in order.orderDetailList)
                          OrderDetails(
                              order: order,
                              orderDetail: orderDetail,
                              showOrderDetails: showOrderDetails)
                      ],
                    ),
                  ),
                )
            ],
          )
        ],
      ),
    );
  }
}

class OrderDetails extends StatelessWidget {
  final OrderView order;
  final OrderDetailView orderDetail;
  final Function showOrderDetails;

  OrderDetails({Key key, this.order, this.orderDetail, this.showOrderDetails})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return (Container(
      color: Colors.white,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(top: 10.0),
      padding: EdgeInsets.symmetric(vertical: 15.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width - 250,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      color: Colors.grey[100],
                      padding: EdgeInsets.all(8.0),
                      child: Image.network(
                        "${Constant.filePath}${orderDetail.product.imageUrl}",
                        height: 40.0,
                        width: 45.0,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Text(" ×  " + orderDetail.quantity.toStringAsFixed(0),
                        style: TextStyle(fontSize: 22.0)),
                    SizedBox(
                      width: 25.0,
                    ),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(orderDetail.product.title,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: TextStyle(
                                  fontSize: 20.0, fontWeight: FontWeight.bold)),
                          SizedBox(
                            height: 5.0,
                          ),
                          Text(
                              "Additional charge : " +
                                  orderDetail.additionalTotal
                                      .toStringAsFixed(2),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: TextStyle(
                                  fontSize: 16.0, color: Colors.grey[500])),
                          SizedBox(
                            height: 5.0,
                          ),
                          Text(
                              "Add-ons : " +
                                  orderDetail.addonTotal.toStringAsFixed(2),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: TextStyle(
                                  fontSize: 16.0, color: Colors.grey[500])),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 25.0,
                    )
                  ],
                ),
              ),
              Flexible(
                child: Text(orderDetail.total.toStringAsFixed(2),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: TextStyle(fontSize: 18.0)),
              ),
              if (orderDetail.additionalList.length > 0 ||
                  orderDetail.addonList.length > 0)
                InkWell(
                    onTap: () {
                      List<OrderDetailView> orderDetailList = [];
                      orderDetailList.add(orderDetail);
                      showOrderDetails(context, order, orderDetailList, 0.3);
                    },
                    child: Container(
                      child: Icon(
                        Icons.info,
                        size: 35,
                        color: Colors.blue[300],
                      ),
                    ))
            ],
          ),
          SizedBox(
            height: 10.0,
          ),
          if (orderDetail.description != null &&
              orderDetail.description.isNotEmpty)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Note: ",
                    style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.0)),
                SizedBox(
                  width: 10.0,
                ),
                Flexible(
                    child: Text(orderDetail.description,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(fontSize: 16.0)))
              ],
            )
        ],
      ),
    ));
  }
}

class CostDetails extends StatelessWidget {
  final OrderView order;

  CostDetails({Key key, this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
          minHeight: 160, maxWidth: MediaQuery.of(context).size.width * 0.5),
      child: (Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          RichText(
            text: TextSpan(
              text: 'Total Items: ',
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.black54,
              ),
              children: <TextSpan>[
                TextSpan(
                    text: order.orderDetailList.length.toString(),
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          RichText(
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            text: TextSpan(
              text: 'Item Total: ',
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.black54,
              ),
              children: <TextSpan>[
                TextSpan(
                    text: order.itemTotal.toStringAsFixed(2),
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          RichText(
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            text: TextSpan(
              text: 'Additional Charges : ',
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.black54,
              ),
              children: <TextSpan>[
                TextSpan(
                    text: (order.addonTotal + order.additionalTotal)
                        .toStringAsFixed(2),
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          RichText(
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            text: TextSpan(
              text: 'Sub Total: ',
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.black54,
              ),
              children: <TextSpan>[
                TextSpan(
                    text: order.subTotal.toStringAsFixed(2),
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          RichText(
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            text: TextSpan(
              text: 'Delivery Method: ',
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.black54,
              ),
              children: <TextSpan>[
                TextSpan(
                    text: (order.deliveryOption == DeliveryOptions.deliver.index
                        ? "Rider Pick Up"
                        : "Customer Pick Up"),
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          RichText(
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            text: TextSpan(
              text: 'Payment Method: ',
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.black54,
              ),
              children: <TextSpan>[
                TextSpan(
                    text: (PaymentOption.values
                            .where((element) =>
                                element.index == order.paymentMethod)
                            .toString()
                            .replaceAll(")", "")
                            .split('.')
                            .last)
                        .toUpperCase(),
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      )),
    );
  }
}
