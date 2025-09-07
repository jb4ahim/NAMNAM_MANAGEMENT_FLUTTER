import 'package:namnam/model/response/ApiResponse.dart';
import 'package:namnam/model/response/Status.dart';
import 'package:namnam/model/request/upload_presign_request.dart';
import 'package:namnam/model/response/upload_presign_response.dart';
import 'package:namnam/network/ApiEndPoints.dart';
import 'package:namnam/network/NetworkApiService.dart';
import 'package:namnam/network/services/upload_service.dart';
import 'package:namnam/core/Utility/Preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UploadServiceImpl implements UploadService {
  final NetworkApiService _networkApiService = NetworkApiService();

  @override
  Future<ApiResponse<UploadPresignResponse>> uploadPresign(UploadPresignRequest request) async {
    print('UploadServiceImpl: Starting uploadPresign request...');
    try {
      // Get access token from preferences
      final prefs = await SharedPreferences.getInstance();
      final prefProvider = PrefProvider(prefs);
      final accessToken = prefProvider.getAccessToken();
      
      print('UploadServiceImpl: Access token retrieved: ${accessToken.isNotEmpty ? 'Present' : 'Not found'}');
      print('UploadServiceImpl: Request data: ${request.toJson()}');

      final response = await _networkApiService.postResponse(
        ApiEndPoints.uploadPresign,
        request.toJson(),
        accessToken.isNotEmpty ? accessToken : null,
      );

      print('UploadServiceImpl: Network response - Status: ${response.status}, Message: ${response.message}');
      print('UploadServiceImpl: Response data: ${response.data}');

      if (response.status == Status.COMPLETED) {
        if (response.data != null) {
          print('UploadServiceImpl: Processing successful response...');
          final uploadPresignResponse = UploadPresignResponse.fromJson(response.data);
          print('UploadServiceImpl: Upload presign response - Success: ${uploadPresignResponse.success}, Key: ${uploadPresignResponse.key}');
          return ApiResponse(
            Status.COMPLETED,
            uploadPresignResponse,
            response.message,
          );
        } else {
          print('UploadServiceImpl: Response data is null');
          return ApiResponse(
            Status.ERROR,
            null,
            'No upload presign data received',
          );
        }
      } else {
        print('UploadServiceImpl: Response status is not COMPLETED');
        
        // Check if it's an authentication error
        if (response.message?.toLowerCase().contains('unauthorized') == true) {
          return ApiResponse(
            Status.ERROR,
            null,
            'Authentication failed. Please log in again.',
          );
        }
        
        return ApiResponse(
          Status.ERROR,
          null,
          response.message ?? 'Failed to get upload presign',
        );
      }
    } catch (e) {
      print('UploadServiceImpl: Exception occurred: $e');
      return ApiResponse(
        Status.ERROR,
        null,
        'Failed to get upload presign: $e',
      );
    }
  }
}


