import 'package:firebase_auth/firebase_auth.dart';

abstract class UserService {
  Future<User?> register({
    required String email,
    required String password,
  });

  Future<User?> login({
    required String email,
    required String password,
  });

  Future<void> forgotPassword({
    required String email,
  });

  Future<User?> signInWithGoogle();

  Future<void> logout();
  Future<void> updateDisplayName(String name);
}
