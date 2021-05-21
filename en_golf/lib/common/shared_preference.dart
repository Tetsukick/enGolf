import 'dart:convert';

import 'package:engolf/screens/olympic/model/player_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceManager {
  String playersId = 'players';
  
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
}