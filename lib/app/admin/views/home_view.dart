import 'package:app_public_facility_report/app/admin/models/report_model.dart';
import 'package:app_public_facility_report/app/admin/viewmodels/admin_view_model.dart';
import 'package:app_public_facility_report/app/admin/viewmodels/report_view_model.dart';
import 'package:app_public_facility_report/app/admin/views/report_admin_view.dart';
import 'package:app_public_facility_report/app/widgets/card_report.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final avm = Provider.of<AdminViewModel>(context, listen: false);
      final rvm = Provider.of<ReportViewModel>(context, listen: false);

      avm.addListener(() async {
        if (avm.user != null) {
          await rvm.getCurrentReport(avm.user!);
        }
      });
    });
  }

  Future<void> _getReport() async {
    final avm = Provider.of<AdminViewModel>(context, listen: false);
    final rvm = Provider.of<ReportViewModel>(context, listen: false);

    if (avm.user != null) {
      rvm.getCurrentReport(avm.user!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final rvm = Provider.of<ReportViewModel>(context);

    return RefreshIndicator(
      onRefresh: _getReport,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsetsGeometry.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 24,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Halo admin",
                    style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Selamat datang di Bagian Kontrol Aplikasi Lapor Kerusakan Fasilitas Umum",
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    spacing: 6,
                    children: [
                      Text(
                        "Total laporan: ",
                        style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                      ),
                      rvm.isLoading
                          ? SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                          : Text(
                            rvm.reports == null
                                ? "0"
                                : rvm.reports!["length"].toString(),
                          ),
                    ],
                  ),

                  Card(
                    child: Padding(
                      padding: EdgeInsetsGeometry.all(12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              rvm.isLoading
                                  ? CircularProgressIndicator(strokeWidth: 2)
                                  : Text(
                                    rvm.reports == null
                                        ? "0"
                                        : rvm.reports!["length_review"]
                                            .toString(),
                                  ),
                              Text("Diajukan"),
                            ],
                          ),
                          Column(
                            children: [
                              rvm.isLoading
                                  ? CircularProgressIndicator(strokeWidth: 2)
                                  : Text(
                                    rvm.reports == null
                                        ? "0"
                                        : rvm.reports!["length_progress"]
                                            .toString(),
                                  ),
                              Text("Diproses"),
                            ],
                          ),
                          Column(
                            children: [
                              rvm.isLoading
                                  ? CircularProgressIndicator(strokeWidth: 2)
                                  : Text(
                                    rvm.reports == null
                                        ? "0"
                                        : rvm.reports!["length_finished"]
                                            .toString(),
                                  ),
                              Text("Selesai"),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Laporan terkini",
                    style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                  ),
                  Consumer<ReportViewModel>(
                    builder: (context, value, child) {
                      if (value.isLoading) {
                        return Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        );
                      }

                      if (value.reports == null) {
                        return Center(
                          child: Text("Tidak ada laporan yang tersedia"),
                        );
                      }

                      if (value.reports!["length"] == 0) {
                        return Center(
                          child: Text("Tidak ada laporan yang tersedia"),
                        );
                      }

                      return ListView.separated(
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          final data = value.reports!["data"];

                          final report = data[index] as ReportModel;

                          return GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder:
                                      (context) => ReportAdminView(
                                        name: report.user!["full_name"],
                                        facility: report.facility,
                                        description: report.description,
                                        location: report.location,
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
                        separatorBuilder:
                            (context, index) => SizedBox(height: 6),
                        itemCount: value.reports!["length"],
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
