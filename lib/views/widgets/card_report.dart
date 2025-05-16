import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CardReport extends StatelessWidget {
  const CardReport({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          spacing: 6,
          children: [
            Image.network(
              'src',
              width: 64,
              height: 64,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Icon(Icons.broken_image, size: 64);
              },
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Judul
                  Text(
                    "Nama pelapor",
                    style: GoogleFonts.dmSans(fontWeight: FontWeight.bold),
                  ),

                  // Deskripsi
                  Text(
                    "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Duis commodo, lorem eget.",
                    style: GoogleFonts.dmSans(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
