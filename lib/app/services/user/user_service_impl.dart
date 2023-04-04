import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo_list/app/repositories/user/user_repository.dart';

import './user_service.dart';

class UserServiceImpl implements UserService {
  final UserRepository _userRepository;

  UserServiceImpl({
    required UserRepository userRepository,
  }) : _userRepository = userRepository;

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
  Future<void> googleLogout() => _userRepository.googleLogout();
}
