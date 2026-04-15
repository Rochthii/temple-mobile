import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/network/base_repository.dart';
import '../domain/models/discovery_temple.dart';

class DiscoveryRepository extends BaseRepository {
  final SupabaseClient _supabase;

  DiscoveryRepository(this._supabase);

  /// Fetch nearby temples using PostGIS RPC
  Future<List<DiscoveryTemple>> searchNearbyTemples({
    required double userLat,
    required double userLong,
    String? searchQuery,
    String? provinceId,
  }) async {
    return handleError(() async {
      final response = await _supabase.rpc('get_discovery_temples', params: {
        'user_lat': userLat,
        'user_long': userLong,
        'search_query': searchQuery,
        'filter_province_id': provinceId,
      });

      final List<dynamic> data = response as List<dynamic>;
      return data.map((json) => DiscoveryTemple.fromJson(json)).toList();
    });
  }

  /// Fetch list of all available provinces
  Future<List<Map<String, dynamic>>> getProvinces() async {
    return handleError(() async {
      final response = await _supabase.from('provinces').select('id, name').order('name');
      return List<Map<String, dynamic>>.from(response);
    });
  }
}
