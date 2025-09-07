class UploadPresignResponse {
  final bool success;
  final String key;
  final String url;
  final PresignFields fields;
  final int expiresInSeconds;

  UploadPresignResponse({
    required this.success,
    required this.key,
    required this.url,
    required this.fields,
    required this.expiresInSeconds,
  });

  factory UploadPresignResponse.fromJson(Map<String, dynamic> json) {
    return UploadPresignResponse(
      success: json['success'] ?? false,
      key: json['key'] ?? '',
      url: json['url'] ?? '',
      fields: PresignFields.fromJson(json['fields'] ?? {}),
      expiresInSeconds: json['expiresInSeconds'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'key': key,
      'url': url,
      'fields': fields.toJson(),
      'expiresInSeconds': expiresInSeconds,
    };
  }
}

class PresignFields {
  final String contentType;
  final String acl;
  final String key;
  final String bucket;
  final String xAmzAlgorithm;
  final String xAmzCredential;
  final String xAmzDate;
  final String policy;
  final String xAmzSignature;

  PresignFields({
    required this.contentType,
    required this.acl,
    required this.key,
    required this.bucket,
    required this.xAmzAlgorithm,
    required this.xAmzCredential,
    required this.xAmzDate,
    required this.policy,
    required this.xAmzSignature,
  });

  factory PresignFields.fromJson(Map<String, dynamic> json) {
    return PresignFields(
      contentType: json['Content-Type'] ?? '',
      acl: json['acl'] ?? '',
      key: json['key'] ?? '',
      bucket: json['bucket'] ?? '',
      xAmzAlgorithm: json['X-Amz-Algorithm'] ?? '',
      xAmzCredential: json['X-Amz-Credential'] ?? '',
      xAmzDate: json['X-Amz-Date'] ?? '',
      policy: json['Policy'] ?? '',
      xAmzSignature: json['X-Amz-Signature'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Content-Type': contentType,
      'acl': acl,
      'key': key,
      'bucket': bucket,
      'X-Amz-Algorithm': xAmzAlgorithm,
      'X-Amz-Credential': xAmzCredential,
      'X-Amz-Date': xAmzDate,
      'Policy': policy,
      'X-Amz-Signature': xAmzSignature,
    };
  }
}


