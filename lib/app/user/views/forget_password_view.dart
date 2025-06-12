import 'package:app_public_facility_report/app/user/viewmodels/user_view_model.dart';
import 'package:app_public_facility_report/app/widgets/filled_text_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ForgetPasswordView extends StatefulWidget {
  const ForgetPasswordView({super.key});

  @override
  State<ForgetPasswordView> createState() => _ForgetPasswordViewState();
}

class _ForgetPasswordViewState extends State<ForgetPasswordView> {
  final TextEditingController _emailController = TextEditingController();

  void _confirmEmail() async {
    String email = _emailController.text.trim();
    final UserViewModel userViewModel = Provider.of<UserViewModel>(
      context,
      listen: false,
    );

    await userViewModel.forgetPassword(email);

    if (mounted) {
      if (userViewModel.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(userViewModel.error!),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Email telah terkirim"),
            backgroundColor: Colors.blue,
            behavior: SnackBarBehavior.floating,
          ),
        );
        Navigator.of(context).pushReplacementNamed('/sign-in');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final UserViewModel userViewModel = Provider.of<UserViewModel>(context);

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.all(24),
        child: Center(
          child: Column(
            spacing: 24,
            children: [
              Column(
                spacing: 12,
                children: [
                  // Title
                  Text(
                    "Lupa password?",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  // Description
                  Text(
                    "Tulis email anda agar mendapatkan kode untuk mengatur ulang password",
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              FilledTextField(
                controller: _emailController,
                hintText: "Email",
                inputType: TextInputType.emailAddress,
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _confirmEmail,
                  child:
                      userViewModel.isLoading
                          ? SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                          : Text('Konfirmasi email'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
