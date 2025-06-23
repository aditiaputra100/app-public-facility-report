import 'dart:convert';
import 'package:app_public_facility_report/app/admin/models/report_model.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ReportService {
  final _host = kDebugMode ? "http://10.0.2.2:8000" : "";

  Future<Map<String, dynamic>?> getReport(
    String? token, {
    String status = "",
  }) async {
    final uri = Uri.parse("$_host/report?status_report=$status");

    final response = await http
        .get(uri, headers: {"Authorization": "Bearer $token"})
        .timeout(Duration(seconds: 15));

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final data = body["data"];
      final length = body["counts"];

      final List<ReportModel> reports = [];

      for (final dataMap in data) {
        dataMap["picture_path"] = "$_host/${dataMap["picture_path"]}";
        reports.add(ReportModel.fromMap(dataMap));
      }

      return {
        "data": reports,
        "length": length["all"],
        "length_review": length["in-review"],
        "length_progress": length["in-progress"],
        "length_finished": length["finished"],
      };
    }

    return null;
  }

  Future<bool> updateReportStatus(String? token, int id, String status) async {
    final uri = Uri.parse("$_host/report/status/$id");

    final response = await http.put(
      uri,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode({"status_report": status}),
    );

    if (response.statusCode == 200) {
      return true;
    }

    return false;
  }
}
