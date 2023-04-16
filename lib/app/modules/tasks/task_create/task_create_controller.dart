import 'dart:developer';

import 'package:todo_list/app/core/notifier/todo_list_change_notifier.dart';
import 'package:todo_list/app/services/tasks/tasks_service.dart';

class TaskCreateController extends TodoListChangeNotifier {
  final TasksService _tasksService;
  DateTime? _selectedDate;

  TaskCreateController({
    required TasksService tasksService,
  }) : _tasksService = tasksService;

  set selectedDate(DateTime? selectedDate) {
    resetState();
    _selectedDate = selectedDate;
    notifyListeners();
  }

  DateTime? get selectedDate => _selectedDate;

  Future<void> save({
    required String description,
  }) async {
    try {
      showLoadingAndResetState();
      notifyListeners();

      if (_selectedDate != null) {
        await _tasksService.save(
          date: _selectedDate!,
          description: description,
        );
        success();
      } else {
        setError('Data da task não selecionada');
      }
    } catch (e, s) {
      log('Erro ao casdastrar task', error: e, stackTrace: s);
      setError('Erro ao cadastrar task');
    } finally {
      hideLoading();
      notifyListeners();
    }
  }
}
