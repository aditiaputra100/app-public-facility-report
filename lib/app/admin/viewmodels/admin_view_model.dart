import 'package:app_public_facility_report/app/admin/services/admin_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AdminViewModel extends ChangeNotifier {
  final AdminService _adminService = AdminService();
  User? _user;
  String? _error;
  bool _isLoading = false;

  User? get user => _user;
  String? get error => _error;
  bool get isLoading => _isLoading;

  AdminViewModel() {
    _adminService.authStateChange.listen((User? user) {
      _user = user;
      notifyListeners();
    });
  }

  Future<void> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      _user = await _adminService.signIn(email, password);
      _error = null;
    } on FirebaseAuthException catch (error) {
      if (error.code == 'invalid-email') {
        _error = 'Email tidak valid';
      } else if (error.code == 'user-not-found') {
        _error = 'Akun tidak ditemukan';
      } else if (error.code == 'wrong-password') {
        _error = 'Password salah';
      } else {
        _error = "Email atau password salah";
      }
    } catch (error) {
      _error = "Terjadi kesalahan";
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    await _adminService.signOut();

    _isLoading = false;
    notifyListeners();
  }
}
