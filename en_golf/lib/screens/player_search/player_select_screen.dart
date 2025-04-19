import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:engolf/common/size_config.dart';
import 'package:engolf/config/config.dart';
import 'package:engolf/screens/player_search/widget/player_card.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:material_floating_search_bar_2/material_floating_search_bar_2.dart';

import '../../common/color_config.dart';
import '../../model/floor/db/database.dart';
import '../../model/floor/entity/player.dart';
import '../../model/floor/migrations/migration_v2_to_v3_add_game_result_table.dart';
import '../../utils/logger.dart';

class PlayerSelectScreen extends StatefulWidget {
  const PlayerSelectScreen({Key? key}) : super(key: key);

  @override
  _PlayerSelectScreenState createState() => _PlayerSelectScreenState();
}

class _PlayerSelectScreenState extends State<PlayerSelectScreen> {
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
        .addMigrations([migration2to3])
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
      backgroundColor: ColorConfig.bgGreenPrimary,
      appBar: AppBar(
        title: Text('Player List'),
        backgroundColor: ColorConfig.bgDarkGreen,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              searchBar(),
              _playerListView(),
            ],
          ),
        ),
      ),
    );
  }

  Widget searchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: SizeConfig.smallestMargin, vertical: SizeConfig.smallMargin),
      child: TextFormField(
          controller: searchWordController,
          style: TextStyle(
            color: ColorConfig.textGreenLight,
            fontSize: 16,
          ),
          decoration: InputDecoration(
            hintText: 'Search Player Name',
            contentPadding: EdgeInsets.symmetric(horizontal: SizeConfig.smallMargin, vertical: SizeConfig.smallestMargin),
            border: const OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.white, width: 0.0),
            ),
          ),
          onChanged: (word) {
            search(word);
            setState(() {
              searchWord = searchWordController.text;
            });
          },
      ),
    );
  }

  Widget _playerListView() {
      return ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: SizeConfig.smallMargin, horizontal: SizeConfig.smallestMargin),
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        itemCount: playerList.length + 1,
        itemBuilder: (BuildContext context, int index) {
          if (index == 0) {
            final title = searchWord.isEmpty ? '新規追加' : '$searchWord を追加';
            return Container(
              child: InkWell(
                onTap: () {
                  if (searchWord.isEmpty) {
                    _showNewPlayerDialog(context);
                  } else {
                    _registerNewPlayer(searchWord);
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/add-user_128.png',
                      width: 24,
                    ),
                    const SizedBox(width: SizeConfig.smallMargin),
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return PlayerCard(player: playerList[index - 1], onTap: () {
              Navigator.pop<Player>(context, playerList[index - 1]);
            });
          }
        },
      );
  }

  Future<void> _registerNewPlayer(String playerName) async {
    final _currentPlayers = await database?.playerDao.findAllPlayers();

    if (_currentPlayers != null
        && _currentPlayers.any((player) => player.name == playerName)) {
      await AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.rightSlide,
        headerAnimationLoop: false,
        title: 'Error',
        desc:
        '$playerName is already registered.',
        btnOkOnPress: () {
          // Navigator.pop(context);
        },
        btnOkIcon: Icons.cancel,
        btnOkColor: Colors.red,
      ).show();
    } else {
      final _player = Player(name: playerName);
      database?.playerDao.insertPlayer(_player);
      Navigator.pop<Player>(context, _player);
    }
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
              return PlayerCard(player: player, onTap: () {
                Navigator.pop<Player>(context, player);
              });
            }).toList(),
          ),
        );
      },
    );
  }

  Future<void> search(String search) async {
    final _playerList = await database?.playerDao.findAllPlayers();
    final searchPlayerList = _playerList?.where((player) {
        return player.name!.contains(search);
      }).toList();

    setState(() => playerList = searchPlayerList ?? []);
  }

  Future<void> _showNewPlayerDialog(BuildContext context) async {
    final _newPlayerTextEditingController = TextEditingController();

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('新規Playerの追加'),
            content: TextField(
              controller: _newPlayerTextEditingController,
              decoration: const InputDecoration(hintText: "Input Player Name"),
            ),
            actions: <Widget>[
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
                child: Text('Cancel'),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
              ),
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
                child: Text('Add'),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                    if (_newPlayerTextEditingController.text.isNotEmpty) {
                      _registerNewPlayer(_newPlayerTextEditingController.text);
                    }
                  });
                },
              ),
            ],
          );
        },
      );
  }
}
