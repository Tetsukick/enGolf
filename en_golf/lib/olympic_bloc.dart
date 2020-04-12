import 'dart:async';
import 'package:rxdart/rxdart.dart';

class OlympicBloc {
  // input
  final _rateController = BehaviorSubject<int>();
  Sink<int> get changeRateAction => _rateController.sink;

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
    Player(0, 'Player1', 0),
    Player(1, 'Player2', 0),
    Player(2, 'Player3', 0),
    Player(3, 'Player4', 0),
  ];

  OlympicBloc() {
    _playersController.add(_players);
    _playerCountController.add(_playerCount);

    _rateController.stream.listen((newRate) {
      _rate = newRate;
//      _countController.sink.add(_count);
    });

    listenPlayerCount();
    
    _playerController.stream.listen((player) {
      _players[player.id] = player;

      _playersController.add(_players);
    });
  }
  
  void listenPlayerCount() {
    _playerCountController.stream.listen((newCount) {

      int diff = newCount - _playerCount;

      if (diff == 0) {
        return;
      } else if (diff > 0) {
        int currentNum = _players.length;
        for (int i = 1; i <= diff; i++) {
          currentNum++;
          String name = 'Player' + currentNum.toString();
          _players.add(new Player(currentNum - 1, name, 0));
        }
      } else if (diff < 0) {
        for (int i = 0; i > diff; i--) {
          _players.removeLast();
        }
      }

      _playerCount = newCount;

      _playersController.add(_players);
      _playerCountController.add(_playerCount);
    });
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
  String name;
  int score;
  int result;

  Player(id, name, score) {
    this.id = id;
    this.name = name;
    this.score = score;
  }
}