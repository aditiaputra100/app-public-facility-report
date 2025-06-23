import 'dart:convert';
import 'dart:io';

import 'package:app_public_facility_report/app/admin/models/admin_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class AdminService {
  final _auth = FirebaseAuth.instance;
  final _host = kDebugMode ? "http://10.0.2.2:8000" : "";

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

  Future<void> createAdmin(String email, String password, String name) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await credential.user?.updateDisplayName(name);
      await credential.user?.reload();

      String? token = await credential.user?.getIdToken();

      final uri = Uri.parse("$_host/register/admin");

      final response = await http.post(
        uri,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode != 201) {
        credential.user?.delete();
        throw HttpException("Terjadi kesalahan!", uri: uri);
      }
    } on FirebaseAuthException catch (e) {
      throw FirebaseAuthException(code: e.code);
    }
  }

  Future<List<AdminModel>?> getAdmin(String? token) async {
    final uri = Uri.parse("$_host/admin");

    final response = await http.get(
      uri,
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final data = body["data"];
      final length = body["length"];

      if (length == 0) {
        return null;
      }

      final List<AdminModel> listOfAdmin = [];

      for (final admin in data) {
        listOfAdmin.add(
          AdminModel(name: admin["full_name"], uid: admin["uid"]),
        );
      }

      return listOfAdmin;
    }

    return null;
  }

  Stream<User?> get authStateChange => _auth.authStateChanges();
}
