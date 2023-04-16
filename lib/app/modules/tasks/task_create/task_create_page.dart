import 'package:flutter/material.dart';
import 'package:todo_list/app/core/notifier/todo_list_listener_notifier.dart';
import 'package:todo_list/app/core/ui/theme_extension.dart';
import 'package:todo_list/app/core/widgets/todo_list_field.dart';
import 'package:todo_list/app/modules/tasks/task_create/task_create_controller.dart';
import 'package:todo_list/app/modules/tasks/task_create/widget/calendar_button.dart';
import 'package:validatorless/validatorless.dart';

class TasksCreatePage extends StatefulWidget {
  final TaskCreateController _controller;

  const TasksCreatePage({required TaskCreateController controller, Key? key})
      : _controller = controller,
        super(key: key);

  @override
  State<TasksCreatePage> createState() => _TasksCreatePageState();
}

class _TasksCreatePageState extends State<TasksCreatePage> {
  final _descriptionEC = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    TodoListListenerNotifier(changeNotifier: widget._controller).listener(
      context: context,
      succesCallback: (notifier, listenerNotifier) {
        listenerNotifier.dispose();
        Navigator.pop(context);
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _descriptionEC.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.close),
            color: Colors.black,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          final formValid = _formKey.currentState?.validate() ?? false;
          if (formValid) {
            widget._controller.save(description: _descriptionEC.text);
          }
        },
        backgroundColor: context.primaryColor,
        label: const Text(
          'Salvar task',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.center,
                child: Text(
                  'Criar Task',
                  style: context.titleStyle.copyWith(
                    fontSize: 20,
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              TodoListField(
                label: '',
                controller: _descriptionEC,
                validator: Validatorless.required('Descrição obrigatória'),
              ),
              const SizedBox(
                height: 20,
              ),
              CalendarButton(),
            ],
          ),
        ),
      ),
    );
  }
}
