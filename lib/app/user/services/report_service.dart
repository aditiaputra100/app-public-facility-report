import 'dart:convert';

import 'package:app_public_facility_report/app/user/models/report_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ReportService {
  final _host = kDebugMode ? "http://10.0.2.2:8000" : "";

  Future<Map<String, dynamic>?> getCurrentReport(String? token) async {
    final uri = Uri.parse("$_host/report");

    final response = await http
        .get(uri, headers: {"Authorization": "Bearer $token"})
        .timeout(Duration(seconds: 15));

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      final List<ReportModel> reports = [];
      final length = body["counts"];

      for (final data in body["data"]) {
        data["picture_path"] = "$_host/${data["picture_path"]}";
        reports.add(ReportModel.fromMap(data));
      }

      return {"data": reports, "length": length["all"]};
    }

    return null;
  }

  Future<Map<String, dynamic>> getReportUser(User user) async {
    final uri = Uri.parse("$_host/report/user/${user.uid}");

    String? token = await user.getIdToken();

    final response = await http
        .get(uri, headers: {"Authorization": "Bearer $token"})
        .timeout(Duration(seconds: 15));

    final Map<String, List<ReportModel>?> statusMap = {
      "in-review": null,
      "in-progress": null,
      "finished": null,
    };
    final Map<String, dynamic> finalData = {"data": statusMap, "length": 0};

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final data = body["data"];

      finalData["length"] = body["length"];

      for (final Map<String, dynamic> map in data) {
        map["picture_path"] = "$_host/${map["picture_path"]}";

        switch (map["status"]) {
          case "in-progress":
            if (statusMap["in-progress"] == null) {
              statusMap["in-progress"] = [ReportModel.fromMap(map)];
            } else {
              statusMap["in-progress"]!.add(ReportModel.fromMap(map));
            }
            break;
          case "finished":
            if (statusMap["finished"] == null) {
              statusMap["finished"] = [ReportModel.fromMap(map)];
            } else {
              statusMap["finished"]!.add(ReportModel.fromMap(map));
            }
            break;
          case "in-review":
          default:
            if (statusMap["in-review"] == null) {
              statusMap["in-review"] = [ReportModel.fromMap(map)];
            } else {
              statusMap["in-review"]!.add(ReportModel.fromMap(map));
            }
        }
      }

      finalData["data"] = statusMap;

      return finalData;
    }

    return finalData;
  }
}
