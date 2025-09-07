class ApiEndPoints {
  static const String authLogin = "auth/login";
  static const String getCategories = "categories";
  static const String createCategory = "categories";
  static const String uploadPresign = "uploads/presign";
  static const String zones = "zones";
  static const String zonesPolygonsMultiple = "zones/polygons/multiple";
  
  // Dynamic endpoint for getting zone polygons: zones/{zoneId}/polygons
  static String getZonePolygons(int zoneId) => "zones/$zoneId/polygons";
}
