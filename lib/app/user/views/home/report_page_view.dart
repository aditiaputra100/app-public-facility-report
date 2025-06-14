import 'dart:io';

import 'package:app_public_facility_report/app/user/viewmodels/user_view_model.dart';
import 'package:app_public_facility_report/app/widgets/filled_text_field.dart';
import 'package:app_public_facility_report/app/widgets/image_picker_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ReportPageView extends StatefulWidget {
  const ReportPageView({super.key});

  @override
  State<ReportPageView> createState() => _ReportPageViewState();
}

class _ReportPageViewState extends State<ReportPageView> {
  final TextEditingController _facilityController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  File? _image;

  Future<void> imagePicker() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);

      if (image == null) return;

      final imagePath = File(image.path);

      setState(() {
        _image = imagePath;
      });
    } on PlatformException catch (error) {
      print("Error: $error");
    }
  }

  void _addReport() {
    String facility = _facilityController.text;
    String description = _descriptionController.text;

    final uvm = Provider.of<UserViewModel>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    final uvm = Provider.of<UserViewModel>(context);
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
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
                  controller: _facilityController,
                  hintText: "Contoh: Jalan, Lampu Jalan, dll...",
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
                  controller: _descriptionController,
                  hintText: "Deskripsikan kerusakan..",
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
                SizedBox(
                  width: double.infinity,
                  // child: OutlinedButton.icon(
                  //   onPressed: () {},
                  //   icon: Icon(Icons.location_pin),
                  //   label: Text("Default location"),
                  // ),
                  child: Text(
                    uvm.placemark?.subAdministrativeArea ??
                        "Lokasi tidak diketahui",
                  ),
                ),
              ],
            ),
            // Image field
            Column(
              spacing: 12,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Foto"),
                ImagePickerButton(
                  image: _image,
                  onTap: () async {
                    await imagePicker();
                  },
                ),
              ],
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _addReport,
                child: Text("Kirim laporan"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
