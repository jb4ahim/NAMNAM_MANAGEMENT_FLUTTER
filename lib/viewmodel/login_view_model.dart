import 'package:flutter/material.dart';
import 'package:namnam/model/request/login_request.dart';
import 'package:namnam/model/response/ApiResponse.dart';
import 'package:namnam/model/response/login_response.dart';
import 'package:namnam/model/response/Status.dart';
import 'package:namnam/network/services/auth_service.dart';
import 'package:namnam/network/services/auth_service_impl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:namnam/core/Utility/Preferences.dart';

class LoginViewModel extends ChangeNotifier {
  final AuthService _authService = AuthServiceImpl();
  
  Status _status = Status.COMPLETED;
  String _message = '';
  LoginResponse? _loginResponse;
  bool _isLoading = false;

  // Getters
  Status get status => _status;
  String get message => _message;
  LoginResponse? get loginResponse => _loginResponse;
  bool get isLoading => _isLoading;

  // Login method
  Future<bool> login(String email, String password) async {
    print('LoginViewModel: Starting login process...');
    _setLoading(true);
    _setStatus(Status.LOADING);

    try {
      final request = LoginRequest(email: email, password: password);
      print('LoginViewModel: Sending login request...');
      final response = await _authService.login(request);

      print('LoginViewModel: Response received - Status: ${response.status}, Message: ${response.message}');
      _setStatus(response.status!);
      _setMessage(response.message ?? '');

      if (response.status == Status.COMPLETED) {
        print('LoginViewModel: Login successful!');
        _loginResponse = response.data;
        print('LoginViewModel: Access Token: ${response.data?.accessToken}');
        print('LoginViewModel: User ID: ${response.data?.userId ?? response.data?.managementUserId}');
        // Persist token and login state
        try {
          final prefs = await SharedPreferences.getInstance();
          final prefProvider = PrefProvider(prefs);
          final token = response.data?.accessToken ?? '';
          if (token.isNotEmpty) {
            prefProvider.setAccessToken(token);
          }
          prefProvider.login();
          final parsedUserId = int.tryParse(
            (response.data?.userId?.isNotEmpty == true
                ? response.data?.userId
                : response.data?.managementUserId) ?? '',
          );
          if (parsedUserId != null) {
            prefProvider.setuserId(parsedUserId);
          }
        } catch (e) {
          print('LoginViewModel: Error saving token/user: $e');
        }
        _setLoading(false);
        return true;
      } else {
        print('LoginViewModel: Login failed - Status: ${response.status}');
        _setLoading(false);
        return false;
      }
    } catch (e) {
      print('LoginViewModel: Exception occurred: $e');
      _setStatus(Status.ERROR);
      _setMessage('Login failed: $e');
      _setLoading(false);
      return false;
    }
  }

  // Reset state
  void reset() {
    _status = Status.COMPLETED;
    _message = '';
    _loginResponse = null;
    _isLoading = false;
    notifyListeners();
  }

  // Private setters
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setStatus(Status status) {
    _status = status;
    notifyListeners();
  }

  void _setMessage(String message) {
    _message = message;
    notifyListeners();
  }
} 