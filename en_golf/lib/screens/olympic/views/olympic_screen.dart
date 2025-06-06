import 'dart:math' as math;
import 'package:engolf/common/admob.dart';
import 'package:engolf/common/color_config.dart';
import 'package:engolf/common/remote_config.dart';
import 'package:engolf/common/shared_preference.dart';
import 'package:engolf/common/size_config.dart';
import 'package:engolf/model/config/affiliate_ads_entity.dart';
import 'package:engolf/screens/olympic/model/olympic_bloc.dart';
import 'package:engolf/screens/olympic/model/player_model.dart';
import 'package:engolf/screens/olympic/views/score_card.dart';
import 'package:engolf/screens/olympic/views/text_fields.dart';
import 'package:engolf/screens/result_olympic/result_olympic_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../common/constants.dart' as Constants;

class OlympicScreen extends StatelessWidget {
  FocusNode _playerCountNode = FocusNode();
  FocusNode _rateNode = FocusNode();

  @override
  Widget build(context) {
    final olympicBloc = Provider.of<OlympicBloc>(context);
    Admob.loadInterstitialAd();
    final size = MediaQuery.of(context).size;
    if (size.width <= 0) {
      return Container();
    }

    return KeyboardActions(
      autoScroll: true,
      tapOutsideToDismiss: true,
      config: _buildConfig(context),
      child: Container(
        padding: EdgeInsets.all(SizeConfig.mediumMargin),
        color: ColorConfig.bgGreenPrimary,
        child: SingleChildScrollView(
          child: Container(
            height: 530,
            child: Stack(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    header(context),
                    Expanded(
                      child: StreamBuilder(
                          stream: olympicBloc.players,
                          builder: (context, snapshot) {
                            if (snapshot.data == null) {
                              return Container();
                            } else {
                              final players = snapshot.data as List<PlayerResult>;
                              return AnimationLimiter(
                                child: Container(
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 50),
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: players.length,
                                      itemBuilder: (BuildContext context, int index) {
                                        return ScoreCard(color: Constants.colors[players[index].rank!], player: players[index],);
                                        // return AnimationConfiguration.staggeredList(
                                        //   position: index,
                                        //   duration: const Duration(milliseconds: 375),
                                        //   child: SlideAnimation(
                                        //     horizontalOffset: 50.0,
                                        //     child: FadeInAnimation(
                                        //       child: SafeArea(
                                        //           top: false,
                                        //           bottom: true,
                                        //           child: ScoreCard(color: Constants.colors[players[index].rank!], player: players[index],)
                                        //       ),
                                        //     ),
                                        //   ),
                                        // );
                                      },
                                    ),
                                  ),
                                ),
                              );
                            }
                          }
                      ),
                    ),
                  ],
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: SizedBox(
                    height: 50,
                    child: FutureBuilder<Widget>(
                      future: adBanner(), // a previously-obtained Future<String> or null
                      builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
                        List<Widget> children;
                        if (snapshot.hasData) {
                          return snapshot.data ?? const AdmobBanner();
                        } else {
                          return const AdmobBanner();
                        }
                      },
                    ),
                  ),
                )
              ]
            ),
          ),
        ),
      ),
    );
  }

  Widget header(BuildContext context) {
    final olympicBloc = Provider.of<OlympicBloc>(context);
    return Column(
      children: [
        SizedBox(height: SizeConfig.smallestMargin),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(SizeConfig.smallMargin),
              child: SvgPicture.asset('assets/engolf_logo_only.svg'),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () async {
                    await _showAdAndAskReview();
                    await olympicBloc.resetData();
                  },
                  child: Image.asset('assets/reset_128.png',
                    width: 32,
                  ),
                ),
                const SizedBox(width: SizeConfig.mediumMargin,),
                ElevatedButton.icon(
                  icon: Image.asset('assets/trophy_128.png',
                    width: 24,
                  ),
                  label: Text(AppLocalizations.of(context)!.saveResult,),
                  onPressed: () async {
                    await _showAdAndAskReview();
                    await Navigator.push(
                        context,
                        MaterialPageRoute<ResultOlympicScreen>(
                            builder: (BuildContext context) {
                              return ResultOlympicScreen();
                            },
                            fullscreenDialog: true));
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.green,
                  ),
                ),
              ],
            ),
          ],
        ),
        IconTextField(
          'assets/golf-pin_128.png',
          AppLocalizations.of(context)!.cupName,
          olympicBloc.gameName,
          olympicBloc.changeGameNameAction.add,
        ),
        SizedBox(height: SizeConfig.smallMargin),
        IconTextFieldDate(
          icon: 'assets/calendar_128.png',
          labelTitle: '',
          stream: olympicBloc.date,
          function: olympicBloc.changeDateAction.add,
        ),
        SizedBox(height: SizeConfig.smallMargin),
        Row(
          children: [
            IconStreamTextField(
                'assets/multi-person_128.png',
                AppLocalizations.of(context)!.player,
                olympicBloc.playerCount,
                olympicBloc.changePlayerCountAction.add,
                _playerCountNode
            ),
            const SizedBox(width: SizeConfig.smallMargin),
            IconStreamTextField(
                'assets/casino-chip-money_128.png',
                AppLocalizations.of(context)!.rate,
                olympicBloc.rate,
                olympicBloc.changeRateAction.add,
                _rateNode
            ),
          ],
        ),
      ],
    );
  }

  KeyboardActionsConfig _buildConfig(BuildContext context) {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.IOS,
      keyboardBarColor: ColorConfig.bgDarkGreen,
      nextFocus: false,
      actions: [
        KeyboardActionsItem(
          focusNode: _playerCountNode,
          toolbarButtons: [
              (node) {
              return GestureDetector(
                onTap: () => node.unfocus(),
                child: Container(
                  color: ColorConfig.bgDarkGreen,
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "DONE",
                    style: TextStyle(color: ColorConfig.textGreenLight),
                  ),
                ),
              );
            }
          ],
        ),
        KeyboardActionsItem(
          focusNode: _rateNode,
          toolbarButtons: [
              (node) {
              return GestureDetector(
                onTap: () => node.unfocus(),
                child: Container(
                  color: ColorConfig.bgDarkGreen,
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "DONE",
                    style: TextStyle(color: ColorConfig.textGreenLight),
                  ),
                ),
              );
            }
          ],
        ),
      ],
    );
  }

  Future<void> _askReview() async {
    final lastAppReviewDate = await SharedPreferenceManager().getLastAppReviewDate();
    if (lastAppReviewDate != null) {
      return;
    }

    final inAppReview = InAppReview.instance;
    if (await inAppReview.isAvailable()) {
      await inAppReview.requestReview();
      await SharedPreferenceManager().setLastAppReviewDate(DateTime.now());
    }
  }

  Future<void> _showAdAndAskReview() async {
    final rand = math.Random();
    final lottery = rand.nextInt(3);
    if (lottery == 0) {
      await Admob.showInterstitialAd();
    } else {
      await _askReview();
    }
  }

  Future<Widget> adBanner() async {
    return AdmobBanner();
    // final affiliateAds = await RemoteConfig().getAffiliateAds();
    // if (affiliateAds.bannerAd == null || affiliateAds.bannerAd!.isEmpty) {
    //   return AdmobBanner();
    // } else {
    //   final rand = math.Random();
    //   final lottery = rand.nextInt(4);
    //   affiliateAds.bannerAd!.sort((a, b) => b.priority!.compareTo(a.priority!));
    //   if (lottery == 0) {
    //     return AdmobBanner();
    //   } else {
    //     if (lottery == 1) {
    //       return affiliateBanner(affiliateAds.bannerAd!.last);
    //     } else {
    //       return affiliateBanner(affiliateAds.bannerAd!.first);
    //     }
    //   }
    // }
  }

  Widget affiliateBanner(AffiliateAdsBannerAd ad) {
    return InkWell(
      onTap: () {
        launchUrl(Uri.parse(ad.url!));
      },
      child: Image.network(ad.imageUrl!)
    );
  }
}