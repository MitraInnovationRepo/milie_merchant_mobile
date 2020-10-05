import 'package:json_annotation/json_annotation.dart';

part 'driver_information.g.dart';

@JsonSerializable()
class DriverInformation {
  String FullName;
  String callName;
  String imgUrl;
  String Mobile;
  String cabno;
  String color;
  String model;
  String brand;
  String regno;

  DriverInformation(this.FullName, this.callName, this.imgUrl, this.Mobile, this.cabno, this.color, this.model, this.brand, this.regno);

  DriverInformation.empty();

  factory DriverInformation.fromJson(Map<String, dynamic> json) => _$DriverInformationFromJson(json);

  Map<String, dynamic> toJson() => _$DriverInformationToJson(this);
}
