import 'dart:async';
import 'dart:io';

import 'package:app_public_facility_report/app/user/models/report_model.dart';
import 'package:app_public_facility_report/app/user/services/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class UserViewModel extends ChangeNotifier {
  final UserService _userService = UserService();
  User? _user;
  String? _error;
  bool _isLoading = false;
  bool _isLocationEnable = false;
  LocationPermission? _locationPermission;
  Placemark? _placemark;

  User? get user => _user;
  String? get error => _error;
  bool get isLoading => _isLoading;
  bool get isLocationEnable => _isLocationEnable;
  LocationPermission? get locationPermission => _locationPermission;
  Placemark? get placemark => _placemark;

  UserViewModel() {
    _userService.authStateChange.listen((User? user) {
      _user = user;
      notifyListeners();
    });
  }

  Future<void> handleLocationPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _isLocationEnable = false;
      notifyListeners();
      return;
    }

    _isLocationEnable = true;
    notifyListeners();

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        _locationPermission = LocationPermission.denied;
        notifyListeners();
        return;
      }
    } else if (permission == LocationPermission.deniedForever) {
      _locationPermission = LocationPermission.deniedForever;
      notifyListeners();
      return;
    }

    _locationPermission = LocationPermission.always;
    getCurrentLocation();
    notifyListeners();
  }

  Future<void> getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition();
    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );
    Placemark placemark = placemarks[0];

    _placemark = placemark;
    notifyListeners();
  }

  // Future<Map<String, List<ReportModel>?>> getReportCurrentUser() async {
  //   _isLoading = true;
  //   notifyListeners();

  //   Map<String, List<ReportModel>?> reportMap = {
  //     "in-review": null,
  //     "in-progress": null,
  //     "finished": null,
  //   };

  //   try {
  //     reportMap = await _userService.getReportUser(_user!);

  //     _error = null;
  //   } catch (error) {
  //     _error = "Terjadi kesalahan";
  //   }

  //   _isLoading = false;
  //   notifyListeners();

  //   return reportMap;
  // }

  Future<void> addReport(
    String facility,
    String description,
    File image,
  ) async {
    _isLoading = true;
    notifyListeners();

    final ReportModel reportModel = ReportModel(
      facility: facility,
      description: description,
      location: _placemark!.subAdministrativeArea ?? 'Unknown',
      imagePath: image.path,
      status: 'in-review',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    String? token = await _user!.getIdToken();

    try {
      await _userService.createReport(reportModel, token);
      _error = null;
    } on TimeoutException catch (_) {
      _error = "Tidak dapat terhubung ke server!";
    } on HttpException catch (error) {
      if (error.message == 'bad-request') {
        _error = "Token tidak valid!";
      }
    } catch (_) {
      _error = "Terjadi kesalahan!";
    }

    _isLoading = false;
    notifyListeners();
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
