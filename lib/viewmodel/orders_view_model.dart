import 'package:flutter/material.dart';
import 'package:namnam/model/order.dart';
import 'package:namnam/model/response/Status.dart';

class OrdersViewModel extends ChangeNotifier {
  List<Order> _orders = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Order> get orders => _orders;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Analytics getters
  int get totalOrders => _orders.length;
  int get activeOrders => _orders.where((o) => o.status == 'active').length;
  int get completedOrders => _orders.where((o) => o.status == 'completed').length;
  int get cancelledOrders => _orders.where((o) => o.status == 'cancelled').length;
  int get pendingOrders => _orders.where((o) => o.status == 'pending').length;
  double get totalRevenue => _orders.fold(0.0, (sum, order) => sum + order.totalAmount);
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
  Future<void> fetchOrders() async {
    _setLoading(true);
    _setError(null);

    try {
      // Simulate API call delay
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Generate sample data
      _orders = [
        Order(
          id: 1,
          orderNumber: 'ORD-001',
          customerId: 1,
          customerName: 'Sara Al-Masri',
          merchantId: 1,
          merchantName: 'Beirut Delights',
          driverId: 1,
          driverName: 'Ahmed Hassan',
          status: 'completed',
          totalAmount: 45.0,
          orderDate: '2024-06-15',
          deliveryDate: '2024-06-15',
          estimatedDeliveryTime: '30 min',
          paymentMethod: 'Credit Card',
          paymentStatus: 'paid',
          deliveryAddress: 'Hamra, Beirut',
          items: [
            OrderItem(
              id: 1,
              name: 'Chicken Shawarma',
              quantity: 2,
              price: 15.0,
              totalPrice: 30.0,
            ),
            OrderItem(
              id: 2,
              name: 'French Fries',
              quantity: 1,
              price: 8.0,
              totalPrice: 8.0,
            ),
            OrderItem(
              id: 3,
              name: 'Soft Drink',
              quantity: 1,
              price: 7.0,
              totalPrice: 7.0,
            ),
          ],
        ),
        Order(
          id: 2,
          orderNumber: 'ORD-002',
          customerId: 2,
          customerName: 'Ali Hassan',
          merchantId: 2,
          merchantName: 'Lebanon Coffee House',
          driverId: 2,
          driverName: 'Mohammed Ali',
          status: 'active',
          totalAmount: 28.0,
          orderDate: '2024-06-18',
          estimatedDeliveryTime: '25 min',
          paymentMethod: 'Cash',
          paymentStatus: 'pending',
          deliveryAddress: 'Achrafieh, Beirut',
          items: [
            OrderItem(
              id: 4,
              name: 'Cappuccino',
              quantity: 2,
              price: 12.0,
              totalPrice: 24.0,
            ),
            OrderItem(
              id: 5,
              name: 'Croissant',
              quantity: 1,
              price: 4.0,
              totalPrice: 4.0,
            ),
          ],
        ),
        Order(
          id: 3,
          orderNumber: 'ORD-003',
          customerId: 3,
          customerName: 'Layla Karam',
          merchantId: 3,
          merchantName: 'Fresh Bakery',
          status: 'pending',
          totalAmount: 35.0,
          orderDate: '2024-06-18',
          estimatedDeliveryTime: '40 min',
          paymentMethod: 'Credit Card',
          paymentStatus: 'paid',
          deliveryAddress: 'Gemmayze, Beirut',
          items: [
            OrderItem(
              id: 6,
              name: 'Bread Basket',
              quantity: 1,
              price: 20.0,
              totalPrice: 20.0,
            ),
            OrderItem(
              id: 7,
              name: 'Cheese Pastry',
              quantity: 3,
              price: 5.0,
              totalPrice: 15.0,
            ),
          ],
        ),
        Order(
          id: 4,
          orderNumber: 'ORD-004',
          customerId: 4,
          customerName: 'Omar Nasser',
          merchantId: 5,
          merchantName: 'Express Mart',
          driverId: 4,
          driverName: 'Youssef Nasser',
          status: 'completed',
          totalAmount: 120.0,
          orderDate: '2024-06-17',
          deliveryDate: '2024-06-17',
          estimatedDeliveryTime: '45 min',
          paymentMethod: 'Credit Card',
          paymentStatus: 'paid',
          deliveryAddress: 'Verdun, Beirut',
          items: [
            OrderItem(
              id: 8,
              name: 'Groceries Package',
              quantity: 1,
              price: 120.0,
              totalPrice: 120.0,
            ),
          ],
        ),
        Order(
          id: 5,
          orderNumber: 'ORD-005',
          customerId: 5,
          customerName: 'Nour Saleh',
          merchantId: 1,
          merchantName: 'Beirut Delights',
          status: 'cancelled',
          totalAmount: 32.0,
          orderDate: '2024-06-16',
          paymentMethod: 'Credit Card',
          paymentStatus: 'refunded',
          deliveryAddress: 'Mansourieh, Beirut',
          items: [
            OrderItem(
              id: 9,
              name: 'Falafel Wrap',
              quantity: 2,
              price: 12.0,
              totalPrice: 24.0,
            ),
            OrderItem(
              id: 10,
              name: 'Hummus',
              quantity: 1,
              price: 8.0,
              totalPrice: 8.0,
            ),
          ],
        ),
        Order(
          id: 6,
          orderNumber: 'ORD-006',
          customerId: 6,
          customerName: 'Karim Youssef',
          merchantId: 2,
          merchantName: 'Lebanon Coffee House',
          driverId: 5,
          driverName: 'Karim Saleh',
          status: 'active',
          totalAmount: 18.0,
          orderDate: '2024-06-18',
          estimatedDeliveryTime: '20 min',
          paymentMethod: 'Cash',
          paymentStatus: 'pending',
          deliveryAddress: 'Badaro, Beirut',
          items: [
            OrderItem(
              id: 11,
              name: 'Espresso',
              quantity: 1,
              price: 8.0,
              totalPrice: 8.0,
            ),
            OrderItem(
              id: 12,
              name: 'Chocolate Cake',
              quantity: 1,
              price: 10.0,
              totalPrice: 10.0,
            ),
          ],
        ),
      ];
      
      _setError(null);
    } catch (e) {
      _setError('Failed to fetch orders: $e');
    } finally {
      _setLoading(false);
    }
  }

  void clearError() {
    _setError(null);
  }
}





