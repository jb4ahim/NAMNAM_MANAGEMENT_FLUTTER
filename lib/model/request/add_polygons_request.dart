import 'package:google_maps_flutter/google_maps_flutter.dart';

class AddPolygonsRequest {
  final int zoneId;
  final List<PolygonCoordinates> polygons;

  AddPolygonsRequest({
    required this.zoneId,
    required this.polygons,
  });

  Map<String, dynamic> toJson() {
    return {
      'zoneId': zoneId,
      'polygons': polygons.map((polygon) => polygon.toJson()).toList(),
    };
  }
}

class PolygonCoordinates {
  final List<CoordinatePoint> coordinates;

  PolygonCoordinates({
    required this.coordinates,
  });

  Map<String, dynamic> toJson() {
    return {
      'coordinates': coordinates.map((coord) => coord.toJson()).toList(),
    };
  }

  // Create from LatLng list (from Google Maps)
  factory PolygonCoordinates.fromLatLngList(List<LatLng> latLngList) {
    final coordinates = latLngList.map((latLng) => CoordinatePoint(
      longitude: latLng.longitude,
      latitude: latLng.latitude,
    )).toList();
    
    return PolygonCoordinates(coordinates: coordinates);
  }
}

class CoordinatePoint {
  final double longitude;
  final double latitude;

  CoordinatePoint({
    required this.longitude,
    required this.latitude,
  });

  Map<String, dynamic> toJson() {
    return {
      'longitude': longitude,
      'latitude': latitude,
    };
  }
}

