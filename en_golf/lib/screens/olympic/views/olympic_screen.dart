import 'package:engolf/common/color_config.dart';
import 'package:engolf/common/size_config.dart';
import 'package:engolf/screens/olympic/views/score_card.dart';
import 'package:engolf/screens/olympic/views/text_fields.dart';
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
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 55),
                            child: ListView.builder(
                              itemCount: players.length,
                              itemBuilder: (BuildContext context, int index) {
                                return AnimationConfiguration.staggeredList(
                                  position: index,
                                  duration: const Duration(milliseconds: 375),
                                  child: SlideAnimation(
                                    verticalOffset: 50.0,
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
    );
  }

  Widget header(BuildContext context) {
    final olympicBloc = Provider.of<OlympicBloc>(context);
    return Column(
      children: [
        SizedBox(height: SizeConfig.smallestMargin),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(width: SizeConfig.smallMargin),
            SvgPicture.asset('assets/engolf_logo_only.svg'),
          ],
        ),
        IconTextField(
          'assets/golf_course.svg',
          AppLocalizations.of(context).cupName,
        ),
        SizedBox(height: SizeConfig.smallMargin),
        IconTextField(
          'assets/calendar.svg',
          '',
        ),
        SizedBox(height: SizeConfig.smallMargin),
        IconStreamTextField(
            'assets/people.svg',
            AppLocalizations.of(context).player,
            olympicBloc.playerCount,
            olympicBloc.changePlayerCountAction.add),
        SizedBox(height: SizeConfig.smallMargin),
        IconStreamTextField(
            'assets/money.svg',
            AppLocalizations.of(context).rate,
            olympicBloc.rate,
            olympicBloc.changeRateAction.add),
      ],
    );
  }
}