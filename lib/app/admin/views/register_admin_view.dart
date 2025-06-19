import 'package:flutter/material.dart';

class RegisterAdminView extends StatefulWidget {
  const RegisterAdminView({super.key});

  @override
  State<RegisterAdminView> createState() => _RegisterAdminViewState();
}

class _RegisterAdminViewState extends State<RegisterAdminView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(child: Text("Register admin")),
    );
  }
}
