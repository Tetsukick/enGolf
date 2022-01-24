import 'dart:async';

import 'package:engolf/common/admob.dart';
import 'package:engolf/common/color_config.dart';
import 'package:flare_flutter/flare_controls.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flare_flutter/flare_actor.dart';

import 'package:provider/provider.dart';

import '../../../common/utils.dart';
import '../model/dice_bloc.dart';

class DiceScreen extends StatelessWidget {
  final double min = 1;
  final double max = 18;
  final ScrollController _scrollController = ScrollController();
  final FlareControls golfBallAnimationController = FlareControls();

  @override
  Widget build(BuildContext context) {
    final diceBloc = Provider.of<DiceBloc>(context);

    return Scaffold(
      backgroundColor: ColorConfig.bgGreenPrimary,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          _createSlider(context),
          _createHistoryParts(context: context, controller: _scrollController),
          StreamBuilder(
              stream: diceBloc.histories,
              builder: (context, snapshot) {
                final _histories = snapshot.data as List<int>;
                if (_histories == null || _histories.isEmpty) {
                  return Text(
                    AppLocalizations.of(context).shake,
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.white
                    ),
                  );
                } else {
                  golfBallAnimationController.play('start');
                  return _createAnimationGolfBallView(num: _histories.last, height: 150, width: 150);
                }
              }
          ),
          _createSubmitButton(context: context),
          Container(
            height: 50,
            child: const AdmobBanner(),
          ),
        ],
      ),
    );
  }

  Widget _createSlider(BuildContext context) {
    final diceBloc = Provider.of<DiceBloc>(context);

    return Container(
      child: StreamBuilder(
          stream: diceBloc.range,
          builder: (context, snapshot) {
            if (snapshot.data == null) {
              return const Center(
                child: Text('error'),
              );
            } else {
              var _range = snapshot.data as RangeValues;
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(height: 50,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Text(
                        _range.start.round().toString(),
                        style: const TextStyle(
                          fontSize: 30,
                          color: Colors.white
                        ),
                      ),
                      SliderTheme(
                        data: SliderThemeData(
                          activeTrackColor: ColorConfig.greenPrimary,
                          showValueIndicator: ShowValueIndicator.always,
                        ),
                        child: RangeSlider(
                          labels: RangeLabels(_range.start.round().toString(), _range.end.round().toString()),
                          values: _range,
                          min: min,
                          max: max,
                          onChanged: (value) {
                            _range = value;
                            diceBloc.changeRangeAction.add(value);
                          },
                        ),
                      ),
                      Text(
                        _range.end.round().toString(),
                        style: const TextStyle(
                          fontSize: 30,
                          color: Colors.white
                        ),
                      ),
                    ],
                  ),
                ],
              );
            }
          }
      ),
    );
  }

  Widget _createHistoryParts({BuildContext context, ScrollController controller}) {
    final diceBloc = Provider.of<DiceBloc>(context);

    return Column(
      children: <Widget>[
        _createHistoryView(context: context, controller: controller),
        _createButtons(context: context),
      ],
    );
  }

  Widget _createButtons ({BuildContext context}) {
    final diceBloc = Provider.of<DiceBloc>(context);

    return StreamBuilder(
        stream: diceBloc.histories,
        builder: (context, snapshot) {
          final _histories = snapshot.data as List<int>;
          if (_histories == null || _histories.isEmpty) {
            return Container();
          } else {
            return Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                RaisedButton(
                  child: Icon(
                    Icons.delete_forever,
                    color: Colors.white,
                  ),
                  color: ColorConfig.greenPrimary,
                  shape: const CircleBorder(),
                  onPressed: () {
                    diceBloc.reset();
                  },
                ),
                RaisedButton(
                  child: Icon(
                    Icons.undo,
                    color: Colors.white,
                  ),
                  color: ColorConfig.greenPrimary,
                  shape: CircleBorder(),
                  onPressed: () {
                    diceBloc.undo();
                    Timer(const Duration(milliseconds: 500), () => _scrollController.jumpTo(_scrollController.position.maxScrollExtent));
                  },
                ),
              ],
            );
          }
        }
    );
  }

  Widget _createHistoryView({BuildContext context, ScrollController controller}) {
    final diceBloc = Provider.of<DiceBloc>(context);

    return StreamBuilder(
        stream: diceBloc.histories,
        builder: (context, snapshot) {
          final _histories = snapshot.data as List<int>;
          if (_histories == null || _histories.isEmpty) {
            return Container();
          } else {
            return Center(
              child: Container(
                height: 50,
                child: ListView.builder(
                  controller: controller,
                  scrollDirection: Axis.horizontal,
                  itemCount: _histories.length,
                  itemBuilder: (context, int index) {
                    return _createGolfBallView(num: _histories[index], height: 50, width: 50);
                  }),
              ),
            );
          }
        }
    );
  }

  Widget _createGolfBallView({int num, double height, double width}) {
    return Container(
      height: height,
      width: width,
      decoration: const BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.fill,
              image: AssetImage('assets/golf_ball.png')
          )
      ),
      child: Center(
        child: Text(
          num.toString(),
          style: TextStyle(fontSize: height/2),
        ),
      ),
    );
  }

  Widget _createAnimationGolfBallView({int num, double height, double width}) {
    return Container(
      height: height,
      width: width,
      child: Stack(
        children: <Widget>[
          FlareActor(
            'assets/golf_ball_rotate.flr',
            animation: 'start',
            alignment: Alignment.center,
            controller: golfBallAnimationController,
            fit: BoxFit.fill,
          ),
          Center(
            child: Text(
              num.toString(),
              style: TextStyle(fontSize: height / 2),
            ),
          ),
        ],
      ),
    );
  }

  Widget _createSubmitButton({BuildContext context}) {
    final diceBloc = Provider.of<DiceBloc>(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        StreamBuilder(
          stream: diceBloc.isAllowed,
          builder: (context, snapshot) {
            final _isAllowed = snapshot.data as bool;
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Checkbox(
                  activeColor: ColorConfig.greenPrimary,
                  value: _isAllowed ?? true,
                  onChanged: (value) {
                    print('change');
                    diceBloc.changeIsAllowedAction.add(value);
                  },
                ),
                Text(
                  AppLocalizations.of(context).allowDuplicateNumber,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ],
            );
          },
        ),
        RaisedButton(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              AppLocalizations.of(context).shake,
              style: TextStyle(
                fontSize: 30,
                color: Colors.white,
              ),
            ),
          ),
          color: Colors.lightGreen,
          shape: const StadiumBorder(),
          onPressed: () {
            diceBloc.createRandomNumber();
            Timer(const Duration(milliseconds: 500), () => _scrollController.jumpTo(_scrollController.position.maxScrollExtent));
          },
        ),
      ],
    );
  }

}