import 'dart:io';

import 'package:app_public_facility_report/app/user/services/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class UserViewModel extends ChangeNotifier {
  final UserService _userService = UserService();
  User? _user;
  String? _error;
  bool _isLoading = false;

  User? get user => _user;
  String? get error => _error;
  bool get isLoading => _isLoading;

  UserViewModel() {
    _userService.authStateChange.listen((User? user) {
      _user = user;
      notifyListeners();
    });
  }

  Future<void> addReport(
    String facility,
    String description,
    String location,
    File image,
  ) async {
    print("created");
  }

  Future<void> register(String email, String password, String name) async {
    _isLoading = true;
    notifyListeners();

    try {
      _user = await _userService.create(email, password, name);
      _error = null;
    } on FirebaseAuthException catch (error) {
      switch (error.code) {
        case 'email-already-in-use':
          _error = 'Email sudah digunakan';
          break;
        case 'weak-password':
          _error = 'Password lemah';
          break;
        default:
          _error = 'Terjadi kesalahan! Hubungi operator';
      }
    } on HttpException catch (error) {
      _error = error.message;
    } catch (error) {
      _user?.delete();
      _error = "Kesalahan tidak diketahui! Hubungi operator";
    }

    // Check if error is truly filled
    // await Future.delayed(Duration(seconds: 2), () {
    //   // Getting error
    //   // _error = "Error";

    //   // No error
    //   _error = null;
    // });

    _isLoading = false;
    notifyListeners();
  }

  Future<void> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      _user = await _userService.signIn(email, password);
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

  Future<void> forgetPassword(String email) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _userService.resetPassword(email);
      _error = null;
    } on FirebaseAuthException catch (error) {
      if (error.code == 'invalid-email') {
        _error = "Email tidak valid";
      } else if (error.code == 'user-not-found') {
        _error = "Akun tidak ditemukan";
      } else {
        _error = "Tejadi kesalahan";
      }
    } catch (error) {
      _error = "Terjadi kesalahan";
    }

    _isLoading = false;
    notifyListeners();
  }

  void logout() {
    _userService.signOut();
    _user = null;
    notifyListeners();
  }
}
