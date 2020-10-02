import 'package:json_annotation/json_annotation.dart';

part 'app_metadata.g.dart';

@JsonSerializable()
class AppMetadata{
  int id;
  String version;
  int status;
  int updateAvailable;
  int strictUpdate;
  int maintenanceMode;

  AppMetadata(this.id, this.version, this.status, this.updateAvailable,
      this.strictUpdate, this.maintenanceMode);

  AppMetadata.empty();

  factory AppMetadata.fromJson(Map<String, dynamic> json) => _$AppMetadataFromJson(json);

  Map<String, dynamic> toJson() => _$AppMetadataToJson(this);
}