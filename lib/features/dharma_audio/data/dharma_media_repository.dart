import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/base_repository.dart';
import '../domain/models/dharma_media_model.dart';
import '../../../features/temple_context/domain/temple_context_provider.dart';
import '../../../features/temple_context/domain/temple_context_state.dart';

class DharmaMediaRepository extends BaseRepository {
  final SupabaseClient _supabase;

  DharmaMediaRepository(this._supabase);

  Future<List<DharmaMediaModel>> getAudioTracks({String? tenantId, int limit = 20}) async {
    return handleError(() async {
      // Logic Production: 
      // 1. Chế độ "Toàn hệ sinh thái" (tenantId == null): Lấy TẤT CẢ các bài pháp âm từ mọi chùa (Tổng hợp)
      // 2. Chế độ "Không gian Chùa" (tenantId != null): 
      //    Chỉ lấy (Của riêng chùa đó) + (Của hệ sinh thái dùng chung) + (Bài được chia sẻ qua published_to)
      
      var query = _supabase.from('media').select('*').eq('type', 'audio');
      
      if (tenantId != null) {
        // Lọc kỹ cho không gian riêng
        query = query.or('tenant_id.is.null,tenant_id.eq.$tenantId,published_to.cs.{"$tenantId"}');
      } 
      // Nếu tenantId == null -> Không thêm filter tenant_id để lấy toàn bộ (Tổng hợp)
      
      final response = await query.order('created_at', ascending: false).limit(limit);
      
      final List<dynamic> data = response as List<dynamic>;
      return data.map((json) => DharmaMediaModel.fromJson(json)).toList();
    });
  }
}

final dharmaMediaRepositoryProvider = Provider<DharmaMediaRepository>((ref) {
  return DharmaMediaRepository(Supabase.instance.client);
});

final dharmaAudioListProvider = FutureProvider<List<DharmaMediaModel>>((ref) async {
  final contextState = ref.watch(templeContextProvider);
  final repo = ref.watch(dharmaMediaRepositoryProvider);
  
  // If in allTemples mode, tenantId is null and we fetch global audio
  final String? tenantId = contextState.mode == ContextMode.allTemples ? null : contextState.tenantId;
  
  return repo.getAudioTracks(tenantId: tenantId);
});
