import 'package:todo_list/app/core/notifier/todo_list_change_notifier.dart';
import 'package:todo_list/app/models/task_filter_enum.dart';
import 'package:todo_list/app/models/task_model.dart';
import 'package:todo_list/app/models/total_taks_model.dart';
import 'package:todo_list/app/models/week_task_model.dart';
import 'package:todo_list/app/services/tasks/tasks_service.dart';

class HomeController extends TodoListChangeNotifier {
  final TasksService _tasksService;
  TaskFilterEnum filterSelected = TaskFilterEnum.today;
  TotalTaksModel? todayTotalTasks;
  TotalTaksModel? tomorrowTotalTasks;
  TotalTaksModel? weekTotalTasks;
  List<TaskModel> allTasks = [];
  List<TaskModel> filteredTasks = [];

  HomeController({
    required TasksService tasksService,
  }) : _tasksService = tasksService;

  Future<void> loadTotalTasks() async {
    final allTasks = await Future.wait([
      _tasksService.getTotay(),
      _tasksService.getTomorrow(),
      _tasksService.getWeek(),
    ]);

    final todayTasks = allTasks[0] as List<TaskModel>;
    final tomorrowTasks = allTasks[1] as List<TaskModel>;
    final weekTasks = allTasks[2] as WeekTaskModel;

    todayTotalTasks = TotalTaksModel(
      totalTasks: todayTasks.length,
      totalTasksFinished: todayTasks.where((task) => task.finished).length,
    );

    tomorrowTotalTasks = TotalTaksModel(
      totalTasks: tomorrowTasks.length,
      totalTasksFinished: tomorrowTasks.where((task) => task.finished).length,
    );

    weekTotalTasks = TotalTaksModel(
      totalTasks: weekTasks.taskModelList.length,
      totalTasksFinished:
          weekTasks.taskModelList.where((task) => task.finished).length,
    );

    notifyListeners();
  }

  Future<void> findTasks({required TaskFilterEnum filter}) async {
    filterSelected = filter;
    showLoading();
    notifyListeners();
    List<TaskModel> tasks;

    switch (filter) {
      case TaskFilterEnum.today:
        tasks = await _tasksService.getTotay();
        break;
      case TaskFilterEnum.tomorrow:
        tasks = await _tasksService.getTomorrow();

        break;
      case TaskFilterEnum.week:
        final weekModel = await _tasksService.getWeek();
        tasks = weekModel.taskModelList;
        break;
    }

    filteredTasks = tasks;
    allTasks = tasks;

    hideLoading();
    notifyListeners();
  }

  Future<void> refreshPage() async {
    await findTasks(filter: filterSelected);
    await loadTotalTasks();
    notifyListeners();
  }
}
