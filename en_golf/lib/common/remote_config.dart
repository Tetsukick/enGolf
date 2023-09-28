import 'dart:convert';
import 'package:engolf/utils/logger.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

import '../model/config/affiliate_ads_entity.dart';
import '../model/config/version_entity.dart';

class RemoteConfig {
  factory RemoteConfig() => instance;
  
  RemoteConfig._internal();
  static final RemoteConfig instance = RemoteConfig._internal();
  
  late FirebaseRemoteConfig? remoteConfig;

  Future<void> init() async {
    remoteConfig = FirebaseRemoteConfig.instance;
    await remoteConfig?.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(minutes: 1),
      minimumFetchInterval: const Duration(hours: 1),
    ));
    await setDefaults();
    await remoteConfig?.fetchAndActivate();
  }

  Future<void> setDefaults() async {
    if (remoteConfig == null) {
      await init();
    }
    await remoteConfig?.setDefaults({
      'version': jsonEncode(versionDefaults),
      'affiliate_ads': jsonEncode(affiliateAdsDefaults)
    });
  }
  
  Future<AffiliateAdsEntity> getAffiliateAds() async {
    await remoteConfig?.fetchAndActivate();
    final json = jsonDecode(remoteConfig!.getString('affiliate_ads'))
      as Map<String, dynamic>;
    return AffiliateAdsEntity.fromJson(json);
  }

  Future<VersionEntity> getVersion() async {
    await remoteConfig?.fetchAndActivate();
    final json = jsonDecode(remoteConfig!.getString('version'))
    as Map<String, dynamic>;
    return VersionEntity.fromJson(json);
  }
}