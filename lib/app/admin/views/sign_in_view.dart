import 'package:app_public_facility_report/app/admin/viewmodels/admin_view_model.dart';
import 'package:app_public_facility_report/app/widgets/filled_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignInView extends StatefulWidget {
  const SignInView({super.key});

  @override
  State<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isPasswordVisible = false;

  void _login() async {
    String email = _emailController.text;
    String password = _passwordController.text;

    if (_formKey.currentState!.validate()) {
      final AdminViewModel adminViewModel = Provider.of<AdminViewModel>(
        context,
        listen: false,
      );

      await adminViewModel.login(email, password);

      if (mounted) {
        if (adminViewModel.error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(adminViewModel.error!),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
        } else {
          Navigator.of(
            context,
          ).pushNamedAndRemoveUntil("/home", (route) => true);
        }
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AdminViewModel adminViewModel = Provider.of<AdminViewModel>(context);

    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Center(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                spacing: 24,
                children: [
                  Text("Masuk Admin"),
                  Column(
                    spacing: 24,
                    children: [
                      FilledTextFormField(
                        controller: _emailController,
                        hintText: "Email",
                        prefixIcon: Icon(Icons.email),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Email tidak boleh kosong';
                          }

                          return null;
                        },
                      ),
                      FilledTextFormField(
                        controller: _passwordController,
                        hintText: "Password",
                        prefixIcon: Icon(Icons.lock),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                        ),
                        obscureText: !_isPasswordVisible,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Password tidak boleh kosong';
                          }

                          return null;
                        },
                      ),
                    ],
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _login,
                      child:
                          adminViewModel.isLoading
                              ? CircularProgressIndicator(strokeWidth: 2)
                              : Text("Masuk"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
