import 'package:json_annotation/json_annotation.dart';

part 'order_reject_response.g.dart';

@JsonSerializable()
class OrderRejectResponse{
  int status;
  String message;

  OrderRejectResponse(this.status, this.message);

  factory OrderRejectResponse.fromJson(Map<String, dynamic> json) => _$OrderRejectResponseFromJson(json);

  Map<String, dynamic> toJson() => _$OrderRejectResponseToJson(this);
}