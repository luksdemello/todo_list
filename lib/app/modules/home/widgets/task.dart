import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_list/app/models/task_model.dart';

class Task extends StatelessWidget {
  final TaskModel taskModel;
  final dateFormat = DateFormat('dd/MM/y');
  Task({Key? key, required this.taskModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
          ),
        ],
      ),
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: IntrinsicHeight(
        child: ListTile(
          contentPadding: const EdgeInsets.all(0),
          leading: Checkbox(
            onChanged: (value) {},
            value: taskModel.finished,
          ),
          title: Text(
            taskModel.description,
            style: TextStyle(
              decoration:
                  taskModel.finished ? TextDecoration.lineThrough : null,
            ),
          ),
          subtitle: Text(
            dateFormat.format(taskModel.dateTime),
            style: TextStyle(
              decoration:
                  taskModel.finished ? TextDecoration.lineThrough : null,
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(width: 1),
          ),
        ),
      ),
    );
  }
}
