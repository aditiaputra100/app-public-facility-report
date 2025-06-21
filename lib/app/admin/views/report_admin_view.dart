import 'package:app_public_facility_report/app/widgets/filled_text_field.dart';
import 'package:flutter/material.dart';

class ReportAdminView extends StatefulWidget {
  final String name;
  final String facility;
  final String description;
  final String location;
  final String? imagePath;

  const ReportAdminView({
    super.key,
    required this.name,
    required this.facility,
    required this.description,
    required this.location,
    this.imagePath,
  });

  @override
  State<ReportAdminView> createState() => _ReportAdminViewState();
}

class _ReportAdminViewState extends State<ReportAdminView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
          child: Column(
            spacing: 36,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Name field
              Column(
                spacing: 12,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Nama"),
                  FilledTextField(
                    controller: TextEditingController(text: widget.name),
                    enabled: false,
                  ),
                ],
              ),

              // Facility
              Column(
                spacing: 12,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Jenis fasilitas"),
                  FilledTextField(
                    controller: TextEditingController(text: widget.facility),
                    enabled: false,
                  ),
                ],
              ),

              // Description
              Column(
                spacing: 12,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Deskripsi kerusakan"),
                  FilledTextField(
                    controller: TextEditingController(text: widget.description),
                    enabled: false,
                  ),
                ],
              ),

              // Location
              Column(
                spacing: 12,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Lokasi"),
                  FilledTextField(
                    controller: TextEditingController(text: widget.location),
                    enabled: false,
                  ),
                ],
              ),

              // Image
              Column(
                spacing: 12,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Foto"),
                  Image.network(
                    widget.imagePath ?? "",
                    alignment: Alignment.centerLeft,
                    width: 128,
                    height: 128,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(Icons.broken_image, size: 64);
                    },
                  ),
                ],
              ),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  child: Text("Ubah Status"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
