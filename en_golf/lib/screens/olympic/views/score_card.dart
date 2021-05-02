import 'package:engolf/screens/olympic/model/olympic_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../common/utils.dart';

class ScoreCard extends StatelessWidget {
  const ScoreCard({
    Key key,
    this.color,
    this.player,
  }) : super(key: key);

  final Color color;
  final Player player;

  static final List<int> _scoreItems = List.generate(201, (i) => i - 100);

  Widget _pickerItem(int str) {
    return Text(
      str.toString(),
      style: const TextStyle(fontSize: 28),
    );
  }

  @override
  Widget build(BuildContext context) {
    final olympicBloc = Provider.of<OlympicBloc>(context);
    return Card(
      elevation: 1.5,
      margin: const EdgeInsets.fromLTRB(6, 12, 6, 0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      child: InkWell(
        // Make it splash on Android. It would happen automatically if this
        // was a real card but this is just a demo. Skip the splash on iOS.
        onTap: defaultTargetPlatform == TargetPlatform.iOS ? null : () {},
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundColor: color,
                child: Text(
                  player.rank.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.only(left: 16)),
              Expanded(
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            controller: TextEditingController(text: player.name),
                            decoration: InputDecoration(
                              enabledBorder: const OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.white, width: 0.0),
                              ),
                              labelStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                            ),
                            onFieldSubmitted: (text) {
                              final tempPlayer = player
                                ..name = text;
                              olympicBloc.changePlayerAction.add(tempPlayer);
                            },
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 15),
                            child: Text(
                              'result: ${player.result.toString()}',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 100,
                      child: TextFormField(
                        focusNode: AlwaysDisabledFocusNode(),
                        controller: TextEditingController(text: _scoreItems.firstWhere((score) => score == player.score).toString()),
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Score',
                          labelStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
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
                                  scrollController: FixedExtentScrollController(initialItem: _scoreItems.indexOf(player.score)),
                                  itemExtent: 40,
                                  children: _scoreItems.map(_pickerItem).toList(),
                                  onSelectedItemChanged: (pickerIndex) {
                                    player.score = _scoreItems[pickerIndex];
                                    olympicBloc.changePlayerAction.add(player);
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
