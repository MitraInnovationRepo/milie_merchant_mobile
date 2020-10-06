// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'driver_information.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DriverInformation _$DriverInformationFromJson(Map<String, dynamic> json) {
  return DriverInformation(
    json['FullName'] as String,
    json['callName'] as String,
    json['imgUrl'] as String,
    json['Mobile'] as String,
    json['cabno'] as String,
    json['color'] as String,
    json['model'] as String,
    json['brand'] as String,
    json['regno'] as String,
  );
}

Map<String, dynamic> _$DriverInformationToJson(DriverInformation instance) =>
    <String, dynamic>{
      'FullName': instance.FullName,
      'callName': instance.callName,
      'imgUrl': instance.imgUrl,
      'Mobile': instance.Mobile,
      'cabno': instance.cabno,
      'color': instance.color,
      'model': instance.model,
      'brand': instance.brand,
      'regno': instance.regno,
    };
