import 'package:sqflite/sqflite.dart';
import 'package:todo_list/app/core/database/migrations/migration.dart';

class MigrationV1 implements Migration {
  @override
  void create(Batch batch) {
    batch.execute('''
    create table todo(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      description VARCHAR(250) NOT NULL,
      date_time DATETIME,
      finished INTEGER
    );
    ''');
  }

  @override
  void update(Batch batch) {}
}
