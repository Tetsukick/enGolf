import 'dart:math' as math;
import 'package:engolf/common/admob.dart';
import 'package:engolf/common/color_config.dart';
import 'package:engolf/common/shared_preference.dart';
import 'package:engolf/common/size_config.dart';
import 'package:engolf/screens/olympic/model/olympic_bloc.dart';
import 'package:engolf/screens/olympic/model/player_model.dart';
import 'package:engolf/screens/olympic/views/score_card.dart';
import 'package:engolf/screens/olympic/views/text_fields.dart';
import 'package:engolf/screens/result_olympic/result_olympic_screen.dart';
import 'package:engolf/utils/logger.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

import 'package:provider/provider.dart';

import '../../../common/utils.dart';
import '../../../model/floor/entity/game_result_object.dart';
import '../model/olympic_bloc.dart';
import '../../../common/constants.dart' as Constants;

class OlympicEditScreen extends StatefulWidget {

  OlympicEditScreen(this.gameResult);
  GameResultObject gameResult;

  @override
  State<OlympicEditScreen> createState() => _OlympicEditScreenState();
}

class _OlympicEditScreenState extends State<OlympicEditScreen> {
  FocusNode _playerCountNode = FocusNode();
  FocusNode _rateNode = FocusNode();
  int playerCount = 4;
  int rate = 1;

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
                                        return AnimationConfiguration.staggeredList(
                                          position: index,
                                          duration: const Duration(milliseconds: 375),
                                          child: SlideAnimation(
                                            horizontalOffset: 50.0,
                                            child: FadeInAnimation(
                                              child: SafeArea(
                                                  top: false,
                                                  bottom: true,
                                                  child: ScoreCard(color: Constants.colors[players[index].rank!], player: players[index],)
                                              ),
                                            ),
                                          ),
                                        );
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
                  child: Container(
                    height: 50,
                    child: new AdmobBanner(),
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
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () {

                  },
                  child: Image.asset('assets/delete_128.png',
                    width: 32,
                  ),
                ),
                const SizedBox(width: SizeConfig.mediumMargin,),
                ElevatedButton.icon(
                  icon: Image.asset('assets/trophy_128.png',
                    width: 24,
                  ),
                  label: const Text('変更を保存'),
                  onPressed: () async {
                    var rand = new math.Random();
                    int lottery = rand.nextInt(3);
                    if (lottery == 0) {
                      await Admob.showInterstitialAd();
                    } else {
                      await _askReview();
                    }

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
        EditableIconTextField(
          'assets/golf-pin_128.png',
          AppLocalizations.of(context)!.cupName,
          widget.gameResult.name,
          (newValue) {
            logger.d(newValue);
          },
        ),
        SizedBox(height: SizeConfig.smallMargin),
        EditableIconTextFieldDate(
          icon: 'assets/calendar_128.png',
          labelTitle: '',
          initialDateTime: widget.gameResult.gameDate ?? DateTime.now(),
          function: (newValue) {
            logger.d(newValue);
          },
        ),
        SizedBox(height: SizeConfig.smallMargin),
        Row(
          children: [
            EditableIconIntTextField(
                icon: 'assets/multi-person_128.png',
                labelTitle: AppLocalizations.of(context)!.player,
                initialValue: playerCount,
                function: (newValue) {
                  logger.d(newValue);
                },
                node: _playerCountNode
            ),
            const SizedBox(width: SizeConfig.smallMargin),
            EditableIconIntTextField(
                icon: 'assets/casino-chip-money_128.png',
                labelTitle: AppLocalizations.of(context)!.rate,
                initialValue: rate,
                function: (newValue) {
                  logger.d(newValue);
                },
                node: _rateNode
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
}