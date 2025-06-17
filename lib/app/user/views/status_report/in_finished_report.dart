import 'package:app_public_facility_report/app/user/models/report_model.dart';
import 'package:app_public_facility_report/app/user/viewmodels/report_view_model.dart';
import 'package:app_public_facility_report/app/user/viewmodels/user_view_model.dart';
import 'package:app_public_facility_report/app/user/views/widget/user_card_report.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InFinishedReport extends StatefulWidget {
  const InFinishedReport({super.key});

  @override
  State<InFinishedReport> createState() => _InFinishedReportState();
}

class _InFinishedReportState extends State<InFinishedReport> {
  List<ReportModel>? _report;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        _report =
            Provider.of<ReportViewModel>(
              context,
              listen: false,
            ).reports['finished'];
      });
    });
  }

  Future<void> _getReport() async {
    final uvm = Provider.of<UserViewModel>(context, listen: false);
    final rvm = Provider.of<ReportViewModel>(context, listen: false);

    await rvm.getReportCurrentUser(uvm.user!);

    if (rvm.error != null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(rvm.error!),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      setState(() {
        _report = rvm.reports["in-review"];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final rvm = Provider.of<ReportViewModel>(context);

    return RefreshIndicator(
      onRefresh: _getReport,
      child: Center(
        child:
            rvm.isLoading
                ? CircularProgressIndicator(strokeWidth: 2)
                : _report != null
                ? ListView.builder(
                  itemCount: _report!.length,
                  itemBuilder: (context, index) {
                    return UserCardReport(
                      imagePath: _report![index].imagePath,
                      facility: _report![index].facility,
                      description: _report![index].description,
                      createdAt: _report![index].createdAt,
                    );
                  },
                )
                : Text("Belum ada laporan yang selesai"),
      ),
    );
  }
}
