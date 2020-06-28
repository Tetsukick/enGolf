import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:admob_flutter/admob_flutter.dart';

import 'package:provider/provider.dart';

import 'utils.dart';
import 'widgets.dart';
import 'olympic_bloc.dart';
import 'dice_bloc.dart';
import 'constants.dart' as Constants;

class OlympicScreen extends StatelessWidget {

  @override
  Widget build(context) {
    final olympicBloc = Provider.of<OlympicBloc>(context);
    final diceBloc = Provider.of<DiceBloc>(context);
    final size = MediaQuery.of(context).size;
    return Stack(
      children: [
        CustomScrollView(slivers: <Widget>[
        SliverAppBar(
          pinned: true,
          expandedHeight: 150,
          flexibleSpace: FlexibleSpaceBar(
            title: Container(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    width: size.width / 3,
                    child: StreamBuilder(
                        stream: olympicBloc.rate,
                        builder: (context, snapshot) {
                          return TextFormField(
                            controller: TextEditingController(text: snapshot.data.toString()),
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'Rate',
                              labelStyle: TextStyle(
                                  color: Colors.white
                              ),
                            ),
                            style: TextStyle(
                                color: Colors.white
                            ),
                            onChanged: (text) {
                              int rate;
                              try {
                                rate = int.parse(text);
                                olympicBloc.changeRateAction.add(rate);
                              }
                              on Exception catch(e) {
                                print(e);
                              }
                            },
                          );
                        }),
                  ),
                  Container(
                    width: size.width / 4,
                    child: StreamBuilder(
                        stream: olympicBloc.playerCount,
                        builder: (context, snapshot) {
                          final playerCount = snapshot.data as int;
                          return TextFormField(
                            controller: TextEditingController(text: playerCount.toString()),
                            focusNode: AlwaysDisabledFocusNode(),
                            decoration: InputDecoration(
                              labelText: 'Player',
                              labelStyle: TextStyle(
                                  color: Colors.white
                              ),
                            ),
                            style: TextStyle(
                                color: Colors.white
                            ),
                            onTap: () => showModalBottomSheet<void>(
                              context: context,
                              builder: (BuildContext context) {
                                FocusScope.of(context).unfocus();
                                return Container(
                                  height: MediaQuery.of(context).size.height / 3,
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: CupertinoPicker(
                                      scrollController: FixedExtentScrollController(initialItem: playerCount - 1),
                                      itemExtent: 40,
                                      children: _playerCountItems.map(_pickerItem).toList(),
                                      onSelectedItemChanged: (index) {
                                        olympicBloc.changePlayerCountAction.add(_playerCountItems[index]);
                                      },
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        }),
                  ),
                ],
              ),
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

  final List<int> _playerCountItems = List.generate(50, (i) => i + 1);

  Widget _pickerItem(int str) {
    return Text(
      str.toString(),
      style: const TextStyle(fontSize: 28),
    );
  }
}