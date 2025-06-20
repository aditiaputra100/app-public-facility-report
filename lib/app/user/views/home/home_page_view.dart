import 'package:app_public_facility_report/app/user/models/report_model.dart';
import 'package:app_public_facility_report/app/user/viewmodels/report_view_model.dart';
import 'package:app_public_facility_report/app/user/viewmodels/user_view_model.dart';
import 'package:app_public_facility_report/app/widgets/card_report.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class HomePageView extends StatefulWidget {
  const HomePageView({super.key});

  @override
  State<HomePageView> createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {
  void _hanldeLocation() {
    final uvm = Provider.of<UserViewModel>(context, listen: false);

    if (uvm.locationPermission == LocationPermission.denied) {
      uvm.handleLocationPermission();
      return;
    }

    uvm.getCurrentLocation();
  }

  Future<void> _getReport() async {
    final uvm = Provider.of<UserViewModel>(context, listen: false);
    final rvm = Provider.of<ReportViewModel>(context, listen: false);

    await rvm.getReportCurrent(uvm.user!);
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
    }
  }

  @override
  Widget build(BuildContext context) {
    final uvm = Provider.of<UserViewModel>(context);
    final rvm = Provider.of<ReportViewModel>(context);

    return RefreshIndicator(
      onRefresh: _getReport,
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.35,
            decoration: BoxDecoration(
              color: Colors.blueAccent,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(100)),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: EdgeInsets.only(left: 16, top: 32, right: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 12,
                children: [
                  Column(
                    children: [
                      Text(
                        "Halo,",
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        uvm.user?.displayName?.split(' ').first ?? 'John Doe',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  Text(
                    'Laporkan kerusakan fasilitas di tempat anda',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),

                  // Dashboard laporan
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            spacing: 12,
                            children: [
                              Text(
                                "Total laporan",
                                style: GoogleFonts.dmSans(color: Colors.grey),
                              ),
                              rvm.isLoading
                                  ? CircularProgressIndicator(strokeWidth: 2)
                                  : Text(
                                    rvm.reports != null
                                        ? rvm.reports!["length"] != 0
                                            ? rvm.reports!["length"].toString()
                                            : '0'
                                        : '0',
                                    style: GoogleFonts.dmSans(fontSize: 32),
                                  ),
                            ],
                          ),
                          Column(
                            spacing: 12,
                            children: [
                              Text(
                                "Laporan anda",
                                style: GoogleFonts.dmSans(color: Colors.grey),
                              ),
                              rvm.isLoading
                                  ? CircularProgressIndicator(strokeWidth: 2)
                                  : Text(
                                    rvm.reportsUser["length"].toString(),
                                    style: GoogleFonts.dmSans(fontSize: 32),
                                  ),
                            ],
                          ),
                          Column(
                            spacing: 12,
                            children: [
                              Text(
                                "Buat laporan",
                                style: GoogleFonts.dmSans(color: Colors.grey),
                              ),
                              IconButton.filled(
                                onPressed: () {},
                                icon: Icon(Icons.add),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Lokasi
                  TextButton(
                    onPressed:
                        uvm.isLocationEnable
                            ? uvm.locationPermission ==
                                    LocationPermission.deniedForever
                                ? null
                                : _hanldeLocation
                            : null,
                    child: Row(
                      spacing: 12,
                      children: [
                        Icon(Icons.location_pin),
                        Text(
                          uvm.isLocationEnable
                              ? uvm.locationPermission ==
                                      LocationPermission.deniedForever
                                  ? "Ijin lokasi ditolak permanen, harap ijinkan lokasi"
                                  : uvm.locationPermission ==
                                      LocationPermission.denied
                                  ? "Ijin lokasi ditolak"
                                  : uvm.placemark?.subAdministrativeArea ??
                                      'Lokasi tidak diketahui'
                              : "Lokasi tidak aktif",
                          style: GoogleFonts.dmSans(color: Colors.grey),
                        ),
                        // Text(
                        //   "Ubah lokasi?",
                        //   style: GoogleFonts.dmSans(color: Colors.blue),
                        // ),
                      ],
                    ),
                  ),

                  // Daftar laporan
                  Text(
                    "Laporan terkini",
                    style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                  ),
                  Expanded(
                    child:
                        rvm.isLoading
                            ? Center(
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                            : rvm.reports == null
                            ? Center(
                              child: Text("Tidak ada laporan yang tersedia"),
                            )
                            : rvm.reports!["length"] == 0
                            ? Center(
                              child: Text("Tidak ada laporan yang tersedia"),
                            )
                            : ListView.separated(
                              itemBuilder: (context, index) {
                                final data = rvm.reports!["data"];
                                final report = data[index] as ReportModel;
                                return CardReport(
                                  name: report.user!["full_name"],
                                  description: report.description,
                                  imagePath: report.imagePath,
                                  createdAt: report.createdAt,
                                );
                              },
                              separatorBuilder:
                                  (context, index) => SizedBox(height: 6),
                              itemCount: rvm.reports!["length"],
                            ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
