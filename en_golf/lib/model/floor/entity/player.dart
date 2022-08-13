import 'package:floor/floor.dart';

@entity
class Player {
  @PrimaryKey(autoGenerate: true)
  int? id;
  final String? name;

  Player({
    this.id,
    this.name,
  });
}