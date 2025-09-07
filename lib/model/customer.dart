class Customer {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String address;
  final String status;
  final String joinDate;
  final int totalOrders;
  final double totalSpent;
  final String lastOrderDate;
  final String imageUrl;

  Customer({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.status,
    required this.joinDate,
    required this.totalOrders,
    required this.totalSpent,
    required this.lastOrderDate,
    required this.imageUrl,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      address: json['address'] ?? '',
      status: json['status'] ?? 'active',
      joinDate: json['joinDate'] ?? '',
      totalOrders: json['totalOrders'] ?? 0,
      totalSpent: (json['totalSpent'] ?? 0.0).toDouble(),
      lastOrderDate: json['lastOrderDate'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
      'status': status,
      'joinDate': joinDate,
      'totalOrders': totalOrders,
      'totalSpent': totalSpent,
      'lastOrderDate': lastOrderDate,
      'imageUrl': imageUrl,
    };
  }
}

