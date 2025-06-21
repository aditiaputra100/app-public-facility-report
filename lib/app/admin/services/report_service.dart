import 'dart:convert';
import 'package:app_public_facility_report/app/admin/models/report_model.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ReportService {
  final _host = kDebugMode ? "http://10.0.2.2:8000" : "";

  Future<Map<String, dynamic>?> getReport(String? token) async {
    final uri = Uri.parse("$_host/report");

    final response = await http
        .get(uri, headers: {"Authorization": "Bearer $token"})
        .timeout(Duration(seconds: 15));

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final data = body["data"];
      final length = body["length"];
      final lengthReview = body["length_review"];
      final lengthProgress = body["length_progress"];
      final lengthFinished = body["length_finished"];

      final List<ReportModel> reports = [];

      for (final dataMap in data) {
        dataMap["picture_path"] = "$_host/${dataMap["picture_path"]}";
        reports.add(ReportModel.fromMap(dataMap));
      }

      return {
        "data": reports,
        "length": length,
        "length_review": lengthReview,
        "length_progress": lengthProgress,
        "length_finished": lengthFinished,
      };
    }

    return null;
  }
}
