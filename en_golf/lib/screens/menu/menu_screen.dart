import 'dart:async';

import 'package:engolf/common/admob.dart';
import 'package:engolf/common/color_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:engolf/common/utils.dart';
import 'package:in_app_review/in_app_review.dart';

import 'package:package_info/package_info.dart';

import '../player_search/player_list_screen.dart';

class MenuScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConfig.bgGreenPrimary,
      appBar: AppBar(
        title: Text('Settings'),
        backgroundColor: ColorConfig.bgDarkGreen,
      ),
      body: Stack(
        children: [
          ListView(
            children: [
              _menuItem(
                title: 'プレイヤー管理',
                assetPath: 'assets/user-settings_128.png',
                onTap: () {
                  Navigator.of(context).push<dynamic>(
                    MaterialPageRoute<dynamic>(builder: (context) {
                      return PlayerListScreen();
                    },),
                  );
                },
              ),
              _menuItem(
                title: AppLocalizations.of(context)!.feedback,
                assetPath: 'assets/feedback_128.png',
                onTap: () async {
                  final inAppReview = InAppReview.instance;
                  if (await inAppReview.isAvailable()) {
                    await inAppReview.requestReview();
                  }
                },
              ),
              _menuItem(
                title: AppLocalizations.of(context)!.privacyPolicy,
                assetPath: 'assets/privacypolicy_128.png',
                onTap: () {
                  setBrowserPage("https://github.com/Tetsukick/application_privacy_policy/blob/main/README.md");
                },
              ),
              FutureBuilder(
                future: _getPackageInfo(),
                builder: (BuildContext context, AsyncSnapshot<PackageInfo> snapshot) {
                  if (!snapshot.hasData) {
                    return _menuItem(
                      title: 'version',
                      assetPath: 'assets/license_128.png',
                    );
                  }
                  String version = snapshot.data?.version ?? '';
                  String buildVersion = snapshot.data!.buildNumber ?? '';
                  return _menuItem(
                      title: 'version $version $buildVersion',
                      assetPath: 'assets/license_128.png',
                  );
                },
              ),
            ]
        ),
        const Positioned(
          left: 0,
          right: 0,
          bottom: 24,
          child: SizedBox(
            height: 50,
            child: AdmobBanner(),
          ),
        )
      ]),
    );
  }

  Widget _menuItem({required String title, required String assetPath, GestureTapCallback? onTap}) {
    const iconWidth = 32.0;

    return GestureDetector(
      child:Container(
          padding: EdgeInsets.all(8.0),
          decoration: new BoxDecoration(
              border: new Border(bottom: BorderSide(width: 1.0, color: Colors.grey))
          ),
          child: Row(
            children: <Widget>[
              Container(
                margin: EdgeInsets.all(10.0),
                child: Image.asset(assetPath, width: iconWidth,),
              ),
              Text(
                title,
                style: TextStyle(
                    color:Colors.white,
                    fontSize: 18.0
                ),
              ),
            ],
          )
      ),
      onTap: () {
        if (onTap != null) {
          onTap();
        }
      },
    );
  }

  Future<void> setBrowserPage(String url) async {
    MyInAppBrowser browser = new MyInAppBrowser();
    await browser.openUrlRequest(
      urlRequest: URLRequest(url: Uri.parse(url)),
      options: InAppBrowserClassOptions(
        crossPlatform: InAppBrowserOptions(
          toolbarTopBackgroundColor: const Color(0xff2b374d),
        ),
        android: AndroidInAppBrowserOptions(
          // Android用オプション
        ),
        ios: IOSInAppBrowserOptions(
          // iOS用オプション
            toolbarTopTintColor: const Color(0xff2b374d),
            closeButtonCaption: '閉じる',
            closeButtonColor: Colors.white
        ),
      ),
    );
  }

  Future<PackageInfo> _getPackageInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo;
  }
}