import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:engolf/common/shared_preference.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../common/color_config.dart';
import '../../common/remote_config.dart';
import '../../common/utils.dart';
import '../../common/views/floating_bottom_bar.dart';
import '../../utils/logger.dart';
import '../dice/views/dice_screen.dart';
import '../history_result/history_result_screen.dart';
import '../menu/menu_screen.dart';
import '../olympic/views/olympic_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({
    Key? key,
    required PageController controller,
  }) : _controller = controller, super(key: key);

  final PageController _controller;

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  @override
  void initState() {
    confirmATTStatus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    checkForceUpdate(context);
    return Scaffold(
      backgroundColor: ColorConfig.bgGreenPrimary,
      bottomNavigationBar: FloatingBottomBar(
        controller: widget._controller,
        items: const [
          FloatingBottomBarItem(Icons.monetization_on, label: 'Calculator'),
          FloatingBottomBarItem(Icons.casino, label: 'Dice'),
          FloatingBottomBarItem(Icons.timeline, label: 'History'),
          FloatingBottomBarItem(Icons.list, label: 'Settings'),
        ],
        color: ColorConfig.bgDarkGreen,
        itemColor: Colors.white,
        activeItemColor: ColorConfig.greenPrimary,
        enableIconRotation: true,
        onTap: (index) {
          widget._controller.animateToPage(
            index,
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeOut,
          );
        },
      ),
      body: SafeArea(
        child: PageView(
          controller: widget._controller,
          children: <Widget> [
            OlympicScreen(),
            DiceScreen(),
            HistoryResultScreen(),
            MenuScreen()
          ],
        ),
      ),
    );
  }

  Future<void> checkForceUpdate(BuildContext context) async {
    final versionConfig = await RemoteConfig().getVersion();
    final currentVersion = (await PackageInfo.fromPlatform()).version;
    if (versionConfig.minSupportVersion == null
        || versionConfig.latestVersion == null) {
      logger.e('failed to get version config in remote config');
      return;
    }
    final isNeedForceUpdate =
    isVersionGreaterThan(versionConfig.minSupportVersion!, currentVersion);
    final isLatestVersion =
    isVersionGreaterThan(currentVersion, versionConfig.latestVersion!);
    if (isNeedForceUpdate) {
      await AwesomeDialog(
        context: context,
        dialogType: DialogType.warning,
        animType: AnimType.bottomSlide,
        title: 'ストアで最新版にアップデートしてください',
        desc: '現在利用のバージョンをご利用できません。',
        btnCancelOnPress: null,
        btnOkOnPress: openStore,
        dismissOnTouchOutside: false,
        onDismissCallback: (_) {
          checkForceUpdate(context);
        }
      ).show();
    } else if (!isLatestVersion) {
      final latestDismissVersion = await SharedPreferenceManager()
          .getLatestDismissVersion();
      if (latestDismissVersion != null
        && latestDismissVersion == versionConfig.latestVersion!) {
        return;
      } else {
        await AwesomeDialog(
          context: context,
          dialogType: DialogType.info,
          animType: AnimType.bottomSlide,
          title: 'ストアで最新版がご利用可能です',
          desc: '最新版にアップデートしてください。',
          btnCancelOnPress: () {},
          btnOkOnPress: openStore,
          onDismissCallback: (_) {
            SharedPreferenceManager()
                .setLatestDismissVersion(versionConfig.latestVersion!);
          }
        ).show();
      }
    }
  }

  Future<void> confirmATTStatus() async {
    final status = await AppTrackingTransparency.requestTrackingAuthorization();
    logger.d('ATT Status = $status');
  }
}