import 'package:engolf/common/color_config.dart';
import 'package:engolf/common/size_config.dart';
import 'package:engolf/screens/olympic/model/olympic_bloc.dart';
import 'package:engolf/screens/olympic/model/player_model.dart';
import 'package:engolf/screens/olympic/views/score_card.dart';
import 'package:engolf/screens/olympic/views/text_fields.dart';
import 'package:engolf/screens/result_olympic/result_olympic_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:provider/provider.dart';

import '../../../common/utils.dart';
import '../model/olympic_bloc.dart';
import '../../../common/constants.dart' as Constants;

class OlympicScreen extends StatelessWidget {

  @override
  Widget build(context) {
    final olympicBloc = Provider.of<OlympicBloc>(context);
    return Container(
      padding: EdgeInsets.all(SizeConfig.mediumMargin),
      color: ColorConfig.bgGreenPrimary,
      child: SingleChildScrollView(
        child: Container(
          height: 550,
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
                            final players = snapshot.data as List<Player>;
                            return AnimationLimiter(
                              child: Container(
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 55),
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
                                                child: ScoreCard(color: Constants.colors[players[index].rank], player: players[index],)
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
                  child: AdmobBanner(
                    adUnitId: getBannerAdUnitId(),
                    adSize: AdmobBannerSize.LEADERBOARD,
                  ),
                ),
              )
            ]
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
            RaisedButton.icon(
              icon: SvgPicture.asset('assets/tolophy_dark_green.svg'),
              label: const Text('結果を表示'),
              onPressed: () async {
                Navigator.push(
                    context,
                    MaterialPageRoute<ResultOlympicScreen>(
                        builder: (BuildContext context) {
                          return ResultOlympicScreen();
                        },
                        fullscreenDialog: true));
              },
              color: Colors.green,
              textColor: Colors.white,
            ),
          ],
        ),
        IconTextField(
          'assets/golf_course.svg',
          AppLocalizations.of(context).cupName,
          olympicBloc.gameName,
          olympicBloc.changeGameNameAction.add,
        ),
        SizedBox(height: SizeConfig.smallMargin),
        IconTextFieldDate(
          'assets/calendar.svg',
          '',
          olympicBloc.date,
          olympicBloc.changeDateAction.add,
        ),
        SizedBox(height: SizeConfig.smallMargin),
        Row(
          children: [
            IconStreamTextField(
                'assets/people.svg',
                AppLocalizations.of(context).player,
                olympicBloc.playerCount,
                olympicBloc.changePlayerCountAction.add),
            const SizedBox(width: SizeConfig.smallMargin),
            IconStreamTextField(
                'assets/money.svg',
                AppLocalizations.of(context).rate,
                olympicBloc.rate,
                olympicBloc.changeRateAction.add),
          ],
        ),
      ],
    );
  }
}