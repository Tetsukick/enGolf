// @dart=2.12
import 'dart:async';
import 'package:engolf/model/floor/dao/game_result_dao.dart';
import 'package:engolf/model/floor/dao/player_dao.dart';
import 'package:engolf/model/floor/entity/game_result.dart';
import 'package:floor/floor.dart';

import '../entity/player.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

part 'database.g.dart';

@Database(version: 3, entities: [Player, GameResult])
abstract class AppDatabase extends FloorDatabase {
  PlayerDao get playerDao;
  GameResultDao get gameResultDao;
}