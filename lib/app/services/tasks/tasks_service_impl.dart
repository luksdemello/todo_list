import 'package:todo_list/app/repositories/tasks/tasks_repository.dart';

import './tasks_service.dart';

class TasksServiceImpl implements TasksService {
  final TasksRepository _repository;

  TasksServiceImpl({required TasksRepository repository})
      : _repository = repository;

  @override
  Future<void> save({required DateTime date, required String description}) =>
      _repository.save(
        date: date,
        description: description,
      );
}
