import 'package:flutter/material.dart';
import 'package:namnam/model/response/ApiResponse.dart';
import 'package:namnam/model/response/Status.dart';
import 'package:namnam/model/request/upload_presign_request.dart';
import 'package:namnam/model/response/upload_presign_response.dart';
import 'package:namnam/network/services/upload_service.dart';
import 'package:namnam/network/services/upload_service_impl.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:http_parser/http_parser.dart';

class UploadViewModel extends ChangeNotifier {
  final UploadService _uploadService = UploadServiceImpl();
  
  Status _status = Status.COMPLETED;
  String _message = '';
  UploadPresignResponse? _uploadPresignResponse;
  bool _isLoading = false;

  // Getters
  Status get status => _status;
  String get message => _message;
  UploadPresignResponse? get uploadPresignResponse => _uploadPresignResponse;
  bool get isLoading => _isLoading;

  // Set loading state
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // Set status and message
  void _setStatus(Status status, String message) {
    _status = status;
    _message = message;
    notifyListeners();
  }

  // Get upload presign URL
  Future<bool> getUploadPresign(String contentType, int size, String filename) async {
    _setLoading(true);
    _setStatus(Status.LOADING, 'Getting upload presign...');

    try {
      final request = UploadPresignRequest( 
        contentType: contentType,
        size: size,
        filename: filename,
      );

      final response = await _uploadService.uploadPresign(request);

      if (response.status == Status.COMPLETED && response.data != null) {
        _uploadPresignResponse = response.data;
        _setStatus(Status.COMPLETED, response.message ?? 'Upload presign obtained successfully');
        _setLoading(false);
        return true;
      } else {
        _setStatus(Status.ERROR, response.message ?? 'Failed to get upload presign');
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _setStatus(Status.ERROR, 'Error getting upload presign: $e');
      _setLoading(false);
      return false;
    }
  }

  // Upload file
  Future<String?> uploadFile(PlatformFile file) async {
    try {
      if (file.bytes != null) {
        // Get upload presign
        final success = await getUploadPresign(
          _getMimeType(file.extension ?? 'png'),
          file.size,
          file.name,
        );

        if (success && _uploadPresignResponse != null) {
          print('File ready for upload: ${file.name}');
          print('Upload presign response: ${_uploadPresignResponse!.toJson()}');
          
          // Upload file to S3 using presign response
          final uploadSuccess = await _uploadToS3(file);
          
          if (uploadSuccess) {
            print('File uploaded successfully to S3');
            return _uploadPresignResponse!.key;
          } else {
            _setStatus(Status.ERROR, 'Failed to upload file to S3');
            return null;
          }
        }
      }
      
      return null;
    } catch (e) {
      _setStatus(Status.ERROR, 'Error uploading file: $e');
      return null;
    }
  }

  // Upload file to S3 using presign URL
  Future<bool> _uploadToS3(PlatformFile file) async {
    try {
      if (_uploadPresignResponse == null) {
        print('UploadPresignResponse is null');
        return false;
      }

      // Build the form data for S3 upload
      final uri = Uri.parse(_uploadPresignResponse!.url);
      
      // Create multipart request
      final request = http.MultipartRequest('POST', uri);
      
      // Add all the presign fields
      request.fields.addAll({
        'key': _uploadPresignResponse!.fields.key,
        'bucket': _uploadPresignResponse!.fields.bucket,
        'X-Amz-Algorithm': _uploadPresignResponse!.fields.xAmzAlgorithm,
        'X-Amz-Credential': _uploadPresignResponse!.fields.xAmzCredential,
        'X-Amz-Date': _uploadPresignResponse!.fields.xAmzDate,
        'Policy': _uploadPresignResponse!.fields.policy,
        'X-Amz-Signature': _uploadPresignResponse!.fields.xAmzSignature,
        'acl': _uploadPresignResponse!.fields.acl,
        'Content-Type': _uploadPresignResponse!.fields.contentType,
      });

      // Add the file
      final contentType = _uploadPresignResponse!.fields.contentType;
      request.files.add(
        http.MultipartFile.fromBytes(
          'file',
          file.bytes!,
          filename: file.name,
          contentType: MediaType.parse(contentType),
        ),
      );

      print('Sending S3 upload request...');
      print('URL: ${_uploadPresignResponse!.url}');
      print('Fields: ${request.fields}');
      print('File: ${file.name}, Size: ${file.bytes!.length}');

      // Send the request
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
print('Fields: ${request.fields}');
print('S3 upload response body: $responseBody');
      print('S3 upload response status: ${response.statusCode}');
      print('S3 upload response body: $responseBody');

      if (response.statusCode == 200 || response.statusCode == 204) {
        print('File uploaded successfully to S3');
        return true;
      } else {
        print('S3 upload failed with status: ${response.statusCode}');
        print('Response body: $responseBody');
        return false;
      }
    } catch (e) {
      print('Error uploading to S3: $e');
      return false;
    }
  }

  // Get MIME type from file extension
  String _getMimeType(String extension) {
    switch (extension.toLowerCase()) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'gif':
        return 'image/gif';
      case 'webp':
        return 'image/webp';
      case 'svg':
        return 'image/svg+xml';
      case 'bmp':
        return 'image/bmp';
      case 'ico':
        return 'image/x-icon';
      default:
        return 'image/png'; // Default fallback
    }
  }

  // Clear state
  void clearState() {
    _status = Status.COMPLETED;
    _message = '';
    _uploadPresignResponse = null;
    _isLoading = false;
    notifyListeners();
  }
}
