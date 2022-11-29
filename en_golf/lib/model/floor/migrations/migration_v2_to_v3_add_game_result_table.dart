import 'package:floor/floor.dart';

final migration2to3 = Migration(2, 3, (database) async {
  await database.execute('CREATE TABLE IF NOT EXISTS `GameResult` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT, `gameDate` TEXT, `playerResultList` TEXT)');
});