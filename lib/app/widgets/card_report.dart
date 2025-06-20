import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class CardReport extends StatelessWidget {
  final String name;
  final String description;
  String? imagePath;
  final DateTime createdAt;
  CardReport({
    super.key,
    required this.name,
    required this.description,
    this.imagePath,
    required this.createdAt,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          spacing: 6,
          children: [
            Image.network(
              imagePath ?? "",
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Judul
                      Text(
                        name,
                        style: GoogleFonts.dmSans(fontWeight: FontWeight.bold),
                      ),
                      Text(DateFormat("dd-MM-yyyy").format(createdAt)),
                    ],
                  ),

                  // Deskripsi
                  Text(description, style: GoogleFonts.dmSans()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
