class LoginResponse {
  final String? managementUserId;
  final String? userId;
  final String? accessToken;
  final String? refreshToken;

  LoginResponse({
    this.managementUserId,
    this.userId,
    this.accessToken,
    this.refreshToken,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    // The API returns camelCase keys inside data
    return LoginResponse(
      managementUserId: json['managementUserId'] ?? json['management_user_id'],
      userId: json['userId'] ?? json['user_id'],
      accessToken: json['accessToken'] ?? json['access_token'],
      refreshToken: json['refreshToken'] ?? json['refresh_token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'managementUserId': managementUserId,
      'userId': userId,
      'accessToken': accessToken,
      'refreshToken': refreshToken,
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