import 'package:google_maps_flutter/google_maps_flutter.dart';

class Zone {
  final int? zoneId;
  final String zoneName;
  final String? description;
  final List<List<LatLng>> polygons; // Changed to support multiple polygons
  final String? status;
  final String? createdAt;
  final String? updatedAt;

  Zone({
    this.zoneId,
    required this.zoneName,
    this.description,
    required this.polygons,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  // Backward compatibility getter for single polygon
  List<LatLng> get polygonPoints => polygons.isNotEmpty ? polygons.first : [];

  factory Zone.fromJson(Map<String, dynamic> json) {
    List<List<LatLng>> polygons = [];
    
    // Handle new format with multiple polygons
    if (json['polygons'] != null) {
      final polygonsList = json['polygons'] as List;
      polygons = polygonsList.map<List<LatLng>>((polygon) {
        final pointsList = polygon as List;
        return pointsList.map<LatLng>((point) {
          return LatLng(point['latitude'] as double, point['longitude'] as double);
        }).toList();
      }).toList();
    }
    // Handle backward compatibility with single polygon
    else if (json['polygonPoints'] != null) {
      final pointsList = json['polygonPoints'] as List;
      final points = pointsList.map<LatLng>((point) {
        return LatLng(point['latitude'] as double, point['longitude'] as double);
      }).toList();
      polygons = [points];
    }

    return Zone(
      zoneId: json['zoneId'],
      zoneName: json['zoneName'] ?? '',
      description: json['zoneDescription'] ?? json['description'], // Handle both field names
      polygons: polygons,
      status: json['status'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'zoneId': zoneId,
      'zoneName': zoneName,
      'description': description,
      'polygons': polygons.map((polygon) => 
        polygon.map((point) => {
          'latitude': point.latitude,
          'longitude': point.longitude,
        }).toList()
      ).toList(),
      'status': status,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  Zone copyWith({
    int? zoneId,
    String? zoneName,
    String? description,
    List<List<LatLng>>? polygons,
    String? status,
    String? createdAt,
    String? updatedAt,
  }) {
    return Zone(
      zoneId: zoneId ?? this.zoneId,
      zoneName: zoneName ?? this.zoneName,
      description: description ?? this.description,
      polygons: polygons ?? this.polygons,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}


