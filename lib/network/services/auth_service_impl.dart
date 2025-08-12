import 'package:namnam/model/request/login_request.dart';
import 'package:namnam/model/response/ApiResponse.dart';
import 'package:namnam/model/response/login_response.dart';
import 'package:namnam/model/response/Status.dart';
import 'package:namnam/network/ApiEndPoints.dart';
import 'package:namnam/network/NetworkApiService.dart';
import 'package:namnam/network/services/auth_service.dart';

class AuthServiceImpl implements AuthService {
  final NetworkApiService _networkApiService = NetworkApiService();

  @override
  Future<ApiResponse<LoginResponse>> login(LoginRequest request) async {
    print('AuthServiceImpl: Starting login request...');
    try {
      final response = await _networkApiService.postResponse(
        ApiEndPoints.authLogin,
        request.toJson(),
        null, // No token needed for login
      );

      print('AuthServiceImpl: Network response - Status: ${response.status}, Message: ${response.message}');
      print('AuthServiceImpl: Response data: ${response.data}');

      if (response.status == Status.COMPLETED) {
        if (response.data != null) {
          print('AuthServiceImpl: Processing successful response...');
          final loginResponse = LoginResponse.fromJson(response.data);
          print('AuthServiceImpl: LoginResponse created - Access Token: ${loginResponse.accessToken}');
          return ApiResponse(
            Status.COMPLETED,
            loginResponse,
            response.message,
          );
        } else {
          print('AuthServiceImpl: Response data is null');
          return ApiResponse(
            Status.ERROR,
            null,
            'Login failed: Invalid response data',
          );
        }
      } else {
        print('AuthServiceImpl: Response status is not COMPLETED');
        return ApiResponse(
          Status.ERROR,
          null,
          response.message ?? 'Login failed',
        );
      }
    } catch (e) {
      print('AuthServiceImpl: Exception occurred: $e');
      return ApiResponse(
        Status.ERROR,
        null,
        'Login failed: $e',
      );
    }
  }
} 