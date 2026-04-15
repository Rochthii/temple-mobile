import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/base_repository.dart';
import '../../discovery/domain/models/about_section.dart';

class TenantModel {
  final String id;
  final String name;
  final String? avatarUrl;

  TenantModel({required this.id, required this.name, this.avatarUrl});

  factory TenantModel.fromJson(Map<String, dynamic> json) {
    return TenantModel(
      id: json['id'] as String,
      name: (json['name'] ?? json['domain'] ?? 'Chưa có tên') as String,
      avatarUrl: json['logo_url'] as String?,
    );
  }
}

class TempleRepository extends BaseRepository {
  Future<List<TenantModel>> getTemples() async {
    return await handleError(() async {
      final response = await supabase
          .from('tenants')
          .select('id, name, domain, logo_url')
          .order('name', ascending: true);
          
      return (response as List).map((e) => TenantModel.fromJson(e)).toList();
    });
  }

  Future<List<AboutSection>> getTempleAboutSections(String tenantId) async {
    return await handleError(() async {
      final response = await supabase
          .from('about_sections')
          .select('*')
          .eq('tenant_id', tenantId)
          .eq('is_active', true)
          .order('display_order', ascending: true);

      return (response as List).map((e) => AboutSection.fromJson(e)).toList();
    });
  }
}

final templeRepositoryProvider = Provider<TempleRepository>((ref) {
  return TempleRepository();
});

final templesFutureProvider = FutureProvider<List<TenantModel>>((ref) async {
  return ref.watch(templeRepositoryProvider).getTemples();
});

final templeAboutProvider = FutureProvider.family<List<AboutSection>, String>((ref, tenantId) async {
  return ref.watch(templeRepositoryProvider).getTempleAboutSections(tenantId);
});
