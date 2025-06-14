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
    } on PlatformException catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(_errorSnackBar("Terjadi kesalahan!"));
      }
    }
  }

  void _addReport() async {
    String facility = _facilityController.text;
    String description = _descriptionController.text;

    if (facility.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(_errorSnackBar("Fasilitas tidak boleh kosong!"));

      return;
    }

    if (description.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(_errorSnackBar("Deskripsi tidak boleh kosong!"));

      return;
    }

    final uvm = Provider.of<UserViewModel>(context, listen: false);

    if (uvm.placemark == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        _errorSnackBar(
          "Lokasi tidak boleh kosong! Harap hidupkan lokasi atau beri ijin lokasi",
        ),
      );

      return;
    }

    if (_image == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(_errorSnackBar("Foto belum dipilih!"));

      return;
    }

    await uvm.addReport(facility, description, _image!);

    if (uvm.error != null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(_errorSnackBar(uvm.error!));
      }
    } else {
      setState(() {
        _facilityController.clear();
        _descriptionController.clear();
        _image = null;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Laporan berhasil dibuat"),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  SnackBar _errorSnackBar(String message) {
    return SnackBar(
      content: Text(message),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.red,
    );
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
                child:
                    uvm.isLoading
                        ? CircularProgressIndicator(strokeWidth: 2)
                        : Text("Kirim laporan"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
