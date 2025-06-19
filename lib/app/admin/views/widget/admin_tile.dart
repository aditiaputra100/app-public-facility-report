import 'package:flutter/material.dart';

class AdminTile extends StatelessWidget {
  const AdminTile({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text("Name admin"),
      subtitle: Text("Kabupaten Jember"),
      trailing: Text("Last online"),
    );
  }
}
