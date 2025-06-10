import 'package:app_public_facility_report/app/user/viewmodels/user_view_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ProfilePageView extends StatefulWidget {
  const ProfilePageView({super.key});

  @override
  State<ProfilePageView> createState() => _ProfilePageViewState();
}

class _ProfilePageViewState extends State<ProfilePageView> {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserViewModel>(
      builder: (context, value, child) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              spacing: 24,
              children: [
                Column(
                  spacing: 12,
                  children: [
                    CircleAvatar(
                      radius: 50,
                      child: Icon(Icons.person, size: 64),
                    ),
                    Text(
                      value.user?.displayName ?? "Nama pengguna",
                      style: GoogleFonts.poppins(),
                    ),
                    Text(
                      value.user?.email ?? "Email",
                      style: GoogleFonts.poppins(),
                    ),
                  ],
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Provider.of<UserViewModel>(
                        context,
                        listen: false,
                      ).logout();
                      Navigator.of(context).pushReplacementNamed('/sign-in');
                    },
                    child: Text("Keluar"),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
