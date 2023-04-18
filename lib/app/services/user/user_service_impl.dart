import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo_list/app/repositories/tasks/tasks_repository.dart';
import 'package:todo_list/app/repositories/user/user_repository.dart';

import './user_service.dart';

class UserServiceImpl implements UserService {
  final UserRepository _userRepository;
  final TasksRepository _tasksRepository;

  UserServiceImpl(
      {required UserRepository userRepository,
      required TasksRepository tasksRepository})
      : _userRepository = userRepository,
        _tasksRepository = tasksRepository;

  @override
  Future<User?> register({required String email, required String password}) =>
      _userRepository.register(
        email: email,
        password: password,
      );

  @override
  Future<User?> login({required String email, required String password}) =>
      _userRepository.login(
        email: email,
        password: password,
      );

  @override
  Future<void> forgotPassword({required String email}) =>
      _userRepository.forgotPassword(
        email: email,
      );

  @override
  Future<User?> signInWithGoogle() => _userRepository.signInWithGoogle();

  @override
  Future<void> logout() async {
    await _tasksRepository.deleteTasks();
    await _userRepository.logout();
  }

  @override
  Future<void> updateDisplayName(String name) =>
      _userRepository.updateDisplayName(name);
}
