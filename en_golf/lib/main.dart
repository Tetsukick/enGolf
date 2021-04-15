import 'dart:async';

import 'package:engolf/ar_measure_screen.dart';
import 'package:engolf/dice_bloc.dart';
import 'package:engolf/dice_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_lorem/flutter_lorem.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:admob_flutter/admob_flutter.dart';

import 'package:provider/provider.dart';

import 'menu_screen.dart';
import 'utils.dart';
import 'widgets.dart';
import 'olympic_bloc.dart';
import 'olympic_screen.dart';
import 'constants.dart' as Constants;
import 'dart:io';
import 'package:flutter/material.dart';
import 'floating_bottom_bar.dart';

void main() {

  Admob.initialize(testDeviceIds: [getAppId()]);

  runApp(const HomeScreen());
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final _controller = PageController();
  final _iosAppId = 'ca-app-pub-8604906384604870~8704941903';
  final _androidAppId = 'ca-app-pub-8604906384604870~8130705763';

  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
          statusBarColor: Colors.green,
          statusBarBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.light),
    );
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      debugShowCheckedModeBanner: false,
      title: '',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: MultiProvider(
        providers: [
          Provider<OlympicBloc>(
            create: (context) => OlympicBloc(),
            dispose: (context, bloc) => bloc.dispose(),
          ),
          Provider<DiceBloc>(
            create: (context) => DiceBloc(),
            dispose: (context, bloc) => bloc.dispose(),
          ),
        ],
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            bottomNavigationBar: FloatingBottomBar(
              controller: _controller,
              items: [
                FloatingBottomBarItem(Icons.monetization_on, label: 'Calculator'),
                FloatingBottomBarItem(Icons.casino, label: 'Dice'),
                FloatingBottomBarItem(Icons.fullscreen, label: 'Measure'),
                FloatingBottomBarItem(Icons.list, label: 'Settings'),
              ],
              activeItemColor: Colors.lightGreen,
              enableIconRotation: true,
              onTap: (index) {
                print('Tapped: item $index');
                _controller.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeOut,
                );
              },
            ),
            body: SafeArea(
              child: PageView(
                controller: _controller,
                children: <Widget> [
                  OlympicScreen(),
                  DiceScreen(),
                  ARMeasureScreen(),
                  MenuScreen()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}