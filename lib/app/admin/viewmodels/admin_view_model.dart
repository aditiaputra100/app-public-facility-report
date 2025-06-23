import 'package:app_public_facility_report/app/admin/models/admin_model.dart';
import 'package:app_public_facility_report/app/admin/services/admin_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AdminViewModel extends ChangeNotifier {
  final AdminService _adminService = AdminService();
  User? _user;
  String? _error;
  bool _isLoading = false;

  List<AdminModel>? _admins;

  User? get user => _user;
  String? get error => _error;
  bool get isLoading => _isLoading;

  List<AdminModel>? get admins => _admins;

  AdminViewModel() {
    _adminService.authStateChange.listen((User? user) {
      print("User $user");
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

    try {
      await _adminService.signOut();
      _user = null;
      _error = null;
    } catch (error) {
      _error = "Terjadi kesalahan";
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> register(String email, String password, String fullName) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _adminService.createAdmin(email, password, fullName);
      _error = null;
    } on FirebaseAuthException catch (error) {
      switch (error.code) {
        case "invalid-email":
          _error = "Email tidak valid";
          break;
        case "email-already-in-use":
          _error = "Email telah digunakan";
          break;
        case "network-request-failed":
          _error = "Tidak tersambung ke intenet";
          break;
        default:
          _error = "Terjadi kesalahan";
      }
    } catch (error) {
      _error = "Terjadi kesalahan";
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> getAllAdmin() async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(Duration(seconds: 5));

    try {
      String? token = await _user?.getIdToken();
      _admins = await _adminService.getAdmin(token);

      _error = null;
    } catch (error) {
      _error = "Terjadi kesalahan";
    }

    _isLoading = false;
    notifyListeners();
  }
}
