import 'dart:io';
import 'package:app_public_facility_report/app/user/viewmodels/user_view_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  String? _error;

  Future<bool> _checkInternetConnection() async {
    // final connectivityResult = await Connectivity().checkConnectivity();

    // if (connectivityResult.isEmpty) {
    //   return false;
    // }

    // ConnectivityResult.

    try {
      final result = await InternetAddress.lookup('google.com');

      if (result.isNotEmpty && result.first.rawAddress.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } on SocketException catch (_) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Future<void> _handleLocationPermission(BuildContext context) async {
    // return FutureBuilder<void>(
    //   future: _handleLocationPermission(context),
    //   builder: (context, snapshot) {
    //     if (snapshot.connectionState == ConnectionState.waiting) {
    //       return const Scaffold(
    //         body: Center(child: CircularProgressIndicator(strokeWidth: 2)),
    //       );
    //     }

    //     return StreamBuilder<User?>(
    //       stream: FirebaseAuth.instance.authStateChanges(),
    //       builder: (context, snapshot) {
    //         if (snapshot.connectionState == ConnectionState.active) {
    //           WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //             final user = snapshot.data;
    //             if (user == null) {
    //               Navigator.of(context).pushReplacementNamed('/sign-in');
    //             } else {
    //               Navigator.of(context).pushReplacementNamed('/home');
    //             }
    //           });
    //         }
    //         return Scaffold(
    //           body: Center(
    //             child: Column(
    //               mainAxisAlignment: MainAxisAlignment.center,
    //               spacing: 64,
    //               children: [
    //                 FlutterLogo(size: 100),
    //                 SizedBox(
    //                   width: 24,
    //                   height: 24,
    //                   child: CircularProgressIndicator(),
    //                 ),
    //               ],
    //             ),
    //           ),
    //         );
    //       },
    //     );
    //   },
    // );

    return FutureBuilder(
      future: _checkInternetConnection(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
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
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ],
              ),
            ),
          );
        }

        if (snapshot.hasData && !snapshot.data!) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 64,
                children: [
                  FlutterLogo(size: 100),
                  Text("Tidak dapat terhubung ke internet"),
                ],
              ),
            ),
          );
        }

        return StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            Provider.of<UserViewModel>(context).handleLocationPermission();
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
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );

    // return StreamBuilder<User?>(
    //   stream: FirebaseAuth.instance.authStateChanges(),
    //   builder: (context, snapshot) {
    //     Provider.of<UserViewModel>(context).handleLocationPermission();
    //     if (snapshot.connectionState == ConnectionState.active) {
    //       WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
    //         final user = snapshot.data;
    //         if (user == null) {
    //           Navigator.of(context).pushReplacementNamed('/sign-in');
    //         } else {
    //           final rvm = Provider.of<ReportViewModel>(context, listen: false);
    //           await rvm.getReportCurrent(user);

    //           bool isError = false;

    //           if (rvm.error != null) {
    //             isError = true;
    //             if (context.mounted) {
    //               ScaffoldMessenger.of(context).showSnackBar(
    //                 SnackBar(
    //                   content: Text(rvm.error!),
    //                   behavior: SnackBarBehavior.floating,
    //                   backgroundColor: Colors.red,
    //                 ),
    //               );
    //             }
    //           }

    //           await rvm.getReportCurrentUser(user);

    //           if (rvm.error != null) {
    //             isError = true;
    //             if (context.mounted) {
    //               ScaffoldMessenger.of(context).showSnackBar(
    //                 SnackBar(
    //                   content: Text(rvm.error!),
    //                   behavior: SnackBarBehavior.floating,
    //                   backgroundColor: Colors.red,
    //                 ),
    //               );
    //             }
    //           }

    //           if (!isError) {
    //             if (context.mounted) {
    //               Navigator.of(context).pushReplacementNamed('/home');
    //             }
    //           }
    //         }
    //       });
    //     } else if (snapshot.connectionState == ConnectionState.done) {
    //       print("done");
    //     }

    //     return Scaffold(
    //       body: Center(
    //         child: Column(
    //           mainAxisAlignment: MainAxisAlignment.center,
    //           spacing: 64,
    //           children: [
    //             FlutterLogo(size: 100),
    //             _error != null
    //                 ? Text(_error!)
    //                 : SizedBox(
    //                   width: 24,
    //                   height: 24,
    //                   child: CircularProgressIndicator(strokeWidth: 2),
    //                 ),
    //           ],
    //         ),
    //       ),
    //     );
    //   },
    // );
  }
}
