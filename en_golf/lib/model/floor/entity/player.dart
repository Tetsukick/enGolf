import 'package:floor/floor.dart';

@entity
class Player {
  @PrimaryKey(autoGenerate: true)
  int? id;
  final String? name;
  final bool isMainUser;

  Player({
    this.id,
    this.name,
    this.isMainUser = false,
  });
}