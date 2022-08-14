// @dart=2.12
import 'dart:async';
import 'package:engolf/model/floor/dao/player_dao.dart';
import 'package:floor/floor.dart';

import '../entity/player.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

part 'database.g.dart';

@Database(version: 2, entities: [Player])
abstract class AppDatabase extends FloorDatabase {
  PlayerDao get playerDao;
}