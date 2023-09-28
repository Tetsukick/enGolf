import 'package:engolf/generated/json/base/json_convert_content.dart';
import 'package:engolf/model/config/affiliate_ads_entity.dart';

AffiliateAdsEntity $AffiliateAdsEntityFromJson(Map<String, dynamic> json) {
	final AffiliateAdsEntity affiliateAdsEntity = AffiliateAdsEntity();
	final List<AffiliateAdsSquareAd>? squareAd = jsonConvert.convertListNotNull<AffiliateAdsSquareAd>(json['square_ad']);
	if (squareAd != null) {
		affiliateAdsEntity.squareAd = squareAd;
	}
	final List<AffiliateAdsBannerAd>? bannerAd = jsonConvert.convertListNotNull<AffiliateAdsBannerAd>(json['banner_ad']);
	if (bannerAd != null) {
		affiliateAdsEntity.bannerAd = bannerAd;
	}
	return affiliateAdsEntity;
}

Map<String, dynamic> $AffiliateAdsEntityToJson(AffiliateAdsEntity entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['square_ad'] =  entity.squareAd?.map((v) => v.toJson()).toList();
	data['banner_ad'] =  entity.bannerAd?.map((v) => v.toJson()).toList();
	return data;
}

AffiliateAdsSquareAd $AffiliateAdsSquareAdFromJson(Map<String, dynamic> json) {
	final AffiliateAdsSquareAd affiliateAdsSquareAd = AffiliateAdsSquareAd();
	final String? url = jsonConvert.convert<String>(json['url']);
	if (url != null) {
		affiliateAdsSquareAd.url = url;
	}
	final String? imageUrl = jsonConvert.convert<String>(json['image_url']);
	if (imageUrl != null) {
		affiliateAdsSquareAd.imageUrl = imageUrl;
	}
	final int? priority = jsonConvert.convert<int>(json['priority']);
	if (priority != null) {
		affiliateAdsSquareAd.priority = priority;
	}
	return affiliateAdsSquareAd;
}

Map<String, dynamic> $AffiliateAdsSquareAdToJson(AffiliateAdsSquareAd entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['url'] = entity.url;
	data['image_url'] = entity.imageUrl;
	data['priority'] = entity.priority;
	return data;
}

AffiliateAdsBannerAd $AffiliateAdsBannerAdFromJson(Map<String, dynamic> json) {
	final AffiliateAdsBannerAd affiliateAdsBannerAd = AffiliateAdsBannerAd();
	final String? url = jsonConvert.convert<String>(json['url']);
	if (url != null) {
		affiliateAdsBannerAd.url = url;
	}
	final String? imageUrl = jsonConvert.convert<String>(json['image_url']);
	if (imageUrl != null) {
		affiliateAdsBannerAd.imageUrl = imageUrl;
	}
	final int? priority = jsonConvert.convert<int>(json['priority']);
	if (priority != null) {
		affiliateAdsBannerAd.priority = priority;
	}
	return affiliateAdsBannerAd;
}

Map<String, dynamic> $AffiliateAdsBannerAdToJson(AffiliateAdsBannerAd entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['url'] = entity.url;
	data['image_url'] = entity.imageUrl;
	data['priority'] = entity.priority;
	return data;
}