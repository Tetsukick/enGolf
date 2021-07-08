import 'dart:convert';

import 'package:engolf/common/utils.dart';
import 'package:engolf/screens/olympic/model/player_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceManager {
  String playersId = 'players';
  String gameNameId = 'gameNameId';
  String gameDateId = 'gameDateId';
  
  Future<List<Player>> getPlayers() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<dynamic> dynamicList = json.decode(prefs.getString(playersId)) as List<dynamic>;
    return List<Player>.from(dynamicList.map((x) => Player.fromJson(x)));
  }

  Future<void> savePlayers(List<Player> players) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<Map<String, dynamic>> dynamicList = players.map((e) => e.toJson()).toList();
    prefs.setString(playersId, json.encode(dynamicList));
  }

  Future<String> getGameName() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(gameNameId);
  }

  Future<void> setGameName(String gameName) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(gameNameId, gameName);
  }

  Future<DateTime> getGameDate() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return DateTime.parse(prefs.getString(gameDateId));
  }

  Future<void> setGameDate(DateTime gameDate) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(gameDateId, dateTimeToString(gameDate));
  }
}