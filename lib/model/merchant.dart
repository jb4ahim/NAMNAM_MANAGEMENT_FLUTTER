class Merchant {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String storeName;
  final String address;
  final String status;
  final String category;
  final double rating;
  final String joinDate;
  final int totalOrders;
  final double totalRevenue;
  final String imageUrl;

  Merchant({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.storeName,
    required this.address,
    required this.status,
    required this.category,
    required this.rating,
    required this.joinDate,
    required this.totalOrders,
    required this.totalRevenue,
    required this.imageUrl,
  });

  factory Merchant.fromJson(Map<String, dynamic> json) {
    return Merchant(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      storeName: json['storeName'] ?? '',
      address: json['address'] ?? '',
      status: json['status'] ?? 'inactive',
      category: json['category'] ?? '',
      rating: (json['rating'] ?? 0.0).toDouble(),
      joinDate: json['joinDate'] ?? '',
      totalOrders: json['totalOrders'] ?? 0,
      totalRevenue: (json['totalRevenue'] ?? 0.0).toDouble(),
      imageUrl: json['imageUrl'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'storeName': storeName,
      'address': address,
      'status': status,
      'category': category,
      'rating': rating,
      'joinDate': joinDate,
      'totalOrders': totalOrders,
      'totalRevenue': totalRevenue,
      'imageUrl': imageUrl,
    };
  }
}

