import 'dart:math';
import 'dart:convert';

import 'package:english_words/english_words.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
// ignore: implementation_imports
import 'package:flutter/material.dart';

import 'dart:io';

import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../screens/olympic/model/player_model.dart';

// This file has a number of platform-agnostic non-Widget utility functions.

const _myListOfRandomColors = [
  Colors.red,
  Colors.blue,
  Colors.teal,
  Colors.yellow,
  Colors.amber,
  Colors.deepOrange,
  Colors.green,
  Colors.indigo,
  Colors.lime,
  Colors.pink,
  Colors.orange,
];

final _random = Random();

List<MaterialColor> getRandomColors(int amount) {
  return List<MaterialColor>.generate(amount, (index) {
    return _myListOfRandomColors[_random.nextInt(_myListOfRandomColors.length)];
  });
}

String capitalize(String word) {
  return '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}';
}

String capitalizePair(WordPair pair) {
  return '${capitalize(pair.first)} ${capitalize(pair.second)}';
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
  @override
  bool get hasPrimaryFocus => false;
}

class MyInAppBrowser extends InAppBrowser {

  @override
  Future onBrowserCreated() async {
    print("\n\nBrowser Created!\n\n");
  }

  @override
  void onProgressChanged(int progress) {
    print("Progress: $progress");
  }

  @override
  void onExit() {
    print("\n\nBrowser closed!\n\n");
  }

  @override
  void onConsoleMessage(ConsoleMessage consoleMessage) {
    print("""
    console output:
      message: ${consoleMessage.message}
      messageLevel: ${consoleMessage.messageLevel.toValue()}
   """);
  }
}

String? getAppId() {
  if (Platform.isIOS) {
    return 'ca-app-pub-8604906384604870~8704941903';
  } else if (Platform.isAndroid) {
    return 'ca-app-pub-8604906384604870~8130705763';
  }
  return null;
}

String? getBannerAdUnitId() {
  if (Platform.isIOS) {
    return kDebugMode ? 'ca-app-pub-3940256099942544/2934735716' : 'ca-app-pub-8604906384604870/8136991267';
  } else if (Platform.isAndroid) {
    return kDebugMode ? 'ca-app-pub-3940256099942544/6300978111' : 'ca-app-pub-8604906384604870/4738255665';
  }
  return null;
}

String? getInterstitialAdUnitId() {
  if (Platform.isIOS) {
    return kDebugMode ? 'ca-app-pub-3940256099942544/5135589807' : 'ca-app-pub-8604906384604870/8693607305';
  } else if (Platform.isAndroid) {
    return kDebugMode ? 'ca-app-pub-3940256099942544/8691691433' : 'ca-app-pub-8604906384604870/3333469410';
  }
  return null;
}

String dateTimeToString(DateTime date) {
  final _formatter = DateFormat('yyyy-MM-dd');
  return _formatter.format(date);
}

DateTime stringToDatetime(String stringDate) {
  final _formatter = DateFormat('yyyy-MM-dd');
  return _formatter.parse(stringDate);
}

String playerResultListToJson(List<PlayerResult?> players) {
  final dynamicList = players.map((e) => e!.toJson()).toList();
  return json.encode(dynamicList);
}

List<PlayerResult> playerResultListFromJson(String jsonData) {
  final dynamicList = json.decode(jsonData)
  as List<dynamic>;
  return List<PlayerResult>.from(dynamicList.map<dynamic>((x) =>
      PlayerResult.fromJson(x)));
}

bool isVersionGreaterThan(String newVersion, String currentVersion){
  final currentV = currentVersion.split('.');
  final newV = newVersion.split('.');
  bool a = false;
  for (var i = 0 ; i <= 2; i++){
    a = int.parse(newV[i]) > int.parse(currentV[i]);
    if(int.parse(newV[i]) != int.parse(currentV[i])) {
      break;
    }
  }
  if (newVersion == currentVersion) {
    a = true;
  }
  return a;
}

Future<void> openStore() async {
  if (Platform.isAndroid || Platform.isIOS) {
    final appId = Platform.isAndroid ? 'com.tetsukick.engolf' : '1507668448';
    final url = Uri.parse(
      Platform.isAndroid
          ? 'market://details?id=$appId'
          : 'https://apps.apple.com/app/id$appId',
    );
    await launchUrl(url, mode: LaunchMode.externalApplication);
  }
}
