import 'package:json_annotation/json_annotation.dart';

part 'driver_location.g.dart';

@JsonSerializable()
class DriverLocation{
  double lat;
  double lon;

  DriverLocation(this.lat, this.lon);

  DriverLocation.empty();

  factory DriverLocation.fromJson(Map<String, dynamic> json) => _$DriverLocationFromJson(json);

  Map<String, dynamic> toJson() => _$DriverLocationToJson(this);
}