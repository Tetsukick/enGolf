import 'dart:async';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:math';

class DiceBloc {
  // input
  final _rangeController = BehaviorSubject<RangeValues>.seeded(RangeValues(1, 18));
  Sink<RangeValues> get changeRangeAction => _rangeController.sink;
  Stream<RangeValues> get range => _rangeController.stream;

  final _historyController = BehaviorSubject<List<int>>.seeded([]);
  Stream<List<int>> get histories => _historyController.stream;

  RangeValues _range = RangeValues(1, 18);
  List<int> _histories = [];

  DiceBloc() {
    _listenRange();
//    _historyController.add(_histories);
  }

  void _listenRange() {
    _rangeController.stream.listen((newRange) {
      _range = newRange;
    });
  }

  void createRandomNumber() {
    final numOfRange = _range.end.round() - _range.start.round() + 1;
    final List<int> numbers = List.generate(numOfRange, (i) => i + _range.start.round());

    var rand = new Random();
    int lottery = rand.nextInt(numOfRange);

    _histories.add(numbers[lottery]);
    _historyController.add(_histories);
  }

  void dispose() {
    _rangeController.close();
  }
}