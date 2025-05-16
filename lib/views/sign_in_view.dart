import 'package:app_public_facility_report/viewmodels/user_view_model.dart';
import 'package:app_public_facility_report/views/widgets/filled_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class SignInView extends StatefulWidget {
  const SignInView({super.key});

  @override
  State<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isPasswordVisible = false;

  void _login() {
    String email = _emailController.text;
    String password = _passwordController.text;

    if (_formKey.currentState!.validate()) {
      Provider.of<UserViewModel>(context, listen: false).login(email, password);
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
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Center(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 24,
                children: [
                  // Title
                  Text("Masuk", style: Theme.of(context).textTheme.titleLarge),
                  SizedBox(height: 24),
                  Column(
                    spacing: 24,
                    children: [
                      FilledTextFormField(
                        prefixIcon: Icon(Icons.email),
                        controller: _emailController,
                        hintText: "Email",
                        inputType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Email tidak boleh kosong';
                          }

                          return value;
                        },
                      ),
                      FilledTextFormField(
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
                        controller: _passwordController,
                        hintText: "Password",
                        obscureText: !_isPasswordVisible,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Password tidak boleh kosong';
                          }

                          return value;
                        },
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "Lupa password?",
                        style: TextStyle(color: Colors.blue),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _login,
                      child: Text("Masuk"),
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
                        "Tidak punya akun? ",
                        style: TextStyle(color: Colors.grey),
                      ),
                      GestureDetector(
                        onTap:
                            () => Navigator.of(context).pushNamed('/sign-up'),
                        child: Text(
                          "Daftar disini",
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
