// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_reject_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderRejectResponse _$OrderRejectResponseFromJson(Map<String, dynamic> json) {
  return OrderRejectResponse(
    json['status'] as int,
    json['message'] as String,
  );
}

Map<String, dynamic> _$OrderRejectResponseToJson(
        OrderRejectResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
    };
