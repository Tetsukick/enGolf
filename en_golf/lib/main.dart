import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:engolf/screens/ar_measure/ar_measure_screen.dart';
import 'package:engolf/screens/dice/model/dice_bloc.dart';
import 'package:engolf/screens/dice/views/dice_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'package:provider/provider.dart';

import 'common/color_config.dart';
import 'screens/menu/menu_screen.dart';
import 'screens/olympic/model/olympic_bloc.dart';
import 'screens/olympic/views/olympic_screen.dart';
import 'common/views/floating_bottom_bar.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(const HomeScreen());
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final _controller = PageController();

  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
          statusBarColor: Colors.green,
          statusBarBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.light),
    );
    confirmATTStatus();
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
        child: Scaffold(
          backgroundColor: ColorConfig.bgGreenPrimary,
          bottomNavigationBar: FloatingBottomBar(
            controller: _controller,
            items: [
              FloatingBottomBarItem(Icons.monetization_on, label: 'Calculator'),
              FloatingBottomBarItem(Icons.casino, label: 'Dice'),
              FloatingBottomBarItem(Icons.fullscreen, label: 'Measure'),
              FloatingBottomBarItem(Icons.list, label: 'Settings'),
            ],
            color: ColorConfig.bgDarkGreen,
            itemColor: Colors.white,
            activeItemColor: ColorConfig.greenPrimary,
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
    );
  }

  Future<void> confirmATTStatus() async {
    final status = await AppTrackingTransparency.requestTrackingAuthorization();
    print('ATT Status = $status');
  }
}