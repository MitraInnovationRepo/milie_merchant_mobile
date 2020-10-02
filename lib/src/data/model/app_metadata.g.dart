// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_metadata.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppMetadata _$AppMetadataFromJson(Map<String, dynamic> json) {
  return AppMetadata(
    json['id'] as int,
    json['version'] as String,
    json['status'] as int,
    json['updateAvailable'] as int,
    json['strictUpdate'] as int,
    json['maintenanceMode'] as int,
  );
}

Map<String, dynamic> _$AppMetadataToJson(AppMetadata instance) =>
    <String, dynamic>{
      'id': instance.id,
      'version': instance.version,
      'status': instance.status,
      'updateAvailable': instance.updateAvailable,
      'strictUpdate': instance.strictUpdate,
      'maintenanceMode': instance.maintenanceMode,
    };
