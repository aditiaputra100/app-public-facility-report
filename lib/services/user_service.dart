import 'package:firebase_auth/firebase_auth.dart';

class UserService {
  final _auth = FirebaseAuth.instance;

  Future<User?> create(String email, String password, String name) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    await credential.user?.updateDisplayName(name);
    await credential.user?.reload();

    return credential.user;
  }

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
