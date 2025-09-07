import 'package:google_maps_flutter/google_maps_flutter.dart';

class ZonePolygonsResponse {
  final int zoneId;
  final String zoneName;
  final List<List<LatLng>> polygons;

  ZonePolygonsResponse({
    required this.zoneId,
    required this.zoneName,
    required this.polygons,
  });

  factory ZonePolygonsResponse.fromApiResponse(List<dynamic> data) {
    if (data.isEmpty) {
      return ZonePolygonsResponse(zoneId: 0, zoneName: '', polygons: []);
    }

    // The API returns a list with one item containing zone info and polygons
    final zoneData = data.first as Map<String, dynamic>;
    final zoneId = zoneData['zoneId'] ?? 0;
    final zoneName = zoneData['zoneName'] ?? '';

    // Parse polygons from the zone data
    List<List<LatLng>> polygons = [];
    
    if (zoneData['polygons'] != null) {
      final polygonsList = zoneData['polygons'] as List;
      
      for (final polygonData in polygonsList) {
        if (polygonData is Map<String, dynamic> && 
            polygonData['type'] == 'Polygon' && 
            polygonData['coordinates'] != null) {
          
          // The coordinates structure is [[[lat, lng], [lat, lng], ...]]
          final coordinates = polygonData['coordinates'] as List;
          if (coordinates.isNotEmpty) {
            // Take the first (and usually only) ring of coordinates
            final ring = coordinates.first as List;
            final points = ring.map<LatLng>((coord) {
              // coord is [lng, lat] array
              final lng = coord[0] as double;
              final lat = coord[1] as double;
              return LatLng(lat, lng); // Note: LatLng constructor takes (lat, lng)
            }).toList();
            polygons.add(points);
          }
        }
      }
    }

    return ZonePolygonsResponse(
      zoneId: zoneId,
      zoneName: zoneName,
      polygons: polygons,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'zoneId': zoneId,
      'zoneName': zoneName,
      'polygons': polygons.map((polygon) => 
        polygon.map((point) => {
          'latitude': point.latitude,
          'longitude': point.longitude,
        }).toList()
      ).toList(),
    };
  }

  List<List<LatLng>> toLatLngPolygons() {
    return polygons;
  }
}
