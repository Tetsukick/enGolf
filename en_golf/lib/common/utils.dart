import 'dart:math';

import 'package:english_words/english_words.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
// ignore: implementation_imports
import 'package:flutter/material.dart';

import 'dart:io';

import 'package:intl/intl.dart';

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
    return 'ca-app-pub-8604906384604870/8136991267';
  } else if (Platform.isAndroid) {
    return 'ca-app-pub-8604906384604870/4738255665';
  }
  return null;
}

String? getInterstitialAdUnitId() {
  if (Platform.isIOS) {
    return 'ca-app-pub-8604906384604870/8693607305';
  } else if (Platform.isAndroid) {
    return 'ca-app-pub-8604906384604870/3333469410';
  }
  return null;
}

String dateTimeToString(DateTime date) {
  final _formatter = DateFormat('yyyy-MM-dd');
  return _formatter.format(date);
}