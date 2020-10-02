import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:milie_merchant_mobile/src/data/model/order_detail_view.dart';
import 'package:milie_merchant_mobile/src/data/model/order_view.dart';

class OrderDetailsDialog extends StatelessWidget {
  final OrderView order;
  final List<OrderDetailView> orderDetailList;
  final double height;

  OrderDetailsDialog({Key key, this.order, this.orderDetailList, this.height})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Container(
            height: MediaQuery.of(context).size.height * height,
            width: MediaQuery.of(context).size.width * 0.8,
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: ListView.builder(
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.symmetric(vertical: 5.0),
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Column(
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Badge(
                                  badgeColor: Theme.of(context).primaryColor,
                                  position: BadgePosition.topRight(right: 3),
                                  animationDuration:
                                      Duration(milliseconds: 300),
                                  animationType: BadgeAnimationType.slide,
                                  badgeContent: Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: Text(
                                      orderDetailList[index]
                                          .quantity
                                          .toStringAsFixed(0),
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 16),
                                    ),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: CachedNetworkImage(
                                      imageUrl: orderDetailList[index]
                                          .product
                                          .imageUrl,
                                      height: 100.0,
                                      width: 100.0,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 20),
                                Container(
                                  constraints: BoxConstraints(
                                    maxHeight:
                                        MediaQuery.of(context).size.height *
                                            0.07,
                                    maxWidth:
                                        MediaQuery.of(context).size.width * 0.4,
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(orderDetailList[index].product.title,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16)),
                                      Text(
                                          '${order.currency} ' +
                                              orderDetailList[index]
                                                  .product
                                                  .unitPrice
                                                  .toStringAsFixed(2),
                                          style: TextStyle(fontSize: 14))
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Container(
                                child: Text(
                                    '${order.currency} ' +
                                        orderDetailList[index]
                                            .total
                                            .toStringAsFixed(2),
                                    style: TextStyle(fontSize: 14)))
                          ]),
                      if (orderDetailList[index].addonTotal > 0)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            for (var addon in orderDetailList[index].addonList)
                              Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.6,
                                  padding: EdgeInsets.only(
                                      top: 5.0, bottom: 5.0, left: 10.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(addon.productAddon.name,
                                          style: TextStyle(fontSize: 15)),
                                      SizedBox(width: 20),
                                      Text(
                                          '${order.currency} ' +
                                              addon.productAddon.price
                                                  .toStringAsFixed(2),
                                          style: TextStyle(fontSize: 15))
                                    ],
                                  ))
                          ],
                        ),
                      if (orderDetailList[index].additionalTotal > 0)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            for (var additional
                                in orderDetailList[index].additionalList)
                              Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.6,
                                  padding: EdgeInsets.only(
                                      top: 5.0, bottom: 5.0, left: 10.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(additional.productAdditional.name,
                                          style: TextStyle(fontSize: 14)),
                                      SizedBox(width: 20),
                                      Text(
                                          '${order.currency} ' +
                                              additional.productAdditional.price
                                                  .toStringAsFixed(2),
                                          style: TextStyle(fontSize: 14))
                                    ],
                                  ))
                          ],
                        ),
                      Divider(
                        thickness: 2.0,
                      )
                    ],
                  ),
                );
              },
              itemCount: orderDetailList.length,
            )));
  }
}
