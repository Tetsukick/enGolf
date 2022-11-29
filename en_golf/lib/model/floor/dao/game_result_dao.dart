// @dart=2.12
import 'package:floor/floor.dart';

import '../entity/game_result.dart';

@dao
abstract class GameResultDao {
  @Query('SELECT * FROM GameResult')
  Future<List<GameResult>?> findAllGameResults();

  @update
  Future<void> updateGameResult(GameResult gameResult);

  @insert
  Future<void> insertGameResult(GameResult gameResult);

  @delete
  Future<void> deleteGameResult(GameResult gameResult);
}