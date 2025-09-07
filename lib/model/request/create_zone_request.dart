class CreateZoneRequest {
  final String zoneName;
  final String zoneDescription;

  CreateZoneRequest({
    required this.zoneName,
    required this.zoneDescription,
  });

  Map<String, dynamic> toJson() {
    return {
      'zoneName': zoneName,
      'zoneDescription': zoneDescription,
    };
  }

  factory CreateZoneRequest.fromJson(Map<String, dynamic> json) {
    return CreateZoneRequest(
      zoneName: json['zoneName'] ?? '',
      zoneDescription: json['zoneDescription'] ?? '',
    );
  }
}

