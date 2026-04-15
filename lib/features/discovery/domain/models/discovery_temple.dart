class DiscoveryTemple {
  final String id;
  final String name;
  final String domain;
  final double? latitude;
  final double? longitude;
  final String? addressVi;
  final String? avatarUrl;
  final String? coverUrl;
  final double distanceMeters;

  DiscoveryTemple({
    required this.id,
    required this.name,
    required this.domain,
    this.latitude,
    this.longitude,
    this.addressVi,
    this.avatarUrl,
    this.coverUrl,
    required this.distanceMeters,
  });

  factory DiscoveryTemple.fromJson(Map<String, dynamic> json) {
    return DiscoveryTemple(
      id: json['id'] as String,
      name: json['name'] as String,
      domain: json['domain'] as String,
      latitude: json['latitude'] == null ? null : (json['latitude'] as num).toDouble(),
      longitude: json['longitude'] == null ? null : (json['longitude'] as num).toDouble(),
      addressVi: json['address_vi'] as String?,
      avatarUrl: json['logo_url'] as String?,
      coverUrl: json['cover_url'] as String?,
      distanceMeters: json['distance_meters'] == null ? 0 : (json['distance_meters'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'domain': domain,
      'latitude': latitude,
      'longitude': longitude,
      'address_vi': addressVi,
      'distance_meters': distanceMeters,
    };
  }
}
