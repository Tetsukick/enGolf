import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:engolf/utils.dart';

class MenuScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: ListView(
          children: [
            _menuItem(
              "Feedback",
              Icon(Icons.settings),
              onTap: () {
                setBrowserPage();
              },
            ),
            _menuItem("メニュー2", Icon(Icons.map)),
            _menuItem("メニュー3", Icon(Icons.room)),
            _menuItem("メニュー4", Icon(Icons.local_shipping)),
            _menuItem("メニュー5", Icon(Icons.airplanemode_active)),
          ]
      ),
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

  Future<void> setBrowserPage() async {
    MyInAppBrowser browser = new MyInAppBrowser();
    await browser.openUrl(
      url: "https://forms.gle/xR5f875pD27v9k4U7",
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
}