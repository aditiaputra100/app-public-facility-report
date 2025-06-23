import 'dart:async';
import 'package:app_public_facility_report/app/user/services/report_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class ReportViewModel extends ChangeNotifier {
  final ReportService _reportService = ReportService();

  String? _error;
  bool _isLoading = false;
  Map<String, dynamic> _reportsUser = {
    "data": {"in-review": null, "in-progress": null, "finished": null},
    "length": 0,
  };
  Map<String, dynamic>? _reports;

  String? get error => _error;
  bool get isLoading => _isLoading;
  Map<String, dynamic> get reportsUser => _reportsUser;
  Map<String, dynamic>? get reports => _reports;

  Future<void> getReportCurrent(User user) async {
    _isLoading = true;
    notifyListeners();

    try {
      String? token = await user.getIdToken();
      _reports = await _reportService.getCurrentReport(token);
      _error = null;
    } on TimeoutException catch (_) {
      _error = "Tidak dapat terhubung ke server";
    } catch (_) {
      _error = "Terjadi kesalahan";
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> getReportCurrentUser(User user) async {
    _isLoading = true;
    notifyListeners();

    try {
      _reportsUser = await _reportService.getReportUser(user);
      _error = null;
    } on TimeoutException catch (_) {
      _error = "Tidak dapat terhubung ke server";
    } catch (_) {
      _error = "Terjadi kesalahan";
    }

    _isLoading = false;
    notifyListeners();
  }
}
