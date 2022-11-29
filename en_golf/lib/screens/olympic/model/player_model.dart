class PlayerResult {
  int? id;
  int? rank = 1;
  int? playerID;
  String? name;
  int score = 0;
  int result = 0;

  PlayerResult({this.id, this.rank, this.playerID, this.name, this.score = 0, this.result = 0});

  factory PlayerResult.fromJson(Map<String, dynamic> json) => PlayerResult(
    id: json['id'] as int?,
    rank: json['rank'] as int?,
    playerID: json['player_id'] as int?,
    name: json['name'].toString(),
    score: (json['score'] ?? 0) as int,
    result: (json['result'] ?? 0) as int,
  );

  Map<String, dynamic> toJson() =>
      <String, dynamic>{
        'id': id,
        'rank': rank,
        'player_id': playerID,
        'name': name,
        'score': score,
        'result': result,
      };
}