import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:todo_list/app/exceptions/auth_exception.dart';

import './user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final FirebaseAuth _firebaseAuth;

  UserRepositoryImpl({
    required FirebaseAuth firebaseAuth,
  }) : _firebaseAuth = firebaseAuth;

  @override
  Future<User?> register({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);

      return userCredential.user;
    } on FirebaseAuthException catch (e, s) {
      log('Error to authenticate on firebase', error: e, stackTrace: s);
      if (e.code == 'email-already-in-use') {
        final loginTypes =
            await _firebaseAuth.fetchSignInMethodsForEmail(email);
        if (loginTypes.contains('password')) {
          throw AuthException(
              message: 'Email já utilizado, por favor escolha outro email');
        } else {
          throw AuthException(
              message:
                  'Você se cadastrou pelo google, por favor utilize ele para entrar!');
        }
      } else {
        throw AuthException(message: e.message ?? 'Erro ao registrar usuário');
      }
    }
  }

  @override
  Future<User?> login({required String email, required String password}) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);

      return userCredential.user;
    } on PlatformException catch (e, s) {
      log('Error login', error: e, stackTrace: s);
      throw AuthException(message: e.message ?? 'Erro ao realizar login');
    } on FirebaseAuthException catch (e, s) {
      log('Error login', error: e, stackTrace: s);
      if (e.code == 'wrong-password') {
        throw AuthException(message: 'Email ou senha inválidos');
      }
      throw AuthException(message: e.message ?? 'Erro ao realizar login');
    }
  }

  @override
  Future<void> forgotPassword({required String email}) async {
    try {
      final loginTypes = await _firebaseAuth.fetchSignInMethodsForEmail(email);

      if (loginTypes.contains('password')) {
        await _firebaseAuth.sendPasswordResetEmail(email: email);
      } else if (loginTypes.contains('google')) {
        throw AuthException(
          message:
              'Cadastro realizado com o google, verefique a senha do seu email',
        );
      } else {
        throw AuthException(
          message: 'Email não cadastrado',
        );
      }
    } on PlatformException catch (e, s) {
      log('Error send reset password', error: e, stackTrace: s);
      throw AuthException(message: 'Erro ao resetar senha');
    }
  }

  @override
  Future<User?> signInWithGoogle() async {
    try {
      final googleSignIn = GoogleSignIn();

      final googleUser = await googleSignIn.signIn();

      if (googleUser != null) {
        final loginTypes =
            await _firebaseAuth.fetchSignInMethodsForEmail(googleUser.email);

        if (loginTypes.contains('password')) {
          throw AuthException(message: 'Email ja utilizado com email e senha');
        } else {
          final googleAuth = await googleUser.authentication;
          final firebaseCredential = GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken,
            idToken: googleAuth.idToken,
          );
          final userCredential =
              await _firebaseAuth.signInWithCredential(firebaseCredential);
          return userCredential.user;
        }
      }
      return null;
    } on FirebaseAuthException catch (e, s) {
      log('Error to login with google', error: e, stackTrace: s);

      if (e.code == 'account-exists-with-different-credential') {
        throw AuthException(
            message: 'Login inválido, email já utilizado com outro provedor');
      } else {
        throw AuthException(message: 'Erro ao realizar login com o google');
      }
    }
  }

  @override
  Future<void> logout() async {
    await GoogleSignIn().signOut();
    await _firebaseAuth.signOut();
  }

  @override
  Future<void> updateDisplayName(String name) async {
    final user = _firebaseAuth.currentUser;
    if (user != null) {
      await user.updateDisplayName(name);
      user.reload();
    }
  }
}
