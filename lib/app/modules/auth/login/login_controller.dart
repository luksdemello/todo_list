import 'package:todo_list/app/core/notifier/todo_list_change_notifier.dart';
import 'package:todo_list/app/exceptions/auth_exception.dart';
import 'package:todo_list/app/services/user/user_service.dart';

class LoginController extends TodoListChangeNotifier {
  final UserService _userService;
  String? infoMessage;

  LoginController({
    required UserService userService,
  }) : _userService = userService;

  bool get hasInfo => infoMessage != null;

  Future<void> login({
    required String email,
    required String password,
  }) async {
    try {
      showLoadingAndResetState();
      infoMessage = null;
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

  Future<void> googleLogin() async {
    try {
      showLoadingAndResetState();
      infoMessage = null;
      notifyListeners();

      final user = await _userService.signInWithGoogle();

      if (user != null) {
        success();
      } else {
        setError('Erro ao realizar login com o google');
        await _userService.googleLogout();
      }
    } on AuthException catch (e) {
      setError(e.message);
      await _userService.googleLogout();
    } finally {
      hideLoading();
      notifyListeners();
    }
  }

  Future<void> forgotPassword({required String email}) async {
    try {
      showLoadingAndResetState();
      infoMessage = null;
      notifyListeners();

      await _userService.forgotPassword(email: email);
      infoMessage = 'Reset de senha enviado para seu email';
    } on AuthException catch (e) {
      setError(e.message);
    } finally {
      hideLoading();
      notifyListeners();
    }
  }
}
