import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodie_merchant/src/data/model/driver_information.dart';
import 'package:foodie_merchant/src/services/delivery/delivery_service.dart';
import 'package:foodie_merchant/src/services/service_locator.dart';

class DriverInfoCard extends StatefulWidget {
  final String cabNo;
  final bool showMobile;

  DriverInfoCard({Key key, this.cabNo, this.showMobile}) : super(key: key);

  @override
  _DriverInfoCardPageState createState() => _DriverInfoCardPageState();
}

class _DriverInfoCardPageState extends State<DriverInfoCard> {
  DeliveryService _deliveryService = locator<DeliveryService>();
  DriverInformation _driverInformation;

  @override
  initState() {
    super.initState();
    fetchDriverInfo();
  }

  fetchDriverInfo() async {
    DriverInformation _driverInformation = await this._deliveryService.getDriverInformation(widget.cabNo);
    setState(() {
      this._driverInformation = _driverInformation;
    });
  }

  @override
  Widget build(BuildContext context) {
    return
      this._driverInformation != null ?
      Column(
        children: [
          this.widget.showMobile ?
          Text("${_driverInformation.FullName} - ${_driverInformation.Mobile}",
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style:
              TextStyle(color: Colors.black87, fontSize: 18)) :
          Text("${_driverInformation.FullName}",
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style:
              TextStyle(color: Colors.black87, fontSize: 18))
        ],
      ) : Container();
  }
}
