import 'dart:async';
import 'package:rxdart/rxdart.dart';

class OlympicBloc {
  // input
  final _rateController = BehaviorSubject<int>();
  Sink<int> get changeRateAction => _rateController.sink;

  final _playerCountController = BehaviorSubject<int>();
  Sink<int> get changePlayerCountAction => _playerCountController.sink;

  //output
  final _playersController = BehaviorSubject<List<Player>>();
  Stream<List<Player>> get players => _playersController.stream;

  int _playerCount = 4;
  int _rate = 1;
  List<Player> _players = [
    Player('Player1', 0),
    Player('Player2', 0),
    Player('Player3', 0),
    Player('Player4', 0),
  ];

  OlympicBloc() {
    _playersController.add(_players);

    _rateController.stream.listen((newRate) {
      _rate = newRate;
//      _countController.sink.add(_count);
    });

    _playerCountController.stream.listen((newCount) {

      int diff = newCount - _playerCount;

      if (diff == 0) {
        return;
      } else if (diff > 0) {
        int currentNum = _players.length;
        for (int i = 1; i <= diff; i++) {
          currentNum++;
          String name = 'Player' + currentNum.toString();
          _players.add(new Player(name, 0));
        }
      } else if (diff < 0) {
        for (int i = 0; i > diff; i--) {
          _players.removeLast();
        }
      }

      _playerCount = newCount;

      _playersController.add(_players);
    });
  }

  void dispose() {
    _rateController.close();
    _playerCountController.close();
    _playersController.close();
  }
}

class Player {
  String name;
  int score;
  int result;

  Player(name, score) {
    this.name = name;
    this.score = score;
  }
}