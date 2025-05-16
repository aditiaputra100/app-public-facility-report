import 'package:app_public_facility_report/services/user_service.dart';
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

  void register(String email, String password, String name) async {
    _isLoading = true;
    notifyListeners();

    try {
      _user = await _userService.create(email, password, name);
      _error = null;
    } catch (error) {
      _error = error.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  void login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      _user = await _userService.signIn(email, password);
      _error = null;
    } catch (error) {
      _error = error.toString();
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
