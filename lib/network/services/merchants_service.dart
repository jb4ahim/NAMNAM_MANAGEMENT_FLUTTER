import 'package:namnam/model/merchant_item.dart';
import 'package:namnam/model/response/ApiResponse.dart';

abstract class MerchantsService {
  Future<ApiResponse<List<MerchantItem>>> getMerchants({int? limit, int? offset, String? q});
}


