import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:engolf/common/remote_config.dart';
import 'package:engolf/model/config/version_entity.dart';
import 'package:engolf/screens/dice/model/dice_bloc.dart';
import 'package:engolf/screens/dice/views/dice_screen.dart';
import 'package:engolf/screens/history_result/history_result_screen.dart';
import 'package:engolf/screens/main/main_screen.dart';
import 'package:engolf/utils/logger.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:package_info/package_info.dart';

import 'package:provider/provider.dart';

import 'common/color_config.dart';
import 'common/utils.dart';
import 'flutter_flow/flutter_flow_theme.dart';
import 'flutter_flow/internationalization.dart';
import 'screens/menu/menu_screen.dart';
import 'screens/olympic/model/olympic_bloc.dart';
import 'screens/olympic/views/olympic_screen.dart';
import 'common/views/floating_bottom_bar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MobileAds.instance.initialize();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Firebase.initializeApp();

  runApp(const HomeScreen());
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  HomeScreenState createState() => HomeScreenState();

  static HomeScreenState of(BuildContext context) =>
      context.findAncestorStateOfType<HomeScreenState>()!;
}

class HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final _controller = PageController();
  Locale? _locale;
  ThemeMode _themeMode = FlutterFlowTheme.themeMode;

  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
          statusBarColor: Colors.green,
          statusBarBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.light),
    );
    confirmATTStatus();
    RemoteConfig().init();
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
        child: MainScreen(controller: _controller),
      ),
    );
  }

  void setLocale(String language) =>
      setState(() => _locale = createLocale(language));
  void setThemeMode(ThemeMode mode) => setState(() {
    _themeMode = mode;
    FlutterFlowTheme.saveThemeMode(mode);
  });

  Future<void> confirmATTStatus() async {
    final status = await AppTrackingTransparency.requestTrackingAuthorization();
    logger.d('ATT Status = $status');
  }
}