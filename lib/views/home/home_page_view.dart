import 'package:app_public_facility_report/viewmodels/user_view_model.dart';
import 'package:app_public_facility_report/views/widgets/card_report.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class HomePageView extends StatefulWidget {
  const HomePageView({super.key});

  @override
  State<HomePageView> createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {
  User? _user;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    setState(() {
      _user = Provider.of<UserViewModel>(context).user;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
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
                      _user?.displayName?.split(' ').first ?? 'John Doe',
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
                  style: GoogleFonts.poppins(color: Colors.white, fontSize: 16),
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
                            Text('0', style: GoogleFonts.dmSans(fontSize: 32)),
                          ],
                        ),
                        Column(
                          spacing: 12,
                          children: [
                            Text(
                              "Laporan anda",
                              style: GoogleFonts.dmSans(color: Colors.grey),
                            ),
                            Text('0', style: GoogleFonts.dmSans(fontSize: 32)),
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
                  onPressed: () {},
                  child: Row(
                    spacing: 12,
                    children: [
                      Icon(Icons.location_pin),
                      Text(
                        "Default location",
                        style: GoogleFonts.dmSans(color: Colors.grey),
                      ),
                      Text(
                        "Ubah lokasi?",
                        style: GoogleFonts.dmSans(color: Colors.blue),
                      ),
                    ],
                  ),
                ),

                // Daftar laporan
                Text(
                  "Laporan terkini",
                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                ),
                Expanded(
                  child: ListView.separated(
                    itemBuilder: (context, index) {
                      return CardReport();
                    },
                    separatorBuilder: (context, index) => SizedBox(height: 6),
                    itemCount: 5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
