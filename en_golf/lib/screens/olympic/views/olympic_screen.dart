import 'package:engolf/screens/olympic/views/score_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:admob_flutter/admob_flutter.dart';

import 'package:provider/provider.dart';

import '../../../common/utils.dart';
import '../model/olympic_bloc.dart';
import '../../../common/constants.dart' as Constants;

class OlympicScreen extends StatelessWidget {

  @override
  Widget build(context) {
    final olympicBloc = Provider.of<OlympicBloc>(context);
    final size = MediaQuery.of(context).size;
    return Stack(
      children: [
        CustomScrollView(slivers: <Widget>[
        SliverAppBar(
          pinned: true,
          expandedHeight: 150,
          collapsedHeight: 100,
          flexibleSpace: FlexibleSpaceBar(
            titlePadding: const EdgeInsets.all(0),
            title: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                titleTextField(
                    context,
                    AppLocalizations.of(context).rate,
                    olympicBloc.rate,
                    olympicBloc.changeRateAction.add),
                titleTextField(
                    context,
                    AppLocalizations.of(context).player,
                    olympicBloc.playerCount,
                    olympicBloc.changePlayerCountAction.add),
              ],
            ),
            background: Image.asset('assets/top-background.jpg', fit: BoxFit.cover),
          ),
        ),
        SliverFillRemaining(child:
          CupertinoPageScaffold(
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
    );
  }

  Widget titleTextField(
      BuildContext context,
      String labelTitle,
      Stream<int> stream,
      Function(int) function) {
    final size = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      width: size.width / 3,
      child: StreamBuilder(
          stream: stream,
          builder: (context, snapshot) {
            final _controller = TextEditingController.fromValue(
              TextEditingValue(
                text: snapshot?.data?.toString() ?? "",
                selection: TextSelection.collapsed(
                    offset: snapshot?.data?.toString()?.length ?? 0),
              ),
            );
            return TextFormField(
              controller: _controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: labelTitle,
                labelStyle: TextStyle(color: Colors.white),
              ),
              style: TextStyle(color: Colors.white),
              onChanged: (text) {
                try {
                  final value = int.parse(text);
                  function(value);
                }
                on Exception catch(e) {
                  print(e);
                }
              },
            );
          }),
    );
  }
}