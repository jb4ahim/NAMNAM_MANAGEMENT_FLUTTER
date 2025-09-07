import 'package:flutter/material.dart';
import 'package:namnam/model/customer.dart';
import 'package:namnam/model/response/Status.dart';

class CustomersViewModel extends ChangeNotifier {
  List<Customer> _customers = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Customer> get customers => _customers;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Analytics getters
  int get totalCustomers => _customers.length;
  int get activeCustomers => _customers.where((c) => c.status == 'active').length;
  int get inactiveCustomers => _customers.where((c) => c.status == 'inactive').length;
  int get totalOrders => _customers.fold(0, (sum, customer) => sum + customer.totalOrders);
  double get totalRevenue => _customers.fold(0.0, (sum, customer) => sum + customer.totalSpent);
  double get averageOrderValue => totalOrders > 0 ? totalRevenue / totalOrders : 0.0;

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _errorMessage = error;
    notifyListeners();
  }

  // Generate sample data for now
  Future<void> fetchCustomers() async {
    _setLoading(true);
    _setError(null);

    try {
      // Simulate API call delay
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Generate sample data
      _customers = [
        Customer(
          id: 1,
          name: 'Sara Al-Masri',
          email: 'sara@email.com',
          phone: '+961 70 111 222',
          address: 'Hamra, Beirut',
          status: 'active',
          joinDate: '2024-01-05',
          totalOrders: 15,
          totalSpent: 450.0,
          lastOrderDate: '2024-06-15',
          imageUrl: '',
        ),
        Customer(
          id: 2,
          name: 'Ali Hassan',
          email: 'ali@email.com',
          phone: '+961 71 222 333',
          address: 'Achrafieh, Beirut',
          status: 'active',
          joinDate: '2024-02-10',
          totalOrders: 8,
          totalSpent: 280.0,
          lastOrderDate: '2024-06-12',
          imageUrl: '',
        ),
        Customer(
          id: 3,
          name: 'Layla Karam',
          email: 'layla@email.com',
          phone: '+961 76 333 444',
          address: 'Gemmayze, Beirut',
          status: 'active',
          joinDate: '2024-03-15',
          totalOrders: 22,
          totalSpent: 890.0,
          lastOrderDate: '2024-06-18',
          imageUrl: '',
        ),
        Customer(
          id: 4,
          name: 'Omar Nasser',
          email: 'omar@email.com',
          phone: '+961 78 444 555',
          address: 'Verdun, Beirut',
          status: 'inactive',
          joinDate: '2024-01-20',
          totalOrders: 3,
          totalSpent: 120.0,
          lastOrderDate: '2024-05-20',
          imageUrl: '',
        ),
        Customer(
          id: 5,
          name: 'Nour Saleh',
          email: 'nour@email.com',
          phone: '+961 79 555 666',
          address: 'Mansourieh, Beirut',
          status: 'active',
          joinDate: '2024-02-28',
          totalOrders: 12,
          totalSpent: 380.0,
          lastOrderDate: '2024-06-16',
          imageUrl: '',
        ),
        Customer(
          id: 6,
          name: 'Karim Youssef',
          email: 'karim@email.com',
          phone: '+961 70 666 777',
          address: 'Badaro, Beirut',
          status: 'active',
          joinDate: '2024-04-10',
          totalOrders: 6,
          totalSpent: 210.0,
          lastOrderDate: '2024-06-14',
          imageUrl: '',
        ),
      ];
      
      _setError(null);
    } catch (e) {
      _setError('Failed to fetch customers: $e');
    } finally {
      _setLoading(false);
    }
  }

  void clearError() {
    _setError(null);
  }
}





