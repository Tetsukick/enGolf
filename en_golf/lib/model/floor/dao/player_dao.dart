// @dart=2.12
import 'package:floor/floor.dart';

import '../entity/player.dart';

@dao
abstract class PlayerDao {
  @Query('SELECT * FROM Player')
  Future<List<Player>?> findAllPlayers();

  @Query('SELECT * FROM Player WHERE name LIKE "%:name%"')
  Future<List<Player>?> findPlayers(String name);

  @Query('SELECT * FROM Player WHERE isMainUser = 1')
  Future<Player?> findMainPlayers();

  @update
  Future<void> updatePlayer(Player player);

  @Query('UPDATE Player SET isMainUser = 0')
  Future<void> updateAllPlayerIsMainOff();

  @insert
  Future<void> insertPlayer(Player player);

  @delete
  Future<void> deletePlayer(Player player);
}