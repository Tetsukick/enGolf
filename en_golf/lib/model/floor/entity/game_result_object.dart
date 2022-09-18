import 'package:engolf/common/utils.dart';
import 'package:engolf/model/floor/entity/game_result.dart';
import 'package:engolf/screens/olympic/model/player_model.dart';

class GameResultObject {
  int? id;
  String? name;
  DateTime? gameDate;
  List<PlayerResult>? playerResultList;

  GameResultObject({
    this.id,
    this.name,
    this.gameDate,
    this.playerResultList,
  });

  GameResultObject fromGameResult(GameResult gameResult) {
    return GameResultObject(
      id: gameResult.id,
      name: gameResult.name,
      gameDate: stringToDatetime(gameResult.gameDate!),
      playerResultList: playerResultListFromJson(gameResult.playerResultList!)
    );
  }

  GameResult toGameResult() {
    return GameResult(
      id: id,
      name: name,
      gameDate: dateTimeToString(gameDate ?? DateTime.now()),
      playerResultList: playerResultListToJson(playerResultList!)
    );
  }
}