import 'package:flutter/cupertino.dart';
import 'package:foodie_merchant/src/data/enums/order_status.dart';
import 'package:foodie_merchant/src/data/model/analytics/merchant_analytics_map.dart';

class OrdersToHandleNotifier extends ChangeNotifier {
  OrdersToHandleNotifier.empty();

  int pendingCount = 0;
  int preparingCount = 0;
  int readyCount = 0;
  int scheduledCount = 0;

  setPending(int count) {
    this.pendingCount = count;
    notifyListeners();
  }

  setPreparing(int count) {
    this.preparingCount = count;
    notifyListeners();
  }

  setReady(int count) {
    this.readyCount = count;
    notifyListeners();
  }

  setSchedule(int count) {
    this.scheduledCount = count;
    notifyListeners();
  }

  setAllCounts(MerchantAnalyticsMap merchantAnalyticsMap) {
    pendingCount = merchantAnalyticsMap.orderMap[OrderStatus.pending.index];
    preparingCount = merchantAnalyticsMap.orderMap[OrderStatus.preparing.index];
    readyCount = merchantAnalyticsMap.orderMap[OrderStatus.readyToPickUp.index];
    scheduledCount = merchantAnalyticsMap.orderMap[99];
    notifyListeners();
  }
}
