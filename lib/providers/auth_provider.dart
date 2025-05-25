import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../services/user_service.dart';

class AuthProvider with ChangeNotifier {
  UserModel? _user;
  bool _isLoading = false;
  bool _isAuthenticated = false;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _isAuthenticated;

  Future<void> checkAuthStatus() async {
    _isLoading = true;
    notifyListeners();

    try {
      final currentUser = await AuthService().getCurrentUser();
      if (currentUser != null) {
        final userProfile = await UserService.getUserProfile(currentUser.$id);
        _user = userProfile;
        _isAuthenticated = true;
      } else {
        _user = null;
        _isAuthenticated = false;
      }
    } catch (e) {
      _user = null;
      _isAuthenticated = false;
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> signUp({
    required String email,
    required String password,
    required String fullName,
    String? phoneNumber,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final userProfile = await AuthService().signUp(
        email: email,
        password: password,
        fullName: fullName,
        phoneNumber: phoneNumber,
      );

      if (userProfile != null) {
        _user = userProfile;
        _isAuthenticated = true;
        _isLoading = false;
        notifyListeners();
        return true;
      }
    } catch (e) {
      print('Sign up error: $e');
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  Future<bool> signIn({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final userProfile = await AuthService().signIn(
        email: email,
        password: password,
      );

      if (userProfile != null) {
        _user = userProfile;
        _isAuthenticated = true;
        _isLoading = false;
        notifyListeners();
        return true;
      }
    } catch (e) {
      print('Sign in error: $e');
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  Future<void> signOut() async {
    _isLoading = true;
    notifyListeners();

    try {
      await AuthService().signOut();
      _user = null;
      _isAuthenticated = false;
    } catch (e) {
      print('Sign out error: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> refreshUserData() async {
    if (_user != null) {
      try {
        final updatedUser = await UserService.getUserProfile(_user!.userId);
        if (updatedUser != null) {
          _user = updatedUser;
          notifyListeners();
        }
      } catch (e) {
        print('Refresh user data error: $e');
      }
    }
  }
}