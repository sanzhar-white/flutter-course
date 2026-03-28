import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Текущий пользователь
  User? get currentUser => _auth.currentUser;

  /// ID текущего пользователя
  String? get currentUserId => _auth.currentUser?.uid;

  /// Email текущего пользователя
  String? get currentUserEmail => _auth.currentUser?.email;

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
      throw _mapError(e.code);
    }
  }

  /// Регистрация нового пользователя
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
      throw _mapError(e.code);
    }
  }

  /// Выход
  Future<void> logout() async {
    await _auth.signOut();
  }

  /// Перевод кодов ошибок Firebase Auth в понятные сообщения
  String _mapError(String code) {
    switch (code) {
      case 'user-not-found':
        return 'Пользователь с таким email не найден.';
      case 'wrong-password':
        return 'Неверный пароль.';
      case 'email-already-in-use':
        return 'Этот email уже используется.';
      case 'weak-password':
        return 'Слишком слабый пароль. Минимум 6 символов.';
      case 'invalid-email':
        return 'Некорректный email.';
      case 'too-many-requests':
        return 'Слишком много попыток. Попробуйте позже.';
      default:
        return 'Произошла ошибка авторизации ($code).';
    }
  }
}
