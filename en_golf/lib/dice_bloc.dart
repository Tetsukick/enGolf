import 'dart:async';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class DiceBloc {
  // input
  final _rangeController = BehaviorSubject<RangeValues>.seeded(RangeValues(1, 18));
  Sink<RangeValues> get changeRangeAction => _rangeController.sink;
  Stream<RangeValues> get range => _rangeController.stream;

  RangeValues _range = RangeValues(1, 18);

  DiceBloc() {

    _listenRange();
  }

  void _listenRange() {
    _rangeController.stream.listen((newRange) {
      _range = newRange;
    });
  }

  void dispose() {
    _rangeController.close();
  }
}