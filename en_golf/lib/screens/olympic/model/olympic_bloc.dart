import 'dart:async';

import 'package:engolf/common/shared_preference.dart';
import 'package:engolf/config/config.dart';
import 'package:engolf/model/floor/db/database.dart';
import 'package:engolf/screens/olympic/model/player_model.dart';
import 'package:rxdart/rxdart.dart';

import '../../../model/floor/migrations/migration_v2_to_v3_add_game_result_table.dart';

class OlympicBloc {
  OlympicBloc() {
    _playersController.add(_players);
    _playerCountController.add(_playerCount);
    _rateController.add(_rate);
    _dateController.add(_date);
    _gameNameController.add(_gameName);

    _initData();

    listenRate();
    listenPlayerCount();
    listenPlayer();
    listenGameName();
    listenGameDate();
  }
  
  // input
  final _rateController = BehaviorSubject<int>();
  Sink<int> get changeRateAction => _rateController.sink;
  Stream<int> get rate => _rateController.stream;

  final _playerCountController = BehaviorSubject<int>();
  Sink<int> get changePlayerCountAction => _playerCountController.sink;
  Stream<int> get playerCount => _playerCountController.stream;
  
  final _playerController = BehaviorSubject<PlayerResult?>();
  Sink<PlayerResult?> get changePlayerAction => _playerController.sink;

  final _gameNameController = BehaviorSubject<String>();
  Sink<String> get changeGameNameAction => _gameNameController.sink;
  Stream<String> get gameName => _gameNameController.stream;

  final _dateController = BehaviorSubject<DateTime>();
  Sink<DateTime> get changeDateAction => _dateController.sink;
  Stream<DateTime> get date => _dateController.stream;

  //output
  final BehaviorSubject<List<PlayerResult?>> _playersController = BehaviorSubject<List<PlayerResult>>();
  Stream<List<PlayerResult?>> get players => _playersController.stream;

  int _playerCount = 4;
  int _rate = 1;
  DateTime _date = DateTime.now();
  List<PlayerResult> _players = [
    PlayerResult(id: 0, name: 'Player1', score: 0),
    PlayerResult(id: 1, name: 'Player2', score: 0),
    PlayerResult(id: 2, name: 'Player3', score: 0),
    PlayerResult(id: 3, name: 'Player4', score: 0),
  ];
  AppDatabase? _database;
  String _gameName = "";

  Future<void> _initData() async {
    await _initiateDatabase();
    await _initiatePlayers();
  }

  Future<void> _initiateDatabase() async {
    _database = await $FloorAppDatabase
        .databaseBuilder(Config.dbName)
        .addMigrations([migration2to3])
        .build();
  }

  Future<void> _initiatePlayers() async {
    final previousPlayers = await SharedPreferenceManager().getPlayers();

    if (previousPlayers.isNotEmpty) {
      _players = previousPlayers;
    } else {
      final mainPlayer = await _database?.playerDao.findMainPlayers();
      if (mainPlayer != null) {
        _players[0] = PlayerResult(id: 0, name: mainPlayer.name, score: 0);
      }
    }
    _playerCount = _players.length;
    _playerCountController.add(_playerCount);
    updatePlayer();
  }

  Future<void> resetData() async {
    _playerCount = 4;
    _rate = 1;
    _date = DateTime.now();
    _players = [
      PlayerResult(id: 0, name: 'Player1', score: 0),
      PlayerResult(id: 1, name: 'Player2', score: 0),
      PlayerResult(id: 2, name: 'Player3', score: 0),
      PlayerResult(id: 3, name: 'Player4', score: 0),
    ];
    _gameName = "";
    final mainPlayer = await _database?.playerDao.findMainPlayers();
    if (mainPlayer != null) {
      _players[0] = PlayerResult(
          id: 0,
          name: mainPlayer.name,
          score: 0,
          playerID: mainPlayer.id);
    }
    _playerCountController.add(_playerCount);
    _rateController.add(_rate);
    _dateController.add(_date);
    _gameNameController.add(_gameName);
    updatePlayer();
  }

  void listenRate() {
    _rateController.stream.listen((newRate) {
      _rate = newRate;

      updatePlayer();
    });
  }

  void listenPlayer() {
    _playerController.stream.listen((player) {
      if (player == null || player.id == null) {
        return;
      }
      _players[player.id!] = player;

      updatePlayer();
    });
  }
  
  void listenPlayerCount() {
    _playerCountController.stream.listen((newCount) {

      final diff = newCount - _playerCount;

      if (diff == 0) {
        return;
      } else if (diff > 0) {
        var currentNum = _players.length;
        for (var i = 1; i <= diff; i++) {
          currentNum++;
          final name = 'Player$currentNum';
          _players.add(PlayerResult(id: currentNum - 1, name: name, score: 0));
        }
      } else if (diff < 0) {
        for (var i = 0; i > diff; i--) {
          _players.removeLast();
        }
      }

      _playerCount = newCount;

      updatePlayer();
      _playerCountController.add(_playerCount);
    });
  }

  void updatePlayer() {
    recalculate();
    setRank();
    _playersController.add(_players);
    SharedPreferenceManager().savePlayers(_players);
  }
  
  void recalculate() {
    _players = _players.map((player) {
      if (player == null) {
        return player;
      }
      player.result = formulaOlympic(player.id!);
      return player;
    }).toList();
  }

  void setRank() {
    final sortPlayers = _players.map((player) => player).toList()
      ..sort((a,b) => b.score - a.score);

    var rank = 1;
    final targetIndex = _players.indexOf(sortPlayers[0]);
    final targetPlayer = _players[targetIndex]
      ..rank = rank;
    _players[targetIndex] = targetPlayer;

    for (var i = 1; i < _players.length; i++) {
      if (sortPlayers[i].score != sortPlayers[i-1].score) {
        rank = i + 1;
      }
      final _targetIndex = _players.indexOf(sortPlayers[i]);
      final _targetPlayer = _players[_targetIndex]
        ..rank = rank;
      _players[_targetIndex] = _targetPlayer;
    }
  }

  int formulaOlympic(int index) {
    final playerScore = _players[index].score;
    final int totalScore = _players.fold(0, (curr, next) => curr + next.score);
    return ((playerScore * (_players.length - 1)) - (totalScore - playerScore)) * _rate;
  }

  void listenGameName() {
    _gameNameController.stream.listen((newGameName) {
      SharedPreferenceManager().setGameName(newGameName);
    });
  }

  void listenGameDate() {
    _dateController.stream.listen((newGameDate) {
      SharedPreferenceManager().setGameDate(newGameDate);
    });
  }

  void dispose() {
    _rateController.close();
    _playerCountController.close();
    _playerController.close();
    _playersController.close();
    _dateController.close();
    _gameNameController.close();
  }
}