import 'package:flutter/material.dart';

class AdminTile extends StatelessWidget {
  final String name;

  const AdminTile({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return ListTile(title: Text(name), subtitle: Text("Kabupaten Jember"));
  }
}
