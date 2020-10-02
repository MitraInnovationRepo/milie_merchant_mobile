import 'package:milie_merchant_mobile/src/data/model/order_view.dart';

class OrderItem{
  bool isExpanded;
  OrderView order;

  OrderItem(this.isExpanded, this.order);
}