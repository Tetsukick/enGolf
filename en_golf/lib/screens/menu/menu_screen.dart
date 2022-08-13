import 'dart:async';

import 'package:engolf/common/admob.dart';
import 'package:engolf/common/color_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:engolf/common/utils.dart';

import 'package:package_info/package_info.dart';

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
                AppLocalizations.of(context)!.feedback,
                Icon(
                  Icons.comment,
                  color: Colors.white,
                ),
                onTap: () {
                  setBrowserPage("https://forms.gle/xR5f875pD27v9k4U7");
                },
              ),
              _menuItem(
                AppLocalizations.of(context)!.privacyPolicy,
                Icon(
                  Icons.security,
                  color: Colors.white,
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
                        color: Colors.white,
                      ),
                    );
                  }
                  String version = snapshot.data!.version ?? '';
                  String buildVersion = snapshot.data!.buildNumber ?? '';
                  return _menuItem(
                      "version $version $buildVersion",
                      Icon(
                        Icons.settings,
                        color: Colors.white,
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
            child: const AdmobBanner(),
          ),
        )
      ]),
    );
  }

  Widget _menuItem(String title, Icon icon, {GestureTapCallback? onTap}) {
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
                    color:Colors.white,
                    fontSize: 18.0
                ),
              ),
            ],
          )
      ),
      onTap: () {
        onTap!();
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