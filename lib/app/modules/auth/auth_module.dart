import 'package:provider/provider.dart';
import 'package:todo_list/app/core/modules/todo_list_module.dart';
import 'package:todo_list/app/modules/auth/login/login_controller.dart';
import 'package:todo_list/app/modules/auth/login/login_page.dart';

class AuthModule extends TodoListModule {
  AuthModule()
      : super(
          routers: {
            '/login': (context) => const LoginPage(),
          },
          bindings: [
            ChangeNotifierProvider(create: (_) => LoginController()),
          ],
        );
}
