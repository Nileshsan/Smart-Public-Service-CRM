import 'package:flutter/material.dart';
import 'package:ps_crm_app/models/user.dart';
import 'package:ps_crm_app/services/api_service.dart';
import 'package:ps_crm_app/utils/storage_service.dart';

class AuthProvider extends ChangeNotifier {
  User? _user;
  bool _isLoading = false;
  String? _error;
  bool _isAuthenticated = false;

  final ApiService _apiService = ApiService();

  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _isAuthenticated;

  AuthProvider() {
    _initializeAuth();
  }

  void _initializeAuth() {
    _user = StorageService.getUser();
    _isAuthenticated = _user != null && StorageService.getToken() != null;
    notifyListeners();
  }

  Future<bool> register({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
    required String role,
    String? phone,
    String? ward,
    String? department,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      if (password != confirmPassword) {
        throw Exception('Passwords do not match');
      }

      if (role == 'officer' && (department == null || department.isEmpty)) {
        throw Exception('Department is required for officers');
      }

      final response = await _apiService.register(
        name: name,
        email: email,
        password: password,
        role: role,
        phone: phone,
        ward: ward,
        department: department,
      );

      if (!response.success) {
        throw Exception(response.message ?? 'Registration failed');
      }

      if (response.pending == true) {
        // Officer registration pending approval
        _isLoading = false;
        _error = null;
        notifyListeners();
        return true;
      }

      if (response.data != null) {
        final userData = User(
          id: response.data!.id,
          name: response.data!.name,
          email: response.data!.email,
          role: response.data!.role,
          phone: response.data!.phone,
          ward: response.data!.ward,
          department: response.data!.department,
          token: response.data!.token,
        );

        if (response.data!.token != null) {
          await StorageService.setToken(response.data!.token!);
        }
        await StorageService.setUser(userData);

        _user = userData;
        _isAuthenticated = true;
      }

      _isLoading = false;
      _error = null;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString().replaceFirst('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiService.login(
        email: email,
        password: password,
      );

      if (!response.success) {
        throw Exception(response.message ?? 'Login failed');
      }

      if (response.data == null) {
        throw Exception('Invalid credentials');
      }

      // Check if officer is pending approval
      if (response.data!.role == 'officer') {
        // Status handling can be added here
      }

      final userData = User(
        id: response.data!.id,
        name: response.data!.name,
        email: response.data!.email,
        role: response.data!.role,
        phone: response.data!.phone,
        ward: response.data!.ward,
        department: response.data!.department,
        token: response.data!.token,
      );

      if (response.data!.token != null) {
        await StorageService.setToken(response.data!.token!);
      }
      await StorageService.setUser(userData);

      _user = userData;
      _isAuthenticated = true;

      _isLoading = false;
      _error = null;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString().replaceFirst('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await StorageService.clearToken();
    await StorageService.clearUser();
    _user = null;
    _isAuthenticated = false;
    _error = null;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
