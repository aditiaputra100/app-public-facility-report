import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AdminService {
  final _auth = FirebaseAuth.instance;
  final _host = kDebugMode ? "http://10.0.2.2:8000" : "";

  Future<User?> signIn(String email, String password) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    return credential.user;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Stream<User?> get authStateChange => _auth.authStateChanges();
}
