import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'utils.dart';
import 'widgets.dart';
import 'olympic_bloc.dart';
import 'constants.dart' as Constants;

class olympic_screen extends StatelessWidget {

  @override
  Widget build(context) {
    final olympicBloc = Provider.of<OlympicBloc>(context);
    final Size size = MediaQuery.of(context).size;
    return CustomScrollView(slivers: <Widget>[
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
                          onChanged: ((text) {
                            int rate;
                            try {
                              rate = int.parse(text);
                              olympicBloc.changeRateAction.add(rate);
                            } catch (e) {
                              print(e);
                            }
                          }),
                        );
                      }),
                ),
                Container(
                  width: size.width / 4,
                  child: StreamBuilder(
                      stream: olympicBloc.playerCount,
                      builder: (context, snapshot) {
                        return TextFormField(
                          controller: TextEditingController(text: snapshot.data.toString()),
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
                                    scrollController: FixedExtentScrollController(initialItem: snapshot.data - 1),
                                    itemExtent: 40,
                                    children: _playerCountItems.map(_pickerItem).toList(),
                                    onSelectedItemChanged: ((index) {
                                      olympicBloc.changePlayerCountAction.add(_playerCountItems[index]);
                                    }),
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
                List<Player> players = snapshot.data;
                return ListView.builder(
                    itemCount: players.length,
                    itemBuilder: (context, int index) {
                      return SafeArea(
                          top: false,
                          bottom: false,
                          child: ScoreCard(color: Constants.colors[players[index].rank], player: players[index],)
                      );
                    });
              }
            }),
      ),
      ),
    ],
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