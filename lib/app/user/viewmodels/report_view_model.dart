import 'package:app_public_facility_report/app/user/models/report_model.dart';
import 'package:app_public_facility_report/app/user/services/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class ReportViewModel extends ChangeNotifier {
  final UserService _userService = UserService();

  String? _error;
  bool _isLoading = false;
  Map<String, List<ReportModel>?> _reports = {
    "in-review": null,
    "in-progress": null,
    "finished": null,
  };

  String? get error => _error;
  bool get isLoading => _isLoading;
  Map<String, List<ReportModel>?> get reports => _reports;

  Future<void> getReportCurrentUser(User user) async {
    _isLoading = true;
    notifyListeners();

    try {
      _reports = await _userService.getReportUser(user);

      _error = null;
    } catch (error) {
      _error = "Terjadi kesalahan";
    }

    _isLoading = false;
    notifyListeners();
  }
}
