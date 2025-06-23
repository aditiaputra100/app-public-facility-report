import 'package:app_public_facility_report/app/admin/viewmodels/admin_view_model.dart';
import 'package:app_public_facility_report/app/admin/viewmodels/report_view_model.dart';
import 'package:app_public_facility_report/app/widgets/filled_text_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReportAdminView extends StatefulWidget {
  final int id;
  final String name;
  final String facility;
  final String description;
  final String location;
  final String status;
  final String? imagePath;

  const ReportAdminView({
    super.key,
    required this.id,
    required this.name,
    required this.facility,
    required this.description,
    required this.location,
    required this.status,
    this.imagePath,
  });

  @override
  State<ReportAdminView> createState() => _ReportAdminViewState();
}

class _ReportAdminViewState extends State<ReportAdminView> {
  String? statusReportWidget;
  @override
  void initState() {
    super.initState();
    statusReportWidget = widget.status;
  }

  void _updateReport(String status) async {
    final rvm = Provider.of<ReportViewModel>(context, listen: false);
    final uvm = Provider.of<AdminViewModel>(context, listen: false);

    Navigator.of(context).pop();

    final statusReport = await rvm.updateReportStatus(
      uvm.user!,
      widget.id,
      status,
    );

    if (statusReport) {
      if (mounted) {
        setState(() {
          statusReportWidget = status;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          _showSnackbar("Berhasil mengubah status laporan!", Colors.green),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          _showSnackbar("Gagal mengubah status laporan!", Colors.red),
        );
      }
    }
  }

  SnackBar _showSnackbar(String message, Color color) {
    return SnackBar(
      content: Text(message),
      behavior: SnackBarBehavior.floating,
      backgroundColor: color,
    );
  }

  void _showBottomSheetModal() {
    print(statusReportWidget);
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: 200,
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(36)),
          ),
          child: Center(
            child: Column(
              spacing: 6,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed:
                        statusReportWidget == "in-review"
                            ? null
                            : () {
                              _updateReport("in-review");
                            },
                    child: Text("Diajukan"),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed:
                        statusReportWidget == "in-progress"
                            ? null
                            : () {
                              _updateReport("in-progress");
                            },
                    child: Text("Diproses"),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed:
                        statusReportWidget == "finished"
                            ? null
                            : () {
                              _updateReport("finished");
                            },
                    child: Text("Selesai"),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

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

              Consumer<ReportViewModel>(
                builder: (context, value, child) {
                  return SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: value.isLoading ? null : _showBottomSheetModal,
                      child:
                          value.isLoading
                              ? CircularProgressIndicator(strokeWidth: 2)
                              : Text("Ubah Status"),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
