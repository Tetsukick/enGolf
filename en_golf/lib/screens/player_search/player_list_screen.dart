import 'package:engolf/config/config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';

import '../../common/color_config.dart';
import '../../model/floor/db/database.dart';
import '../../model/floor/entity/player.dart';
import '../../utils/logger.dart';

class PlayerListScreen extends StatefulWidget {
  const PlayerListScreen({Key? key}) : super(key: key);

  @override
  _PlayerListScreenState createState() => _PlayerListScreenState();
}

class _PlayerListScreenState extends State<PlayerListScreen> {
  AppDatabase? database;
  List<Player> playerList = [];
  String searchWord = '';
  TextEditingController searchWordController = TextEditingController();

  @override
  void initState() {
    initializeDB();
    super.initState();
  }

  @override
  void dispose() {
    searchWordController.dispose();
    super.dispose();
  }

  void initializeDB() async {
    final _database = await $FloorAppDatabase
        .databaseBuilder(Config.dbName)
        .build();
    setState(() => database = _database);
    initializePlayerList();
  }
  
  void initializePlayerList() async {
    List<Player> _playerList = [];
    _playerList.addAll(await database?.playerDao.findAllPlayers() ?? []);
    setState(() => playerList = _playerList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Player List'),
        backgroundColor: ColorConfig.bgDarkGreen,
      ),
      body: SafeArea(
        child: Column(
          children: [
            searchBar(),
            _playerListView(),
          ],
        ),
      ),
    );
  }

  Widget searchBar() {
    return TextFormField(
        controller: searchWordController,
        decoration: InputDecoration(
          border: InputBorder.none,
          isDense: true,
          filled: true,
          fillColor: Theme.of(context).primaryColorLight,
        ),
        onFieldSubmitted: (word) {
          setState(() {
            searchWord = searchWordController.text;
          });
        }
    );
  }

  Widget _playerListView() {
      return ListView.builder(
        padding: EdgeInsets.all(36.0),
        shrinkWrap: true,
        itemCount: playerList.length + 1,
        itemBuilder: (BuildContext context, int index) {
          if (index == 0) {
            return Container(
              child: GestureDetector(
                onTap: () {
                  database?.playerDao.insertPlayer(Player(
                    name: searchWord
                  ));
                },
                child: Text(
                  '${searchWord} を追加',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 25.0),
                ),
              ),
            );
          } else {
            return playerCard(playerList[index - 1]);
          }
        },
      );
  }

  Widget buildFloatingSearchBar() {
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

    return FloatingSearchBar(
      scrollPadding: const EdgeInsets.only(top: 16, bottom: 16),
      transitionDuration: const Duration(milliseconds: 800),
      transitionCurve: Curves.easeInOut,
      physics: const BouncingScrollPhysics(),
      axisAlignment: isPortrait ? 0.0 : -1.0,
      openAxisAlignment: 0.0,
      width: isPortrait ? 600 : 500,
      debounceDelay: const Duration(milliseconds: 500),
      onQueryChanged: (query) {
        logger.d(query);

        if (query.length >= 2) {
          // search(query);
        }
      },
      transition: CircularFloatingSearchBarTransition(),
      actions: [
        FloatingSearchBarAction.searchToClear(
          showIfClosed: false,
        ),
      ],
      builder: (context, transition) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: playerList.map((player) {
              return playerCard(player);
            }).toList(),
          ),
        );
      },
    );
  }

  Widget playerCard(Player player) {
    return Card(
      color: ColorConfig.bgDarkGreen,
      elevation: 1.5,
      margin: const EdgeInsets.fromLTRB(6, 8, 6, 0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      child: InkWell(
        onTap: () {
          Navigator.pop(context, player);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(padding: EdgeInsets.only(left: 8)),
              Expanded(
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        player.name ?? '',
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
            ],
          ),
        ),
      ),
    );
  }
}
