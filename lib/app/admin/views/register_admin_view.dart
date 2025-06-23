import 'package:app_public_facility_report/app/admin/viewmodels/admin_view_model.dart';
import 'package:app_public_facility_report/app/widgets/filled_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterAdminView extends StatefulWidget {
  const RegisterAdminView({super.key});

  @override
  State<RegisterAdminView> createState() => _RegisterAdminViewState();
}

class _RegisterAdminViewState extends State<RegisterAdminView> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

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

      final avm = Provider.of<AdminViewModel>(context, listen: false);

      await avm.register(email, password, name);

      String? error = avm.error;

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
        } else {
          _emailController.clear();
          _nameController.clear();
          _passwordController.clear();
          _confirmPasswordController.clear();

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Berhasil mendaftar!"),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Daftar admin")),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsetsGeometry.symmetric(horizontal: 16, vertical: 32),
            child: Column(
              spacing: 24,
              children: [
                // Email field
                Column(
                  spacing: 6,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Email"),
                    FilledTextFormField(
                      controller: _emailController,
                      hintText: "Alamat email",
                      prefixIcon: Icon(Icons.email),
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
                  ],
                ),
                // Full name field
                Column(
                  spacing: 6,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Nama lengkap"),
                    FilledTextFormField(
                      controller: _nameController,
                      hintText: "Nama lengkap",
                      prefixIcon: Icon(Icons.person),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Nama tidak boleh kosong';
                        }

                        return null;
                      },
                    ),
                  ],
                ),

                // Password field
                Column(
                  spacing: 6,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Password"),
                    FilledTextFormField(
                      controller: _passwordController,
                      hintText: "Password",
                      prefixIcon: Icon(Icons.lock),
                      obscureText: true,
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
                  ],
                ),

                // Password confirm field
                Column(
                  spacing: 6,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Password"),
                    FilledTextFormField(
                      controller: _confirmPasswordController,
                      hintText: "Konfirmasi password",
                      prefixIcon: Icon(Icons.lock),
                      obscureText: true,
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

                Consumer<AdminViewModel>(
                  builder: (context, value, child) {
                    return SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: value.isLoading ? null : _register,
                        child:
                            value.isLoading
                                ? CircularProgressIndicator(strokeWidth: 2)
                                : Text("Daftar"),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
