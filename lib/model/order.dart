class Order {
  final int id;
  final String orderNumber;
  final int customerId;
  final String customerName;
  final int merchantId;
  final String merchantName;
  final int? driverId;
  final String? driverName;
  final String status;
  final double totalAmount;
  final String orderDate;
  final String? deliveryDate;
  final String? estimatedDeliveryTime;
  final String paymentMethod;
  final String paymentStatus;
  final String deliveryAddress;
  final List<OrderItem> items;

  Order({
    required this.id,
    required this.orderNumber,
    required this.customerId,
    required this.customerName,
    required this.merchantId,
    required this.merchantName,
    this.driverId,
    this.driverName,
    required this.status,
    required this.totalAmount,
    required this.orderDate,
    this.deliveryDate,
    this.estimatedDeliveryTime,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.deliveryAddress,
    required this.items,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] ?? 0,
      orderNumber: json['orderNumber'] ?? '',
      customerId: json['customerId'] ?? 0,
      customerName: json['customerName'] ?? '',
      merchantId: json['merchantId'] ?? 0,
      merchantName: json['merchantName'] ?? '',
      driverId: json['driverId'],
      driverName: json['driverName'],
      status: json['status'] ?? 'pending',
      totalAmount: (json['totalAmount'] ?? 0.0).toDouble(),
      orderDate: json['orderDate'] ?? '',
      deliveryDate: json['deliveryDate'],
      estimatedDeliveryTime: json['estimatedDeliveryTime'],
      paymentMethod: json['paymentMethod'] ?? '',
      paymentStatus: json['paymentStatus'] ?? 'pending',
      deliveryAddress: json['deliveryAddress'] ?? '',
      items: (json['items'] as List<dynamic>?)
          ?.map((item) => OrderItem.fromJson(item))
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'orderNumber': orderNumber,
      'customerId': customerId,
      'customerName': customerName,
      'merchantId': merchantId,
      'merchantName': merchantName,
      'driverId': driverId,
      'driverName': driverName,
      'status': status,
      'totalAmount': totalAmount,
      'orderDate': orderDate,
      'deliveryDate': deliveryDate,
      'estimatedDeliveryTime': estimatedDeliveryTime,
      'paymentMethod': paymentMethod,
      'paymentStatus': paymentStatus,
      'deliveryAddress': deliveryAddress,
      'items': items.map((item) => item.toJson()).toList(),
    };
  }
}

class OrderItem {
  final int id;
  final String name;
  final int quantity;
  final double price;
  final double totalPrice;
  final String? notes;

  OrderItem({
    required this.id,
    required this.name,
    required this.quantity,
    required this.price,
    required this.totalPrice,
    this.notes,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      quantity: json['quantity'] ?? 0,
      price: (json['price'] ?? 0.0).toDouble(),
      totalPrice: (json['totalPrice'] ?? 0.0).toDouble(),
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'quantity': quantity,
      'price': price,
      'totalPrice': totalPrice,
      'notes': notes,
    };
  }
}

