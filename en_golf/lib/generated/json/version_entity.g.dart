import 'package:engolf/generated/json/base/json_convert_content.dart';
import 'package:engolf/model/config/version_entity.dart';

VersionEntity $VersionEntityFromJson(Map<String, dynamic> json) {
  final VersionEntity versionEntity = VersionEntity();
  final String? latestVersion = jsonConvert.convert<String>(
      json['latest_version']);
  if (latestVersion != null) {
    versionEntity.latestVersion = latestVersion;
  }
  final String? minSupportVersion = jsonConvert.convert<String>(
      json['min_support_version']);
  if (minSupportVersion != null) {
    versionEntity.minSupportVersion = minSupportVersion;
  }
  return versionEntity;
}

Map<String, dynamic> $VersionEntityToJson(VersionEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['latest_version'] = entity.latestVersion;
  data['min_support_version'] = entity.minSupportVersion;
  return data;
}

extension VersionEntityExtension on VersionEntity {
  VersionEntity copyWith({
    String? latestVersion,
    String? minSupportVersion,
  }) {
    return VersionEntity()
      ..latestVersion = latestVersion ?? this.latestVersion
      ..minSupportVersion = minSupportVersion ?? this.minSupportVersion;
  }
}