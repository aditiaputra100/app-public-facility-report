import 'package:app_public_facility_report/app/user/auth_wrapper.dart';
import 'package:app_public_facility_report/app/user/firebase_options.dart';
import 'package:app_public_facility_report/app/user/theme.dart';
import 'package:app_public_facility_report/app/user/viewmodels/user_view_model.dart';
import 'package:app_public_facility_report/app/user/views/forget_password_view.dart';
import 'package:app_public_facility_report/app/user/views/home/home_view.dart';
import 'package:app_public_facility_report/app/user/views/sign_in_view.dart';
import 'package:app_public_facility_report/app/user/views/sign_up_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (context) => UserViewModel())],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: theme,
      routes: {
        '/home': (context) => HomeView(),
        '/sign-up': (context) => SignUpView(),
        '/sign-in': (context) => SignInView(),
        '/forget-pass': (context) => ForgetPasswordView(),
      },
      home: AuthWrapper(),
    );
  }
}
