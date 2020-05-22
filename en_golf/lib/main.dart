import 'package:engolf/ar_measure_screen.dart';
import 'package:engolf/dice_bloc.dart';
import 'package:engolf/dice_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lorem/flutter_lorem.dart';
import 'package:firebase_admob/firebase_admob.dart';

import 'package:provider/provider.dart';

import 'utils.dart';
import 'widgets.dart';
import 'olympic_bloc.dart';
import 'olympic_screen.dart';
import 'constants.dart' as Constants;
import 'dart:io';

void main() => runApp(new HomeScreen());

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  HomeScreenState createState() => new HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  TabController tabController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    tabController = TabController(vsync: this, length: 3);
    tabController.addListener(_handleTabSelection);

    FirebaseAdMob.instance.initialize(appId: Platform.isIOS ? 'ca-app-pub-8604906384604870~8704941903' : 'ca-app-pub-8604906384604870~8130705763');

    myBanner
      ..load()
      ..show(
        anchorOffset: 20,
        anchorType: AnchorType.top,
      );
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
              tabs: <Widget>[
                new Tab(
                  icon: Icon(Icons.monetization_on),
                  text: "Calculator",
                ),
                new Tab(
                  icon: Icon(Icons.casino),
                  text: "Dice",
                ),
                new Tab(
                  icon: Icon(Icons.fullscreen),
                  text: "Measure",
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
  keywords: <String>['flutterio', 'beautiful apps'],
  contentUrl: 'https://flutter.io',
  birthday: DateTime.now(),
  childDirected: false,
  designedForFamilies: false,
  gender: MobileAdGender.male, // or female, unknown
  testDevices: <String>[], // Android emulators are considered test devices
);

BannerAd myBanner = BannerAd(
//  adUnitId: BannerAd.testAdUnitId,
  adUnitId: Platform.isIOS ? 'ca-app-pub-8604906384604870/3452615229' : 'ca-app-pub-8604906384604870/4738255665',
  size: AdSize.smartBanner,
  targetingInfo: targetingInfo,
  listener: (MobileAdEvent event) {
    print("BannerAd event is $event");
  },
);