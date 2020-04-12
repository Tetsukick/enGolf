import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lorem/flutter_lorem.dart';

import 'package:provider/provider.dart';

import 'utils.dart';
import 'widgets.dart';
import 'olympic_bloc.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: MultiProvider(
        providers: [
          Provider<OlympicBloc>(
            create: (context) => OlympicBloc(),
            dispose: (context, bloc) => bloc.dispose(),
          ),
        ],
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: NewsTab(),
        ),
      ),
    );
  }
}

class NewsTab extends StatelessWidget {
  final colors = getRandomColors(51);

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
//            margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
            child: Row( // 1行目
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
                        child: Card(
                          elevation: 1.5,
                          margin: EdgeInsets.fromLTRB(6, 12, 6, 0),
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CircleAvatar(
                                    backgroundColor: colors[players[index].rank],
                                    child: Text(
                                      players[index].rank.toString(),
                                      style: TextStyle(
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
                                                controller: TextEditingController(text: players[index].name),
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
                                                onFieldSubmitted: ((text) {
                                                  players[index].name = text;
                                                  olympicBloc.changePlayerAction.add(players[index]);
                                                }),
                                              ),
                                              Padding(padding: EdgeInsets.only(top: 8)),
                                              Text(
                                                players[index].result.toString(),
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          width: 100,
                                          child: TextFormField(
                                            focusNode: AlwaysDisabledFocusNode(),
                                            controller: TextEditingController(text: _scoreItems.firstWhere((score) => score == players[index].score).toString()),
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
                                                      scrollController: FixedExtentScrollController(initialItem: _scoreItems.indexOf(players[index].score)),
                                                      itemExtent: 40,
                                                      children: _scoreItems.map(_pickerItem).toList(),
                                                      onSelectedItemChanged: ((pickerIndex) {
                                                        players[index].score = _scoreItems[pickerIndex];
                                                        olympicBloc.changePlayerAction.add(players[index]);
                                                      }),
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
                        ),
                      );
                    });
              }
            }),
      ),
        ),
    ],
    );
  }

  final List<int> _playerCountItems = new List.generate(50, (i) => i + 1);
  final List<int> _scoreItems = new List.generate(201, (i) => i - 100);

  Widget _pickerItem(int str) {
    return Text(
      str.toString(),
      style: const TextStyle(fontSize: 28),
    );
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
  @override
  bool get hasPrimaryFocus => false;
}
