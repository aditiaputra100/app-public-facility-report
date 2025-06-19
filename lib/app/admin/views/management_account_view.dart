import 'package:app_public_facility_report/app/admin/views/widget/admin_tile.dart';
import 'package:flutter/material.dart';

class ManagementAccountView extends StatelessWidget {
  const ManagementAccountView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) {
        return AdminTile();
      },
    );
  }
}
