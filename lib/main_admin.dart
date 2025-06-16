import 'package:app_public_facility_report/app/admin/auth_wrapper.dart';
import 'package:app_public_facility_report/app/admin/viewmodels/admin_view_model.dart';
import 'package:app_public_facility_report/app/admin/views/main_view.dart';
import 'package:app_public_facility_report/app/admin/views/sign_in_view.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'firebase/firebase_options_admin.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AdminViewModel()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Public Facility Report Admin",
      routes: {
        "/sign-in": (context) => const SignInView(),
        "/home": (context) => const MainView(),
      },
      home: const AuthWrapper(),
    );
  }
}
