import 'package:flutter/material.dart';
import 'package:foodie_merchant/src/data/model/order_view.dart';
import 'package:foodie_merchant/src/screens/order/order_item.dart';

class PendingOrderNotifier extends ChangeNotifier{
  PendingOrderNotifier.empty();

  List<OrderItem> pendingOrderItems = [];

  addPendingOrder(OrderView orderView){
    bool orderAlreadyExist = false;
    pendingOrderItems.forEach((element) {
      if(element.order.id == orderView.id){
        orderAlreadyExist = true;
      }
    });
    if(!orderAlreadyExist) {
      OrderItem orderItem = OrderItem(
          false, // isExpanded ?
          orderView);
      pendingOrderItems.add(orderItem);
      notifyListeners();
    }
  }

  removePendingOrder(OrderView orderView){
    Iterable<OrderItem> filteredOrderItemList = this.pendingOrderItems.where((element) => element.order.id == orderView.id);
    if(filteredOrderItemList.isNotEmpty){
      OrderItem item = filteredOrderItemList.first;
      this.pendingOrderItems.remove(item);
    }
  }

  setPendingOrderItems(List<OrderView> _pendingOrderList){
    this.pendingOrderItems = [];
    _pendingOrderList.forEach((element) {
      OrderItem orderItem = OrderItem(
          false, // isExpanded ?
          element);
      pendingOrderItems.add(orderItem);
    });
    notifyListeners();
  }
}