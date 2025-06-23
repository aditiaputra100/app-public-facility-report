import 'package:app_public_facility_report/app/widgets/filled_text_field.dart';
import 'package:flutter/material.dart';

class SelectedReportView extends StatelessWidget {
  final String facility;
  final String description;
  final String location;
  final String? status;
  final String? imagePath;

  const SelectedReportView({
    super.key,
    required this.facility,
    required this.description,
    required this.location,
    this.imagePath,
    this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Detail Laporan"), centerTitle: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsetsGeometry.symmetric(
            horizontal: 16,
            vertical: 32,
          ),
          child: Column(
            spacing: 36,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Facility field
              Column(
                spacing: 12,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Jenis Fasilitas"),
                  FilledTextField(
                    controller: TextEditingController(text: facility),
                    enabled: false,
                  ),
                ],
              ),
              // Description field
              Column(
                spacing: 12,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Deskripsi Kerusakan"),
                  FilledTextField(
                    controller: TextEditingController(text: description),
                    enabled: false,
                    maxLines: 5,
                  ),
                ],
              ),
              // Location field
              Column(
                spacing: 12,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Lokasi"),
                  SizedBox(width: double.infinity, child: Text(location)),
                ],
              ),
              // Status
              Column(
                spacing: 12,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Status"),
                  FilledTextField(
                    controller: TextEditingController(
                      text: status ?? "Diajukan",
                    ),
                    enabled: false,
                  ),
                ],
              ),
              // Image field
              Column(
                spacing: 12,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Foto", textAlign: TextAlign.left),
                  Image.network(
                    imagePath ?? "",
                    height: 128,
                    width: 128,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(Icons.broken_image, size: 128);
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
