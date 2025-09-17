class MerchantItem {
  final int id;
  final String? name;
  final String? logoKey;
  final DateTime? joinedAt;
  final String? description;
  final bool? isOwnedByApp;
  final String? logoUrl;

  MerchantItem({
    required this.id,
    this.name,
    this.logoKey,
    this.joinedAt,
    this.description,
    this.isOwnedByApp,
    this.logoUrl,
  });

  factory MerchantItem.fromJson(Map<String, dynamic> json) {
    return MerchantItem(
      id: json['id'] ?? 0,
      name: json['name'],
      logoKey: json['logoKey'],
      joinedAt: json['joinedAt'] != null ? DateTime.tryParse(json['joinedAt']) : null,
      description: json['description'],
      isOwnedByApp: json['isOwnedByApp'],
      logoUrl: json['logoUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'logoKey': logoKey,
      'joinedAt': joinedAt?.toIso8601String(),
      'description': description,
      'isOwnedByApp': isOwnedByApp,
      'logoUrl': logoUrl,
    };
  }
}


