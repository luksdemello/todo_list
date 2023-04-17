import 'package:todo_list/app/models/task_model.dart';
import 'package:todo_list/app/models/week_task_model.dart';

abstract class TasksService {
  Future<void> save({required DateTime date, required String description});
  Future<List<TaskModel>> getTotay();
  Future<List<TaskModel>> getTomorrow();
  Future<WeekTaskModel> getWeek();
  Future<void> checkOrUncheckTask({required TaskModel task});
}
