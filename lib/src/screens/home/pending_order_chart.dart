import 'package:flutter/cupertino.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:milie_merchant_mobile/src/data/enums/order_status.dart';
import 'package:milie_merchant_mobile/src/data/model/analytics/merchant_analytics_map.dart';

class PendingOrderChart extends StatelessWidget{
  final List<charts.Series> seriesList;
  final bool animate;

  PendingOrderChart(this.seriesList, {this.animate});

  factory PendingOrderChart.setup(MerchantAnalyticsMap _merchantAnalyticsMap) {
    return new PendingOrderChart(
      _setupData(_merchantAnalyticsMap),
      animate: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new charts.PieChart(seriesList,
        animate: animate,
      behaviors: [
        new charts.DatumLegend(
          position: charts.BehaviorPosition.end,
          horizontalFirst: false,
          cellPadding: new EdgeInsets.only(right: 4.0, bottom: 4.0),
          showMeasures: true,
          legendDefaultMeasure: charts.LegendDefaultMeasure.firstValue,
          measureFormatter: (num value) {
            return value == null ? '-' : '${value}';
          },
        ),
      ]);
  }

  static List<charts.Series<PendingOrders, String>> _setupData(MerchantAnalyticsMap _merchantAnalyticsMap) {
    List<PendingOrders> data = [];

    _merchantAnalyticsMap.orderMap.forEach((key, value) {
        data.add(new PendingOrders(key, value));
    });

    return [
      new charts.Series<PendingOrders, String>(
        id: 'Orders',
        domainFn: (PendingOrders orders, _) => orders.orderStatus,
        measureFn: (PendingOrders orders, _) => orders.orderCount,
        data: data,
        labelAccessorFn: (PendingOrders row, _) => '${row.orderStatus}: ${row.orderCount}',
      )
    ];
  }
}

class PendingOrders {
  final String orderStatus;
  final int orderCount;

  PendingOrders(this.orderStatus, this.orderCount);
}