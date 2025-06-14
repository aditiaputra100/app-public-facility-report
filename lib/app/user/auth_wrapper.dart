import 'package:app_public_facility_report/app/user/viewmodels/user_view_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  // Future<void> _handleLocationPermission(BuildContext context) async {
  //   bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //   if (context.mounted) {
  //     if (!serviceEnabled) {
  //       _showSnackBar(context, "Lokasi tidak aktif, harap aktifkan lokasi!");
  //       return;
  //     }
  //   }
  //   LocationPermission permission = await Geolocator.checkPermission();

  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();

  //     if (permission == LocationPermission.denied) {
  //       if (context.mounted) {
  //         _showSnackBar(context, "Ijin lokasi ditolak");
  //       }
  //       return;
  //     }
  //   } else if (permission == LocationPermission.deniedForever) {
  //     if (context.mounted) {
  //       _showSnackBar(context, "Ijin lokasi ditolak, harap beri ijin lokasi");
  //     }
  //     return;
  //   }
  // }

  // void _showSnackBar(BuildContext context, String message) {
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
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
