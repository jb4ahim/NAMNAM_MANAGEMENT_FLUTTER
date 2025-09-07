import 'package:flutter/material.dart';
import 'package:namnam/model/merchant.dart';
import 'package:namnam/model/response/Status.dart';

class MerchantsViewModel extends ChangeNotifier {
  List<Merchant> _merchants = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Merchant> get merchants => _merchants;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Analytics getters
  int get totalMerchants => _merchants.length;
  int get activeMerchants => _merchants.where((m) => m.status == 'active').length;
  int get inactiveMerchants => _merchants.where((m) => m.status == 'inactive').length;
  double get averageRating => _merchants.isNotEmpty 
      ? _merchants.map((m) => m.rating).reduce((a, b) => a + b) / _merchants.length 
      : 0.0;
  int get totalOrders => _merchants.fold(0, (sum, merchant) => sum + merchant.totalOrders);
  double get totalRevenue => _merchants.fold(0.0, (sum, merchant) => sum + merchant.totalRevenue);

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _errorMessage = error;
    notifyListeners();
  }

  // Generate sample data for now
  Future<void> fetchMerchants() async {
    _setLoading(true);
    _setError(null);

    try {
      // Simulate API call delay
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Generate sample data
      _merchants = [
        Merchant(
          id: 1,
          name: 'Restaurant Beirut',
          email: 'info@restaurantbeirut.com',
          phone: '+961 1 234 567',
          storeName: 'Beirut Delights',
          address: 'Hamra Street, Beirut',
          status: 'active',
          category: 'Restaurant',
          rating: 4.5,
          joinDate: '2024-01-10',
          totalOrders: 234,
          totalRevenue: 12500.0,
          imageUrl: '',
        ),
        Merchant(
          id: 2,
          name: 'Cafe Lebanon',
          email: 'contact@cafelebanon.com',
          phone: '+961 1 345 678',
          storeName: 'Lebanon Coffee House',
          address: 'Gemmayze, Beirut',
          status: 'active',
          category: 'Cafe',
          rating: 4.8,
          joinDate: '2024-02-15',
          totalOrders: 189,
          totalRevenue: 8900.0,
          imageUrl: '',
        ),
        Merchant(
          id: 3,
          name: 'Bakery Fresh',
          email: 'hello@bakeryfresh.com',
          phone: '+961 1 456 789',
          storeName: 'Fresh Bakery',
          address: 'Achrafieh, Beirut',
          status: 'active',
          category: 'Bakery',
          rating: 4.3,
          joinDate: '2024-03-05',
          totalOrders: 156,
          totalRevenue: 6700.0,
          imageUrl: '',
        ),
        Merchant(
          id: 4,
          name: 'Pizza Palace',
          email: 'orders@pizzapalace.com',
          phone: '+961 1 567 890',
          storeName: 'Palace Pizza',
          address: 'Verdun, Beirut',
          status: 'inactive',
          category: 'Restaurant',
          rating: 4.1,
          joinDate: '2024-01-20',
          totalOrders: 98,
          totalRevenue: 4500.0,
          imageUrl: '',
        ),
        Merchant(
          id: 5,
          name: 'Supermarket Express',
          email: 'info@supermarketexpress.com',
          phone: '+961 1 678 901',
          storeName: 'Express Mart',
          address: 'Mansourieh, Beirut',
          status: 'active',
          category: 'Supermarket',
          rating: 4.6,
          joinDate: '2024-02-28',
          totalOrders: 312,
          totalRevenue: 18900.0,
          imageUrl: '',
        ),
      ];
      
      _setError(null);
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





