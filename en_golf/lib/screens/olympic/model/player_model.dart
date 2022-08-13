class PlayerResult {
  int? id;
  int? rank = 1;
  String? name;
  int? score;
  int? result = 0;

  PlayerResult({this.id, this.rank, this.name, this.score, this.result});

  factory PlayerResult.fromJson(Map<String, dynamic> json) => PlayerResult(
    id: json['id'] as int?,
    rank: json['rank'] as int?,
    name: json['name'].toString(),
    score: json['score'] as int?,
    result: json['result'] as int?,
  );

  Map<String, dynamic> toJson() =>
      <String, dynamic>{
        'id': id,
        'rank': rank,
        'name': name,
        'score': score,
        'result': result,
      };
}