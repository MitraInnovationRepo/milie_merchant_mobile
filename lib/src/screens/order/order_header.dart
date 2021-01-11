import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodie_merchant/src/data/enums/delivery_option.dart';
import 'package:foodie_merchant/src/data/model/order_view.dart';
import 'package:foodie_merchant/src/util/constant.dart';
import 'package:intl/intl.dart';
import 'package:foodie_merchant/src/data/enums/payment_option.dart';

class OrderHeader extends StatelessWidget {
  final OrderView order;
  final Function showOrderDetails;

  OrderHeader({Key key, this.order, this.showOrderDetails}) : super(key: key);

  Widget buildTime(title, time, icon, iconColor) {
    return (Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              color: iconColor,
            ),
            SizedBox(
              width: 5.0,
            ),
            Text(
              title,
              style: TextStyle(fontSize: 18.0),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        SizedBox(
          height: 5.0,
        ),
        Text(
          DateFormat("yyyy-MM-dd").format(time) +
              " at " +
              DateFormat("hh.mm a").format(time),
          style: TextStyle(fontSize: 20.0),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Image.asset(
                order.deliveryOption == DeliveryOptions.deliver.index
                    ? "assets/lorry.png"
                    : "assets/store-pickup.png",
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
              if (order.scheduleDelivery)
                Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Image.asset(
                      "assets/bell.png",
                      fit: BoxFit.fill,
                      width: 40,
                    )),
              if (order.scheduleDelivery)
              Text(
                DateFormat("yyyy-MM-dd hh:mm a")
                    .format(order.scheduledTime),
                style: TextStyle(fontSize: 20.0),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          ConstrainedBox(
              constraints: BoxConstraints(
                  minHeight: 55,
                  maxWidth: MediaQuery.of(context).size.width * 0.3),
              child: (Wrap(
                children: [
                  if (order.orderAcceptedTime != null &&
                      order.foodPreparedTime == null)
                    buildTime("Accepted at: ", order.orderAcceptedTime,
                        Icons.playlist_add_check, Colors.yellow[800])
                  else if (order.orderAcceptedTime != null &&
                      order.foodPreparedTime != null)
                    buildTime("Food Prepared Time: ", order.foodPreparedTime,
                        Icons.check_box, Colors.green[500])
                ],
              ))),
          ConstrainedBox(
            constraints: BoxConstraints(
                minHeight: 55,
                maxWidth: MediaQuery.of(context).size.width * 0.24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "For: " + order.user.name,
                  style: TextStyle(fontSize: 18.0),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(
                  height: 5.0,
                ),
                RichText(
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  text: TextSpan(
                    text: order.currency,
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.black,
                    ),
                    children: <TextSpan>[
                      TextSpan(text: ' '),
                      TextSpan(text: order.itemSubTotal.toStringAsFixed(2)),
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
