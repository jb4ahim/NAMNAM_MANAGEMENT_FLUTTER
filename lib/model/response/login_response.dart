class LoginResponse {
  final String? managementUserId;
  final String? userId;
  final String? accessToken;

  LoginResponse({
    this.managementUserId,
    this.userId,
    this.accessToken,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      managementUserId: json['management_user_id'],
      userId: json['user_id'],
      accessToken: json['access_token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'management_user_id': managementUserId,
      'user_id': userId,
      'access_token': accessToken,
    };
  }
}

class UserData {
  final int? id;
  final String? name;
  final String? email;
  final String? role;
  final String? profileImage;
  final String? phoneNumber;
  final String? createdAt;
  final String? updatedAt;

  UserData({
    this.id,
    this.name,
    this.email,
    this.role,
    this.profileImage,
    this.phoneNumber,
    this.createdAt,
    this.updatedAt,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      role: json['role'],
      profileImage: json['profileImage'],
      phoneNumber: json['phoneNumber'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
} 