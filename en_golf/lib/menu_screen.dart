import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:engolf/utils.dart';
import 'package:admob_flutter/admob_flutter.dart';

import 'package:package_info/package_info.dart';

class MenuScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Stack(
        children: [
          ListView(
            children: [
              _menuItem(
                "Feedback",
                Icon(
                  Icons.comment,
                  color: Colors.grey,
                ),
                onTap: () {
                  setBrowserPage("https://forms.gle/xR5f875pD27v9k4U7");
                },
              ),
              _menuItem(
                "privacy policy",
                Icon(
                  Icons.security,
                  color: Colors.grey,
                ),
                onTap: () {
                  setBrowserPage("https://qiita.com/tetsukick/items/a3c844940064e15f0dac");
                },
              ),
              FutureBuilder(
                future: _getPackageInfo(),
                builder: (BuildContext context, AsyncSnapshot<PackageInfo> snapshot) {
                  if (!snapshot.hasData) {
                    return _menuItem(
                      "version",
                      Icon(
                        Icons.settings,
                        color: Colors.grey,
                      ),
                    );
                  }
                  String version = snapshot.data.version ?? '';
                  String buildVersion = snapshot.data.buildNumber ?? '';
                  return _menuItem(
                      "version $version $buildVersion",
                      Icon(
                        Icons.settings,
                        color: Colors.grey,
                      ),
                  );
                },
              ),
            ]
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
            height: 50,
            child: AdmobBanner(
              adUnitId: getBannerAdUnitId(),
              adSize: AdmobBannerSize.LEADERBOARD,
            ),
          ),
        )
      ]),
    );
  }

  Widget _menuItem(String title, Icon icon, {GestureTapCallback onTap}) {
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
                child:icon,
              ),
              Text(
                title,
                style: TextStyle(
                    color:Colors.black,
                    fontSize: 18.0
                ),
              ),
            ],
          )
      ),
      onTap: () {
        onTap();
      },
    );
  }

  Future<void> setBrowserPage(String url) async {
    MyInAppBrowser browser = new MyInAppBrowser();
    await browser.openUrl(
      url: url,
      options: InAppBrowserClassOptions(
        crossPlatform: InAppBrowserOptions(
          // 共通オプション
          toolbarTopBackgroundColor: "#2b374d",
        ),
        android: AndroidInAppBrowserOptions(
          // Android用オプション
        ),
        ios: IOSInAppBrowserOptions(
          // iOS用オプション
            toolbarBottomBackgroundColor: "#2b374d",
            closeButtonCaption: "閉じる",
            closeButtonColor: "#ffffff"
        ),
      ),
    );
  }

  Future<PackageInfo> _getPackageInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo;
  }
}