import 'package:provider/provider.dart';
import 'package:todo_list/app/core/modules/todo_list_module.dart';
import 'package:todo_list/app/modules/tasks/task_create/task_create_controller.dart';
import 'package:todo_list/app/modules/tasks/task_create/task_create_page.dart';

class TasksModule extends TodoListModule {
  TasksModule()
      : super(
          bindings: [
            ChangeNotifierProvider(
              create: (context) => TaskCreateController(),
            )
          ],
          routers: {
            '/task/create': (context) => TasksCreatePage(
                  controller: context.read(),
                ),
          },
        );
}
