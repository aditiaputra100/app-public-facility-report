import 'package:app_public_facility_report/app/user/models/report_model.dart';
import 'package:app_public_facility_report/app/user/viewmodels/report_view_model.dart';
import 'package:app_public_facility_report/app/user/viewmodels/user_view_model.dart';
import 'package:app_public_facility_report/app/user/views/selected_report_view.dart';
import 'package:app_public_facility_report/app/user/views/widget/user_card_report.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InProgressReport extends StatefulWidget {
  const InProgressReport({super.key});

  @override
  State<InProgressReport> createState() => _InProgressReportState();
}

class _InProgressReportState extends State<InProgressReport> {
  List<ReportModel>? _report;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {
      _report =
          Provider.of<ReportViewModel>(
            context,
            listen: false,
          ).reportsUser["data"]['in-progress'];
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
        _report = rvm.reportsUser["data"]["in-progress"];
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
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder:
                                (context) => SelectedReportView(
                                  facility: _report![index].facility,
                                  description: _report![index].description,
                                  location: _report![index].location,
                                  status: "Diproses",
                                  imagePath: _report![index].imagePath,
                                ),
                          ),
                        );
                      },
                      child: UserCardReport(
                        imagePath: _report![index].imagePath,
                        facility: _report![index].facility,
                        description: _report![index].description,
                        location: _report![index].location,
                        createdAt: _report![index].createdAt,
                      ),
                    );
                  },
                )
                : Text("Belum ada laporan yang proses"),
      ),
    );
  }
}
