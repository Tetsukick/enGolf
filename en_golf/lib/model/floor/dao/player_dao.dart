// @dart=2.12
import 'package:floor/floor.dart';

import '../entity/player.dart';

@dao
abstract class PlayerDao {
  @Query('SELECT * FROM Player')
  Future<List<Player>?> findAllPlayers();

  @Query('SELECT * FROM Player WHERE name LIKE "%:name%"')
  Future<List<Player>?> findPlayers(String name);

  @update
  Future<void> updatePlayer(Player player);

  @insert
  Future<void> insertPlayer(Player player);

  @delete
  Future<void> deletePlayer(Player player);
}