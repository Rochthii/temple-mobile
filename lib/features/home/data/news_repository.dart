import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/base_repository.dart';
import '../domain/models/news_model.dart';

class NewsRepository extends BaseRepository {
  final SupabaseClient _supabase;

  NewsRepository(this._supabase);

  Future<List<NewsModel>> getNews({String? tenantId, int limit = 10}) async {
    return handleError(() async {
      var query = _supabase.from('news').select('*').eq('status', 'published');
      
      if (tenantId != null) {
        query = query.eq('tenant_id', tenantId);
      }
      
      final response = await query.order('published_at', ascending: false).limit(limit);
      
      final List<dynamic> data = response as List<dynamic>;
      return data.map((json) => NewsModel.fromJson(json)).toList();
    });
  }
}

final newsRepositoryProvider = Provider<NewsRepository>((ref) {
  return NewsRepository(Supabase.instance.client);
});

final newsFutureProvider = FutureProvider.family<List<NewsModel>, String?>((ref, tenantId) async {
  return ref.watch(newsRepositoryProvider).getNews(tenantId: tenantId);
});
