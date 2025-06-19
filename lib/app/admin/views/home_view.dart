import 'package:app_public_facility_report/app/widgets/card_report.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
                  children: [
                    Text(
                      "Total laporan: ",
                      style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                    ),
                    Text("9999"),
                  ],
                ),

                Card(
                  child: Padding(
                    padding: EdgeInsetsGeometry.all(12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(children: [Text("0"), Text("Diajukan")]),
                        Column(children: [Text("0"), Text("Diproses")]),
                        Column(children: [Text("0"), Text("Selesai")]),
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
                CardReport(),
                CardReport(),
                CardReport(),
                CardReport(),
                CardReport(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
