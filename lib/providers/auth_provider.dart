import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../services/api_service.dart';

class AuthProvider with ChangeNotifier {
  User? _user;
  String? _token;
  bool _isLoading = false;

  User? get user => _user;
  String? get token => _token;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _token != null;

  // Initialize auth state from SharedPreferences
  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('auth_token');
    if (_token != null) {
      try {
        _user = await ApiService.getProfile(_token!);
        notifyListeners();
      } catch (e) {
        // Token is invalid, clear it
        await logout();
      }
    }
  }

  // Login
  Future<bool> login(String studentNumber, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await ApiService.login(
        studentNumber: studentNumber,
        password: password,
      );
      
      if (response['success'] == true) {
        _token = response['data']['token'];
        _user = User.fromJson(response['data']['user']);
        
        // Save token to SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', _token!);
        
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Register
  Future<bool> register({
    required String name,
    required String email,
    required String password,
    required String studentNumber,
    required String major,
    required int classYear,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await ApiService.register(
        name: name,
        email: email,
        password: password,
        studentNumber: studentNumber,
        major: major,
        classYear: classYear,
      );
      
      if (response['success'] == true) {
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Logout
  Future<void> logout() async {
    if (_token != null) {
      try {
        await ApiService.logout(_token!);
      } catch (e) {
        // Ignore logout errors
      }
    }
    
    _user = null;
    _token = null;
    
    // Clear token from SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    
    notifyListeners();
  }

  // Get user profile
  Future<void> refreshProfile() async {
    if (_token != null) {
      try {
        _user = await ApiService.getProfile(_token!);
        notifyListeners();
      } catch (e) {
        // Profile refresh failed, but don't logout
      }
    }
  }
} 