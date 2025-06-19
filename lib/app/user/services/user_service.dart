import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart';
import 'package:app_public_facility_report/app/user/models/report_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class UserService {
  final _auth = FirebaseAuth.instance;
  final _host = kDebugMode ? "http://10.0.2.2:8000" : "";

  Future<Map<String, List<ReportModel>?>> getReportUser(User user) async {
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

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final data = body["data"];

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

      return statusMap;
    }

    return statusMap;
  }

  Future<void> createReport(ReportModel report, String? token) async {
    final uri = Uri.parse("$_host/report");
    final File fileImage = File(report.imagePath);

    final request = http.MultipartRequest("POST", uri);

    final image = http.MultipartFile.fromBytes(
      'picture',
      fileImage.readAsBytesSync(),
      filename: basename(fileImage.path),
    );

    request.headers.addAll({"Authorization": "Bearer $token"});

    request.fields.addAll(report.toMap());
    request.files.add(image);

    // final response = await http.post(
    //   uri,
    //   headers: {
    //     "Authorization": "Bearer $token",
    //     "Content-Type": "application/x-www-form-urlencoded",
    //   },
    //   body: report.toMap(),
    // );

    final response = await request.send().timeout(Duration(seconds: 15));

    if (response.statusCode == 201) {
      return;
    } else if (response.statusCode == 401) {
      throw HttpException("bad-request", uri: uri);
    }
  }

  Future<User?> create(String email, String password, String name) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await credential.user?.updateDisplayName(name);
      await credential.user?.reload();

      String? token = await credential.user?.getIdToken();

      final uri = Uri.parse("$_host/register/user");

      final response = await http.post(
        uri,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 201) {
        User? user = FirebaseAuth.instance.currentUser;

        return user;
      }

      credential.user?.delete();

      throw HttpException(
        "Terjadi masalah dengan server! Hubungi operator",
        uri: uri,
      );
    } on FirebaseAuthException catch (e) {
      throw FirebaseAuthException(code: e.code);
    }
  }

  Future<User?> signIn(String email, String password) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    return credential.user;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  Stream<User?> get authStateChange => _auth.authStateChanges();
}
