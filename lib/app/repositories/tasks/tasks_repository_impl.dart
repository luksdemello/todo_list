import 'package:todo_list/app/core/database/sqlite_connection_factory.dart';

import './tasks_repository.dart';

class TasksRepositoryImpl implements TasksRepository {
  final SqliteConnectionFactory _sqliteConnectionFactory;

  TasksRepositoryImpl(
      {required SqliteConnectionFactory sqliteConnectionFactory})
      : _sqliteConnectionFactory = sqliteConnectionFactory;

  @override
  Future<void> save({
    required DateTime date,
    required String description,
  }) async {
    final conn = await _sqliteConnectionFactory.openConnection();
    await conn.insert('todo', {
      'id': null,
      'description': description,
      'date_time': date.toIso8601String(),
      'finished': 0,
    });
  }
}
