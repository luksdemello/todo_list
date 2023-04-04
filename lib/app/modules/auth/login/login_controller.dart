import 'package:todo_list/app/core/notifier/todo_list_change_notifier.dart';
import 'package:todo_list/app/exceptions/auth_exception.dart';
import 'package:todo_list/app/services/user/user_service.dart';

class LoginController extends TodoListChangeNotifier {
  final UserService _userService;

  LoginController({
    required UserService userService,
  }) : _userService = userService;

  Future<void> login({
    required String email,
    required String password,
  }) async {
    try {
      showLoadingAndResetState();
      notifyListeners();

      final user = await _userService.login(email: email, password: password);

      if (user != null) {
        success();
      } else {
        setError('Email ou senha inválidos');
      }
    } on AuthException catch (e) {
      setError(e.message);
    } finally {
      hideLoading();
      notifyListeners();
    }
  }
}
