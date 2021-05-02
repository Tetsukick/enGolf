import 'dart:async';
import 'package:rxdart/rxdart.dart';

class OlympicBloc {
  OlympicBloc() {
    _playersController.add(_players);
    _playerCountController.add(_playerCount);
    _rateController.add(_rate);

    listenRate();
    listenPlayerCount();
    listenPlayer();
  }
  
  // input
  final _rateController = BehaviorSubject<int>();
  Sink<int> get changeRateAction => _rateController.sink;
  Stream<int> get rate => _rateController.stream;

  final _playerCountController = BehaviorSubject<int>();
  Sink<int> get changePlayerCountAction => _playerCountController.sink;
  Stream<int> get playerCount => _playerCountController.stream;
  
  final _playerController = BehaviorSubject<Player>();
  Sink<Player> get changePlayerAction => _playerController.sink;

  //output
  final _playersController = BehaviorSubject<List<Player>>();
  Stream<List<Player>> get players => _playersController.stream;

  int _playerCount = 4;
  int _rate = 1;
  List<Player> _players = [
    Player(id: 0, name: 'Player1', score: 0),
    Player(id: 1, name: 'Player2', score: 0),
    Player(id: 2, name: 'Player3', score: 0),
    Player(id: 3, name: 'Player4', score: 0),
  ];

  void listenRate() {
    _rateController.stream.listen((newRate) {
      _rate = newRate;

      updatePlayer();
    });
  }

  void listenPlayer() {
    _playerController.stream.listen((player) {
      _players[player.id] = player;

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
          _players.add(Player(id: currentNum - 1, name: name, score: 0));
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
  }
  
  void recalculate() {
    _players = _players.map((player) {
      player.result = formulaOlympic(player.id);
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

  void dispose() {
    _rateController.close();
    _playerCountController.close();
    _playerController.close();
    _playersController.close();
  }
}

class Player {
  int id;
  int rank = 1;
  String name;
  int score;
  int result = 0;

  Player({this.id, this.name, this.score});
}