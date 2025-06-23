import 'package:app_public_facility_report/app/admin/models/report_model.dart';
import 'package:app_public_facility_report/app/admin/viewmodels/admin_view_model.dart';
import 'package:app_public_facility_report/app/admin/viewmodels/report_view_model.dart';
import 'package:app_public_facility_report/app/admin/views/report_admin_view.dart';
import 'package:app_public_facility_report/app/widgets/card_report.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InFinishedView extends StatefulWidget {
  const InFinishedView({super.key});

  @override
  State<InFinishedView> createState() => _InFinishedViewState();
}

class _InFinishedViewState extends State<InFinishedView> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final avm = Provider.of<AdminViewModel>(context, listen: false);
      final rvm = Provider.of<ReportViewModel>(context, listen: false);

      await rvm.getCurrentReport(avm.user!, status: "finished");
    });
  }

  Future<void> _getReport() async {
    final avm = Provider.of<AdminViewModel>(context, listen: false);
    final rvm = Provider.of<ReportViewModel>(context, listen: false);

    if (avm.user != null) {
      rvm.getCurrentReport(avm.user!, status: "finished");
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _getReport,
      child: Consumer<ReportViewModel>(
        builder: (context, value, child) {
          return value.isLoading
              ? Center(child: CircularProgressIndicator(strokeWidth: 2))
              : value.reportFinished == null
              ? Center(child: Text("Tidak ada laporan"))
              : value.reportFinished!["data"].length == 0
              ? Center(child: Text("Tidak ada laporan"))
              : ListView.separated(
                itemBuilder: (context, index) {
                  final data = value.reportFinished!["data"];

                  final report = data[index] as ReportModel;

                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder:
                              (context) => ReportAdminView(
                                id: report.id!,
                                name: report.user!["full_name"],
                                facility: report.facility,
                                description: report.description,
                                location: report.location,
                                status: report.status,
                                imagePath: report.imagePath,
                              ),
                        ),
                      );
                    },
                    child: CardReport(
                      name: report.user!["full_name"],
                      description: report.description,
                      createdAt: report.createdAt,
                      imagePath: report.imagePath,
                    ),
                  );
                },
                separatorBuilder: (context, index) => SizedBox(height: 6),
                itemCount: value.reportFinished!["length_finished"],
              );
        },
      ),
    );
  }
}
