import 'package:todo_list/app/models/task_model.dart';

abstract class TasksRepository {
  Future<void> save({required DateTime date, required String description});
  Future<List<TaskModel>> findByPeriod({
    required DateTime start,
    required DateTime end,
  });
}
