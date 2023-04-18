import 'package:todo_list/app/core/database/sqlite_connection_factory.dart';
import 'package:todo_list/app/models/task_model.dart';

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

  @override
  Future<List<TaskModel>> findByPeriod(
      {required DateTime start, required DateTime end}) async {
    final startFilter = DateTime(start.year, start.month, start.day, 0, 0, 0);
    final endFilter = DateTime(end.year, end.month, end.day, 23, 59, 59);

    final conn = await _sqliteConnectionFactory.openConnection();

    final result = await conn.rawQuery('''
      SELECT  id, description, date_time, finished
      FROM todo  
      WHERE date_time BETWEEN ? AND ? 
      ORDER BY date_time
    ''', [
      startFilter.toIso8601String(),
      endFilter.toIso8601String(),
    ]);

    return result.map((e) => TaskModel.fromMap(e)).toList();
  }

  @override
  Future<void> checkOrUncheckTask({required TaskModel task}) async {
    final conn = await _sqliteConnectionFactory.openConnection();
    final finished = task.finished ? 1 : 0;
    await conn.rawUpdate('UPDATE todo SET finished = ? WHERE id = ?', [
      finished,
      task.id,
    ]);
  }

  @override
  Future<void> deleteTasks({int? id}) async {
    final conn = await _sqliteConnectionFactory.openConnection();
    if (id != null) {
      await conn.rawDelete('DELETE FROM todo WHERE id = ?', [id]);
    } else {
      await conn.rawDelete('DELETE FROM todo');
    }
  }
}
