import 'package:namnam/model/response/ApiResponse.dart';
import 'package:namnam/model/request/upload_presign_request.dart';
import 'package:namnam/model/response/upload_presign_response.dart';

abstract class UploadService {
  Future<ApiResponse<UploadPresignResponse>> uploadPresign(UploadPresignRequest request);
}


