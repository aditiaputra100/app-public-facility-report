import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class UserCardReport extends StatelessWidget {
  final String? imagePath;
  final String facility;
  final String description;
  final String location;
  final DateTime createdAt;

  const UserCardReport({
    super.key,
    this.imagePath,
    required this.facility,
    required this.description,
    required this.createdAt,
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8),
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
                spacing: 6,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Judul (fasilitas)
                      Text(
                        facility,
                        style: GoogleFonts.dmSans(fontWeight: FontWeight.bold),
                      ),
                      Text(DateFormat("dd-MM-yyyy").format(createdAt)),
                    ],
                  ),

                  // Deskripsi
                  Text(description, style: GoogleFonts.dmSans()),
                  Row(
                    children: [
                      Icon(Icons.place, color: Colors.grey),
                      Text(location),
                    ],
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
