import 'dart:async';

import 'package:engolf/ar_measure_screen.dart';
import 'package:engolf/dice_bloc.dart';
import 'package:engolf/dice_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lorem/flutter_lorem.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
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

void main() {
  Crashlytics.instance.enableInDevMode = true;
  FlutterError.onError = Crashlytics.instance.recordFlutterError;

  Admob.initialize(testDeviceIds: [getAppId()]);

  runZoned(() {
    runApp(const HomeScreen());
  }, onError: Crashlytics.instance.recordError);
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  TabController tabController;
  int _currentIndex = 0;
  final _iosAppId = 'ca-app-pub-8604906384604870~8704941903';
  final _androidAppId = 'ca-app-pub-8604906384604870~8130705763';

  @override
  void initState() {
    super.initState();
    tabController = TabController(vsync: this, length: 4)
      ..addListener(_handleTabSelection);
  }

  @override
  void dispose() {
    super.dispose();
    tabController.dispose();
  }

  void _handleTabSelection() {
    setState(() {
      _currentIndex = tabController.index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return
      MaterialApp(
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
            bottomNavigationBar: TabBar(
              controller: tabController,
              labelColor: Colors.lightGreen,
              unselectedLabelColor: Colors.grey,
              labelStyle: TextStyle(
                  color: Colors.grey
              ),
              indicatorColor: Colors.white,
              tabs: const <Widget> [
                Tab(
                  icon: Icon(Icons.monetization_on),
                  text: 'Calculator',
                ),
                Tab(
                  icon: Icon(Icons.casino),
                  text: 'Dice',
                ),
                Tab(
                  icon: Icon(Icons.fullscreen),
                  text: 'Measure',
                ),
                Tab(
                  icon: Icon(Icons.list),
                  text: 'Settings',
                ),
              ],
            ),
            body: SafeArea(
              child: TabBarView(
                controller: tabController,
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