import 'dart:convert';

import 'package:engolf/common/utils.dart';
import 'package:engolf/screens/olympic/model/player_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceManager {
  String playersId = 'players';
  String gameNameId = 'gameNameId';
  String gameDateId = 'gameDateId';
  
  Future<List<Player>> getPlayers() async {
    final prefs = await SharedPreferences.getInstance();
    final dynamicList = json.decode(prefs.getString(playersId))
      as List<dynamic>;
    return List<Player>.from(dynamicList.map<dynamic>((dynamic x) =>
        Player.fromJson(x)));
  }

  Future<void> savePlayers(List<Player> players) async {
    final prefs = await SharedPreferences.getInstance();
    final dynamicList = players.map((e) => e.toJson()).toList();
    await prefs.setString(playersId, json.encode(dynamicList));
  }

  Future<String> getGameName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(gameNameId);
  }

  Future<void> setGameName(String gameName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(gameNameId, gameName);
  }

  Future<DateTime> getGameDate() async {
    final prefs = await SharedPreferences.getInstance();
    return DateTime.parse(prefs.getString(gameDateId));
  }

  Future<void> setGameDate(DateTime gameDate) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(gameDateId, dateTimeToString(gameDate));
  }
}