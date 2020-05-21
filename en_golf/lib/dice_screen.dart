import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'utils.dart';
import 'widgets.dart';
import 'dice_bloc.dart';
import 'olympic_bloc.dart';
import 'constants.dart' as Constants;

class DiceScreen extends StatelessWidget {
  final double min = 1;
  final double max = 18;

  @override
  Widget build(BuildContext context) {
    final diceBloc = Provider.of<DiceBloc>(context);

    return Scaffold(
      body: Container(
        child: StreamBuilder(
            stream: diceBloc.range,
            builder: (context, snapshot) {
              if (snapshot.data == null) {
                print(snapshot);
                print('null');
                return Center(
                  child: Text('error'),
                );
              } else {
                RangeValues _range = snapshot.data;
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 50,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Text(
                          _range.start.round().toString(),
                          style: TextStyle(fontSize: 30),
                        ),
                        SliderTheme(
                          data: SliderThemeData(
                            activeTrackColor: Colors.lightGreen,
                            showValueIndicator: ShowValueIndicator.always,
                          ),
                          child: RangeSlider(
                            labels: RangeLabels(_range.start.round().toString(), _range.end.round().toString()),
                            values: _range,
                            min: min,
                            max: max,
                            onChanged: (values) {
                              diceBloc.changeRangeAction.add(values);
                            },
                          ),
                        ),
                        Text(
                          _range.end.round().toString(),
                          style: TextStyle(fontSize: 30),
                        ),
                      ],
                    ),
                  ],
                );
              }
            }
        ),
      ),
    );
  }

//  Widget createSlider(BuildContext context) {
//    final diceBloc = Provider.of<DiceBloc>(context);
//
//    return Container(
//      child: StreamBuilder(
//        stream: diceBloc.range,
//        builder: (context, snapshot) {
//          if (snapshot.data == null) {
//            print('null');
//            return Center(
//              child: Text('error'),
//            );
//          } else {
//            RangeValues _range = snapshot.data;
//            return Column(
//              mainAxisAlignment: MainAxisAlignment.start,
//              children: <Widget>[
//                SizedBox(height: 50,),
//                SliderTheme(
//                  data: SliderThemeData(
//                    activeTrackColor: Colors.red,
//                    showValueIndicator: ShowValueIndicator.always,
//                  ),
//                  child: RangeSlider(
//                    labels: RangeLabels(_range.start.toString(), _range.end.toString()),
//                    values: _range,
//                    min: 1,
//                    max: 100,
//                    divisions: 100,
//                    onChanged: (values) {
//                      diceBloc.changeRangeAction.add(values);
//                    },
//                  ),
//                ),
//                Container(
//                  padding: EdgeInsets.all(20),
//                  child: Row(
//                    mainAxisAlignment: MainAxisAlignment.spaceAround,
//                    children: <Widget>[
//                      Text(
//                        _range.start.toString(),
//                        style: TextStyle(fontSize: 40),
//                      ),
//                      Text(
//                        _range.end.toString(),
//                        style: TextStyle(fontSize: 40),
//                      ),
//                    ],
//                  ),
//                )
//              ],
//            );
//          }
//        }
//      ),
//    );
//  }

}