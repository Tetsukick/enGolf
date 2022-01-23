import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'utils.dart';

class Admob {
  static BannerAd smallBanner = BannerAd(
    adUnitId: getBannerAdUnitId(),
    size: AdSize.banner,
    request: AdRequest(),
    listener: BannerAdListener()
  );
}

class AdmobBanner extends StatelessWidget {
  const AdmobBanner({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Admob.smallBanner.load();
    return AdWidget(ad: Admob.smallBanner);
  }
}
