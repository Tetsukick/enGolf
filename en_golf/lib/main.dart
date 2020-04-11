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
        primarySwatch: Colors.blue,
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

  @override
  Widget build(context) {
    final olympicBloc = Provider.of<OlympicBloc>(context);
    final Size size = MediaQuery.of(context).size;
    return CustomScrollView(slivers: <Widget>[
      SliverAppBar(
        pinned: true,
        expandedHeight: 200,
        flexibleSpace: FlexibleSpaceBar(
          title: Container(
//            margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
            child: Row( // 1行目
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  width: size.width * 2 / 3,
                  child: TextFormField(
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
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Player',
                      labelStyle: TextStyle(
                          color: Colors.white
                      ),
                    ),
                    style: TextStyle(
                        color: Colors.white
                    ),
                    onChanged: ((text) {
                      int count;
                      try {
                        count = int.parse(text);
                        olympicBloc.changePlayerCountAction.add(count);
                      } catch (e) {
                        print(e);
                      }
                    }),
                  ),
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
                final colors = getRandomColors(players.length);
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
                                    backgroundColor: colors[index],
                                    child: Text(
                                      players[index].name.substring(0, 1),
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  Padding(padding: EdgeInsets.only(left: 16)),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          players[index].name,
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Padding(padding: EdgeInsets.only(top: 8)),
                                        Text(
                                          players[index].score.toString(),
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
}
