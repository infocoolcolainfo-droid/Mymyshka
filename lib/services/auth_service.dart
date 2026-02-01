import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/user_model.dart';
import 'firestore_service.dart';

// AuthService: обёртка над Firebase Auth
class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Stream текущего пользователя
  Stream<User?> get userChanges => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  // Регистрация по email/password
  Future<AppUser> signUp(String email, String password) async {
    final cred = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    final user = cred.user!;
    // Создаём запись в Firestore для поиска и метаданных
    final appUser = AppUser(uid: user.uid, email: user.email ?? '', userId: user.uid);
    await FirestoreService().createUser(appUser);
    notifyListeners();
    return appUser;
  }

  // Вход
  Future<User?> signIn(String email, String password) async {
    final cred = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    notifyListeners();
    return cred.user;
  }

  Future<void> signOut() async {
    await _auth.signOut();
    notifyListeners();
  }
}
