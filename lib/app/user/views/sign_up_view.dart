import 'package:app_public_facility_report/app/user/viewmodels/user_view_model.dart';
import 'package:app_public_facility_report/app/user/views/widgets/filled_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _nameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _register() async {
    if (_formKey.currentState!.validate()) {
      String email = _emailController.text;
      String password = _passwordController.text;
      String name = _nameController.text;

      final uvm = Provider.of<UserViewModel>(context, listen: false);

      await uvm.register(email, password, name);

      String? error = uvm.error;

      if (mounted) {
        if (error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(error),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );

          return;
        }

        Navigator.of(
          context,
        ).pushNamedAndRemoveUntil("/home", (route) => false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final uvm = Provider.of<UserViewModel>(context);

    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Center(
            child: Form(
              key: _formKey,
              child: Column(
                spacing: 24,
                children: [
                  // Title
                  Text("Daftar", style: Theme.of(context).textTheme.titleLarge),
                  SizedBox(height: 24),
                  Column(
                    spacing: 24,
                    children: [
                      FilledTextFormField(
                        controller: _emailController,
                        hintText: "Email",
                        prefixIcon: Icon(Icons.email),
                        inputType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Email tidak boleh kosong';
                          }

                          if (!RegExp(
                            r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$",
                          ).hasMatch(value)) {
                            return 'Email tidak valid';
                          }

                          return null;
                        },
                      ),
                      FilledTextFormField(
                        controller: _nameController,
                        hintText: "Nama",
                        prefixIcon: Icon(Icons.person),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Nama tidak boleh kosong';
                          }

                          return null;
                        },
                      ),
                      FilledTextFormField(
                        controller: _passwordController,
                        hintText: "Password",
                        obscureText: true,
                        prefixIcon: Icon(Icons.lock),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Password tidak boleh kosong';
                          }

                          if (value.length < 8) {
                            return 'Password harus lebih dari 8 karakter';
                          }

                          return null;
                        },
                      ),
                      FilledTextFormField(
                        controller: _confirmPasswordController,
                        hintText: "Konfirmasi Password",
                        obscureText: true,
                        prefixIcon: Icon(Icons.lock),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Password tidak boleh kosong';
                          }

                          if (value != _passwordController.text) {
                            return 'Konfirmasi password tidak sama';
                          }

                          return null;
                        },
                      ),
                    ],
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: uvm.isLoading ? null : _register,
                      child:
                          uvm.isLoading
                              ? CircularProgressIndicator(strokeWidth: 2)
                              : Text("Daftar"),
                    ),
                  ),
                  Text("Atau", style: TextStyle(color: Colors.grey)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {},
                        child: SvgPicture.asset(
                          'assets/images/g_icon.svg',
                          width: 48,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Sudah punya akun? ",
                        style: TextStyle(color: Colors.grey),
                      ),
                      GestureDetector(
                        onTap:
                            () => Navigator.of(context).pushNamed('/sign-in'),
                        child: Text(
                          "Masuk disini",
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ],
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
