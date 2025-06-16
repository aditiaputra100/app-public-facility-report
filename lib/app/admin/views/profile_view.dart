import 'package:app_public_facility_report/app/admin/viewmodels/admin_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  void _logout() async {
    final uvm = Provider.of<AdminViewModel>(context, listen: false);

    await uvm.logout();

    if (uvm.user == null) {
      if (mounted) {
        Navigator.of(context).pushReplacementNamed("/sign-in");
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Gagal untuk keluar, silahkan coba lagi."),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final uvm = Provider.of<AdminViewModel>(context, listen: false);

    return Padding(
      padding: EdgeInsetsGeometry.all(16),
      child: Center(
        child: ElevatedButton(
          onPressed: _logout,
          child:
              uvm.isLoading
                  ? CircularProgressIndicator(strokeWidth: 2)
                  : Text("Keluar"),
        ),
      ),
    );
  }
}
