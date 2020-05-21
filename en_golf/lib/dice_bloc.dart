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

  final _isAllowedDuplicattionController = BehaviorSubject<bool>.seeded(true);
  Sink<bool> get changeIsAllowedAction => _isAllowedDuplicattionController.sink;
  Stream<bool> get isAllowed => _isAllowedDuplicattionController.stream;

  RangeValues _range = RangeValues(1, 18);
  List<int> _histories = [];
  bool _isAllowed = true;

  DiceBloc() {
    _listenRange();
    _listenIsAllowed();
  }

  void _listenRange() {
    range.listen((newRange) {
      _range = newRange;
    });
  }

  void _listenIsAllowed() {
    isAllowed.listen((newValue) {
      _isAllowed = newValue;
    });
  }

  void createRandomNumber() {
    final numOfRange = _range.end.round() - _range.start.round() + 1;
    List<int> numbers = List.generate(numOfRange, (i) => i + _range.start.round());
    if (!_isAllowed) {
      _histories.forEach((targetNum) {
        numbers.removeWhere((number) => number == targetNum);
        print(numbers);
      });
    }
    if (numbers.length == 0) {
      return;
    }

    var rand = new Random();
    int lottery = rand.nextInt(numbers.length);

    _histories.add(numbers[lottery]);
    _historyController.add(_histories);
  }

  void reset() {
    _histories.clear();
    _historyController.add(_histories);
  }

  void undo() {
    _histories.removeLast();
    _historyController.add(_histories);
  }

  void dispose() {
    _rangeController.close();
  }
}