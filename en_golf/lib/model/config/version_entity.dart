import 'dart:convert';
import 'package:engolf/generated/json/base/json_field.dart';
import 'package:engolf/generated/json/version_entity.g.dart';

@JsonSerializable()
class VersionEntity {

	@JSONField(name: "latest_version")
	String? latestVersion;
	@JSONField(name: "min_support_version")
	String? minSupportVersion;
  
  VersionEntity();

  factory VersionEntity.fromJson(Map<String, dynamic> json) => $VersionEntityFromJson(json);

  Map<String, dynamic> toJson() => $VersionEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

const versionDefaults = {
  "latest_version": "4.0.7",
  "min_support_version": "4.0.0"
};