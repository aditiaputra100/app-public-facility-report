import 'package:app_public_facility_report/app/admin/services/report_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class ReportViewModel extends ChangeNotifier {
  final ReportService _reportService = ReportService();
  Map<String, dynamic>? _reports;
  String? _error;
  bool _isLoading = false;

  Map<String, dynamic>? get reports => _reports;
  String? get error => _error;
  bool get isLoading => _isLoading;

  Future<void> getCurrentReport(User user, {String status = ""}) async {
    _isLoading = true;
    notifyListeners();

    try {
      String? token = await user.getIdToken();

      final reports = await _reportService.getReport(token, status: status);

      _reports = reports;

      _error = null;
    } catch (_) {
      _error = "Terjadi kesalahan";
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> updateReportStatus(User user, int id, String status) async {
    _isLoading = true;
    notifyListeners();

    bool statusUpdate = false;

    try {
      final token = await user.getIdToken();
      statusUpdate = await _reportService.updateReportStatus(token, id, status);

      _error = null;
    } catch (_) {
      _error = "Terjadi kesalahan";
    }

    _isLoading = false;
    notifyListeners();

    return statusUpdate;
  }
}
