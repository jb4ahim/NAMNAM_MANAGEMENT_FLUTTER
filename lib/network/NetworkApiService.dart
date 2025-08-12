import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
 
import 'package:http/http.dart' as http;
import 'package:namnam/model/response/ApiResponse.dart';
import 'package:namnam/model/response/Status.dart';
import 'package:namnam/network/AppException.dart';
import 'package:namnam/network/baseAPIservice.dart';


class NetworkApiService extends BaseApiService {
  @override
  Future<ApiResponse> postResponse(
      String url, Map<String, dynamic> data, String? token) async {
    Map<String, dynamic> responseJson;

    try {
      var body = json.encode(data);
      Uri uri = Uri.parse(baseUrl + url);

      print("Request URL: $uri");
      log("Request Body: $body");

      final response = await http
          .post(uri,
              headers: {
                "Access-Control-Allow-Origin": "*",
                "Content-Type": "application/json",
                'Authorization': token != null ? 'Bearer $token' : '',
                'Accept': '*/*',

              },
              body: body)
          .timeout(const Duration(seconds: 120));

      print("Response Status Code: ${response.statusCode}");
      log("Response Body: ${response.body}");

      if (response.statusCode == 401) {
        print("Unauthorized");
        //  viewModel.refreshToken(preferencesInstance.getrefreshToken());
        return ApiResponse(Status.ERROR, null, "Unauthorized");
      }

      responseJson = json.decode(response.body);
      print("Decoded Response JSON: $responseJson");

      if (responseJson["success"] == true) {
        return ApiResponse(
            Status.COMPLETED, responseJson["data"], responseJson["message"]);
      }

      return ApiResponse(Status.ERROR, null, responseJson["message"]);
    } on SocketException {
      print("No Internet Connection");
      throw FetchDataException('No Internet Connection');
    } on TimeoutException {
      print("Request Timeout");
      throw FetchDataException('Request Timeout');
    } catch (e) {
      print("Unexpected Error: $e");
      throw FetchDataException('Unexpected Error Occurred');
    }
  }

  // Future<void> uploadProfilePicture({
  //   required String phoneNumber,
  //   required String fileName,
  //   required String type,
  //   required File imageFile,
  //   required MediaType contentType,
  //   required String token,
  // }) async {
  //   print('Starting uploadProfilePicture...');

  //   var request = http.MultipartRequest(
  //     'POST',
  //     Uri.parse('$baseUrl${ApiEndPoints.uploadAttachment}'),
  //   );

  //   request.headers['Authorization'] = 'Bearer $token';
  //   request.headers['type'] = type;
  //   request.headers['phoneNumber'] = phoneNumber;
  //   request.headers['fileName'] = fileName;
  //   request.headers['UserId'] = preferencesInstance.getuserId().toString() != ""
  //       ? preferencesInstance.getuserId().toString()
  //       : "";
  //   request.headers['contentType'] = contentType.toString();
  //   request.headers['X-Real-IP'] =
  //       preferencesInstance.getIpAddress().toString();

  //   print('Added Authorization header: Bearer $token');

  //   try {
  //     request.files.add(
  //       await http.MultipartFile.fromPath(
  //         'fileData',
  //         imageFile.path,
  //         contentType: contentType,
  //       ),
  //     );

  //     print('Image file attached to request.');
  //   } catch (e) {
  //     print('Error reading or attaching image file: $e');
  //     return;
  //   }

  //   print('Request ready to send: ${imageFile.path}');

  //   try {
  //     var response = await request.send();
  //     print('Request sent. Waiting for response...');

  //     var responseBody = await response.stream.bytesToString();

  //     if (response.statusCode == 401) {
  //       print("Unauthorized");
  //       return;
  //     }

  //     if (response.statusCode == 200 || response.statusCode == 201) {
  //       print('Image uploaded successfully.');
  //       print('Response body: $responseBody');

  //       var jsonResponse = json.decode(responseBody);
  //       String pictureUrl = jsonResponse['data']['profileImage'];
  //       print('Image URL: $pictureUrl');
  //     //  preferencesInstance.setprofileImage(pictureUrl);
  //     } else {
  //       print('Failed to upload image. Status Code: ${response.statusCode}');
  //       print('Response body: $responseBody');
  //     }
  //   } catch (e) {
  //     print('Error occurred while uploading image: $e');
  //   }
  // }


  Future<ApiResponse> fetchData(
      String url, Map<String, dynamic> data, String? token) async {
    Uri uri;
    if (!url.contains("?")) {
      uri = Uri.parse(baseUrl + url).replace(queryParameters: data);
    } else {
      uri = Uri.parse(baseUrl + url);
    }

    print("Fetching data from: $uri");

    try {
      final response = await http.get(
        uri,
        headers: {
          "Access-Control-Allow-Origin": "*",
          "Content-Type": "application/json",
          'Authorization': token != null ? 'Bearer $token' : '',
          'Accept': '*/*',
        
        },
      );

      print("Response Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 401) {
        print("Unauthorized");
        return ApiResponse(Status.ERROR, null, "Unauthorized");
      }

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        print("Data fetched successfully: $jsonData");
        return ApiResponse(
            Status.COMPLETED, jsonData['data'], jsonData['message']);
      } else {
        throw Exception('Failed to load data: ${response.reasonPhrase}');
      }
    } catch (e) {
      print("Error fetching data: $e");
      return ApiResponse(Status.ERROR, null, "Unexpected error occurred");
    }
  }
}
