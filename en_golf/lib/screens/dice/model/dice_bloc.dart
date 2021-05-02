import 'dart:async';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:math';

class DiceBloc {
  DiceBloc() {
    _listenRange();
    _listenIsAllowed();
  }

  // input
  final _rangeController = BehaviorSubject<RangeValues>.seeded(RangeValues(1, 18));
  Sink<RangeValues> get changeRangeAction => _rangeController.sink;
  Stream<RangeValues> get range => _rangeController.stream;

  final _historyController = BehaviorSubject<List<int>>.seeded([]);
  Stream<List<int>> get histories => _historyController.stream;

  final _isAllowedDuplicationController = BehaviorSubject<bool>.seeded(true);
  Sink<bool> get changeIsAllowedAction => _isAllowedDuplicationController.sink;
  Stream<bool> get isAllowed => _isAllowedDuplicationController.stream;

  RangeValues _range = const RangeValues(1, 18);
  List<int> _histories = [];
  bool _isAllowed = true;

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
      for (final history in _histories) {
        numbers.removeWhere((number) => number == history);
      }
    }
    if (numbers.isEmpty) {
      return;
    }

    final rand = Random();
    final _lottery = rand.nextInt(numbers.length);

    _histories.add(numbers[_lottery]);
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
    _historyController.close();
    _isAllowedDuplicationController.close();
  }
}