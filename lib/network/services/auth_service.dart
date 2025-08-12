import 'package:namnam/model/request/login_request.dart';
import 'package:namnam/model/response/ApiResponse.dart';
import 'package:namnam/model/response/login_response.dart';

abstract class AuthService {
  Future<ApiResponse<LoginResponse>> login(LoginRequest request);
} 