import 'package:engolf/screens/olympic/model/player_model.dart';
import 'package:floor/floor.dart';

@entity
class GameResult {
  @PrimaryKey(autoGenerate: true)
  int? id;
  String? name;
  String? gameDate;
  String? playerResultList;

  GameResult({
    this.id,
    this.name,
    this.gameDate,
    this.playerResultList,
  });
}