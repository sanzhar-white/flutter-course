import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Текущий пользователь
  User? get currentUser => _auth.currentUser;

  /// Поток изменений состояния авторизации
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Вход по email и паролю
  Future<UserCredential> login({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      return credential;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  /// Регистрация по email и паролю
  Future<UserCredential> register({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      return credential;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  /// Выход из аккаунта
  Future<void> logout() async {
    await _auth.signOut();
  }

  /// Обработка ошибок Firebase Auth
  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'Пользователь с таким email не найден.';
      case 'wrong-password':
        return 'Неверный пароль.';
      case 'email-already-in-use':
        return 'Этот email уже зарегистрирован.';
      case 'weak-password':
        return 'Пароль слишком слабый. Используйте минимум 6 символов.';
      case 'invalid-email':
        return 'Некорректный формат email.';
      case 'too-many-requests':
        return 'Слишком много попыток. Попробуйте позже.';
      default:
        return 'Произошла ошибка: ${e.message}';
    }
  }
}
