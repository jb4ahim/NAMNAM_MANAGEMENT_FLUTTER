import 'package:namnam/core/Utility/Preferences.dart';
import 'package:namnam/model/merchant_item.dart';
import 'package:namnam/model/response/ApiResponse.dart';
import 'package:namnam/model/response/Status.dart';
import 'package:namnam/network/ApiEndPoints.dart';
import 'package:namnam/network/NetworkApiService.dart';
import 'package:namnam/network/services/merchants_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MerchantsServiceImpl implements MerchantsService {
  final NetworkApiService _networkApiService = NetworkApiService();

  @override
  Future<ApiResponse<List<MerchantItem>>> getMerchants({int? limit, int? offset, String? q}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final prefProvider = PrefProvider(prefs);
      final accessToken = prefProvider.getAccessToken();

      if (accessToken.isEmpty) {
        return ApiResponse(Status.ERROR, null, 'Missing access token. Please log in.');
      }

      final Map<String, dynamic> queryParams = {
        'limit': '',
        'offset':  '',
        'q': null,
      };

      final response = await _networkApiService.fetchData(
        ApiEndPoints.merchants,
        queryParams,
        accessToken,
      );

      if (response.status == Status.COMPLETED) {
        // New API shape: data contains items list and pagination
        final data = response.data;
        if (data is Map && data['items'] is List) {
          final merchants = (data['items'] as List)
              .map((item) => MerchantItem.fromJson(item))
              .toList();
          return ApiResponse(Status.COMPLETED, merchants, response.message);
        }
        return ApiResponse(Status.ERROR, null, 'Invalid response format: Expected data.items List');
      }

      return ApiResponse(Status.ERROR, null, response.message ?? 'Failed to fetch merchants');
    } catch (e) {
      return ApiResponse(Status.ERROR, null, 'Failed to fetch merchants: $e');
    }
  }
}


