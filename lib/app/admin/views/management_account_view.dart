import 'package:app_public_facility_report/app/admin/models/admin_model.dart';
import 'package:app_public_facility_report/app/admin/viewmodels/admin_view_model.dart';
import 'package:app_public_facility_report/app/admin/views/widget/admin_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ManagementAccountView extends StatefulWidget {
  const ManagementAccountView({super.key});

  @override
  State<ManagementAccountView> createState() => _ManagementAccountViewState();
}

class _ManagementAccountViewState extends State<ManagementAccountView> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final avm = Provider.of<AdminViewModel>(context, listen: false);

      await avm.getAllAdmin();

      String? error = avm.error;

      if (error != null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(error),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    });
  }

  Future<void> _onRefresh() async {
    final avm = Provider.of<AdminViewModel>(context, listen: false);

    await avm.getAllAdmin();

    String? error = avm.error;

    if (error != null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: RefreshIndicator(
        onRefresh: _onRefresh,
        child: Consumer<AdminViewModel>(
          builder: (context, value, child) {
            if (value.isLoading) {
              return Center(child: CircularProgressIndicator(strokeWidth: 2));
            }

            if (value.admins == null) {
              return Center(child: Text("Belum ada admin yang terdaftar"));
            }

            return ListView.builder(
              itemCount: value.admins!.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final AdminModel admin = value.admins![index];
                return AdminTile(name: admin.name);
              },
            );
          },
        ),
      ),
    );
  }
}
