import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            final user = snapshot.data;
            if (user == null) {
              Navigator.of(context).pushReplacementNamed('/sign-in');
            } else {
              Navigator.of(context).pushReplacementNamed('/home');
            }
          });
        }
        return Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 64,
              children: [
                FlutterLogo(size: 100),
                SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
