import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:todo_list/app/core/notifier/todo_list_change_notifier.dart';
import 'package:todo_list/app/core/ui/messages.dart';

class TodoListListenerNotifier {
  final TodoListChangeNotifier changeNotifier;

  TodoListListenerNotifier({
    required this.changeNotifier,
  });

  void listener({
    required BuildContext context,
    required SuccesVoidCallback succesCallback,
    ErrorVoidCallback? errorCallback,
  }) {
    changeNotifier.addListener(() {
      if (changeNotifier.loading) {
        Loader.show(context);
      } else {
        Loader.hide();
      }

      if (changeNotifier.hasError) {
        if (errorCallback != null) {
          errorCallback(changeNotifier, this);
        }
        Messages.of(context).showError(changeNotifier.error ?? 'Erro interno');
      } else if (changeNotifier.isSuccess) {
        succesCallback(changeNotifier, this);
      }
    });
  }

  void dispose() {
    changeNotifier.removeListener(() {});
  }
}

typedef SuccesVoidCallback = void Function(
    TodoListChangeNotifier notifier, TodoListListenerNotifier listenerNotifier);

typedef ErrorVoidCallback = void Function(
    TodoListChangeNotifier notifier, TodoListListenerNotifier listenerNotifier);
