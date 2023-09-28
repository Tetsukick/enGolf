import 'dart:convert';
import 'package:engolf/generated/json/base/json_field.dart';
import 'package:engolf/generated/json/affiliate_ads_entity.g.dart';

@JsonSerializable()
class AffiliateAdsEntity {

	@JSONField(name: "square_ad")
	List<AffiliateAdsSquareAd>? squareAd;
	@JSONField(name: "banner_ad")
	List<AffiliateAdsBannerAd>? bannerAd;
  
  AffiliateAdsEntity();

  factory AffiliateAdsEntity.fromJson(Map<String, dynamic> json) => $AffiliateAdsEntityFromJson(json);

  Map<String, dynamic> toJson() => $AffiliateAdsEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class AffiliateAdsSquareAd {

	String? url;
	@JSONField(name: "image_url")
	String? imageUrl;
	int? priority;
  
  AffiliateAdsSquareAd();

  factory AffiliateAdsSquareAd.fromJson(Map<String, dynamic> json) => $AffiliateAdsSquareAdFromJson(json);

  Map<String, dynamic> toJson() => $AffiliateAdsSquareAdToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class AffiliateAdsBannerAd {

	String? url;
	@JSONField(name: "image_url")
	String? imageUrl;
	int? priority;
  
  AffiliateAdsBannerAd();

  factory AffiliateAdsBannerAd.fromJson(Map<String, dynamic> json) => $AffiliateAdsBannerAdFromJson(json);

  Map<String, dynamic> toJson() => $AffiliateAdsBannerAdToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

const affiliateAdsDefaults = {
  "square_ad": [
    {
      "url": "https://amzn.to/3Zyt5oV",
      "image_url": "https://m.media-amazon.com/images/I/618KqbnXHVS._AC_SL1000_.jpg",
      "priority": 1
    },
    {
      "url": "https://hb.afl.rakuten.co.jp/hsc/3075c7dd.dd49cf58.3075b2b6.604b1f86/_RTLink68190?link_type=hybrid_url&ut=eyJwYWdlIjoic2hvcCIsInR5cGUiOiJoeWJyaWRfdXJsIiwiY29sIjoxLCJjYXQiOiIxIiwiYmFuIjoiNjY5NjkyIiwiYW1wIjpmYWxzZX0%3D",
      "image_url": "https://hbb.afl.rakuten.co.jp/hsb/3075c7dd.dd49cf58.3075b2b6.604b1f86/?me_id=2100005&me_adv_id=669692&t=pict",
      "priority": 1
    }
  ],
  "banner_ad": [
    {
      "url": "https://hb.afl.rakuten.co.jp/hsc/3075c5f0.592ea144.3075b2b6.604b1f86/_RTLink68190?link_type=pict&ut=eyJwYWdlIjoic2hvcCIsInR5cGUiOiJwaWN0IiwiY29sIjoxLCJjYXQiOiIyIiwiYmFuIjoiNjk5NzI0IiwiYW1wIjpmYWxzZX0%3D",
      "image_url": "https://hbb.afl.rakuten.co.jp/hsb/3075c5f0.592ea144.3075b2b6.604b1f86/?me_id=2100005&me_adv_id=699724&t=pict",
      "priority": 1
    },
    {
      "url": "https://px.a8.net/svt/ejp?a8mat=3T8KI0+3E1WKA+40MY+5Z6WX",
      "image_url": "https://www29.a8.net/svt/bgt?aid=230507208205&wid=002&eno=01&mid=s00000018745001004000&mc=1",
      "priority": 10
    }
  ]
};