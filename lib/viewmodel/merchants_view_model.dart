import 'package:flutter/material.dart';
import 'package:namnam/model/merchant.dart';
import 'package:namnam/model/merchant_item.dart';
import 'package:namnam/model/response/Status.dart';
import 'package:namnam/network/services/merchants_service.dart';
import 'package:namnam/network/services/merchants_service_impl.dart';

class MerchantsViewModel extends ChangeNotifier {
  List<MerchantItem> _merchants = [];
  bool _isLoading = false;
  String? _errorMessage;
  final MerchantsService _merchantsService = MerchantsServiceImpl();

  List<MerchantItem> get merchants => _merchants;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Analytics getters
  int get totalMerchants => _merchants.length;
  // These metrics don't exist on new API items; keep simple total for now
  int get activeMerchants => 0;
  int get inactiveMerchants => 0;
  double get averageRating => 0.0;
  int get totalOrders => 0;
  double get totalRevenue => 0.0;

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _errorMessage = error;
    notifyListeners();
  }

  Future<void> fetchMerchants({int? limit, int? offset, String? q}) async {
    _setLoading(true);
    _setError(null);

    try {
      final response = await _merchantsService.getMerchants(
        limit: limit,
        offset: offset,
        q: q,
      );

      if (response.status == Status.COMPLETED && response.data != null) {
        _merchants = response.data!;
        _setError(null);
      } else {
        _merchants = [];
        _setError(response.message ?? 'Failed to fetch merchants');
      }
    } catch (e) {
      _setError('Failed to fetch merchants: $e');
    } finally {
      _setLoading(false);
    }
  }

  void clearError() {
    _setError(null);
  }
}





