import 'package:flutter/material.dart';
import 'package:todo_list/app/core/database/sqlite_connection_factory.dart';

class SqliteAdmConnection with WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final connection = SqliteConnectionFactory();

    switch (state) {
      case AppLifecycleState.resumed:
        break;
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
        connection.closeConnection();
        break;
    }

    super.didChangeAppLifecycleState(state);
  }
}
