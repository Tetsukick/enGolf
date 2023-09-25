/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import

import 'package:flutter/widgets.dart';

class Assets {
  Assets._();

  static const AssetGenImage addUser128 =
      AssetGenImage('assets/add-user_128.png');
  static const AssetGenImage bronzeCup128 =
      AssetGenImage('assets/bronze-cup_128.png');
  static const String calendar = 'assets/calendar.svg';
  static const AssetGenImage calendar128 =
      AssetGenImage('assets/calendar_128.png');
  static const AssetGenImage casinoChipMoney128 =
      AssetGenImage('assets/casino-chip-money_128.png');
  static const AssetGenImage casinoChip128 =
      AssetGenImage('assets/casino-chip_128.png');
  static const AssetGenImage delete128 = AssetGenImage('assets/delete_128.png');
  static const String engolfLogoOnly = 'assets/engolf_logo_only.svg';
  static const AssetGenImage feedback128 =
      AssetGenImage('assets/feedback_128.png');
  static const AssetGenImage goldCup128 =
      AssetGenImage('assets/gold-cup_128.png');
  static const AssetGenImage golfPin128 =
      AssetGenImage('assets/golf-pin_128.png');
  static const AssetGenImage golfBall = AssetGenImage('assets/golf_ball.png');
  static const String golfBallRotate = 'assets/golf_ball_rotate.flr';
  static const String golfCourse = 'assets/golf_course.svg';
  static const AssetGenImage king128 = AssetGenImage('assets/king_128.png');
  static const AssetGenImage license128 =
      AssetGenImage('assets/license_128.png');
  static const String money = 'assets/money.svg';
  static const AssetGenImage multiPerson128 =
      AssetGenImage('assets/multi-person_128.png');
  static const String people = 'assets/people.svg';
  static const AssetGenImage player128 = AssetGenImage('assets/player_128.png');
  static const AssetGenImage privacypolicy128 =
      AssetGenImage('assets/privacypolicy_128.png');
  static const String rankingTitleBg = 'assets/ranking_title_bg.svg';
  static const AssetGenImage reset128 = AssetGenImage('assets/reset_128.png');
  static const AssetGenImage settingError512 =
      AssetGenImage('assets/setting-error_512.png');
  static const AssetGenImage silverCup128 =
      AssetGenImage('assets/silver-cup_128.png');
  static const String tolophy = 'assets/tolophy.svg';
  static const String tolophyDarkGreen = 'assets/tolophy_dark_green.svg';
  static const AssetGenImage topBackground =
      AssetGenImage('assets/top-background.jpg');
  static const AssetGenImage trophy1128 =
      AssetGenImage('assets/trophy-1_128.png');
  static const AssetGenImage trophy128 = AssetGenImage('assets/trophy_128.png');
  static const AssetGenImage userSettings128 =
      AssetGenImage('assets/user-settings_128.png');

  /// List of all assets
  List<dynamic> get values => [
        addUser128,
        bronzeCup128,
        calendar,
        calendar128,
        casinoChipMoney128,
        casinoChip128,
        delete128,
        engolfLogoOnly,
        feedback128,
        goldCup128,
        golfPin128,
        golfBall,
        golfBallRotate,
        golfCourse,
        king128,
        license128,
        money,
        multiPerson128,
        people,
        player128,
        privacypolicy128,
        rankingTitleBg,
        reset128,
        settingError512,
        silverCup128,
        tolophy,
        tolophyDarkGreen,
        topBackground,
        trophy1128,
        trophy128,
        userSettings128
      ];
}

class AssetGenImage {
  const AssetGenImage(this._assetName);

  final String _assetName;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = false,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.low,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider() => AssetImage(_assetName);

  String get path => _assetName;

  String get keyName => _assetName;
}
