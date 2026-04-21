/// COPYRIGHT (C) 2026 - DHARMA CHAT RAG ENGINE
/// JOINT INTELLECTUAL PROPERTY:
/// - Technical Implementation: SaaS Project Owner
/// - Content curation & Academic metadata: Content Lead
/// 
/// This module handles the mobile-specific RAG integration and streaming data
/// for the standalone AI RAG system.
library;


import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/env.dart';
import '../../../core/network/base_repository.dart';

// Đơn giản hóa model chat
class ChatMessageModel {
  final String id;
  final String sessionId;
  final bool isUser;
  final String content;
  final List<String> citations;

  ChatMessageModel({
    required this.id,
    required this.sessionId,
    required this.isUser,
    required this.content,
    required this.citations,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      id: json['id'] ?? '',
      sessionId: json['session_id'] ?? '',
      isUser: json['is_user'] ?? false,
      content: json['content'] ?? '',
      citations: List<String>.from(json['citations'] ?? []),
    );
  }
}

// Lớp hỗ trợ SSE Chunk Response
class ChatStreamChunk {
  final String textDelta;
  final List<String>? citations;
  final bool isDone;
  
  ChatStreamChunk({
    required this.textDelta, 
    this.citations,
    this.isDone = false,
  });
}

class AiChatRepository extends BaseRepository {
  final SupabaseClient _supabase;

  AiChatRepository(this._supabase);

  // Tạo hoặc lấy session
  Future<String> getOrCreateSession() async {
    return handleError(() async {
      final user = _supabase.auth.currentUser;
      if (user == null) throw Exception("Vui lòng đăng nhập để dùng tính năng này.");

      final currentSessions = await _supabase
          .from('chat_sessions')
          .select('id')
          .eq('user_id', user.id)
          .order('created_at', ascending: false)
          .limit(1);

      if (currentSessions.isNotEmpty) return currentSessions.first['id'] as String;

      final response = await _supabase.from('chat_sessions').insert({
        'user_id': user.id,
        'title': 'Vấn đáp Chánh Niệm',
      }).select('id').single();

      return response['id'] as String;
    });
  }

  // Stream messages (lịch sử lưu vĩnh viễn)
  Stream<List<ChatMessageModel>> watchMessages(String sessionId) {
    return _supabase
        .from('chat_messages')
        .stream(primaryKey: ['id'])
        .eq('session_id', sessionId)
        .order('created_at', ascending: true)
        .map((data) => data.map((e) => ChatMessageModel.fromJson(e)).toList());
  }

  // Gửi tin nhắn và bắt luồng SSE
  Stream<ChatStreamChunk> sendMessageStream(String sessionId, String content) async* {
    final user = _supabase.auth.currentUser;
    if (user == null) throw Exception("Unauthorized");

    final url = Uri.parse('${Env.supabaseUrl}/functions/v1/rag-chat');
    
    final request = http.Request('POST', url)
      ..headers.addAll({
        'Authorization': 'Bearer ${Env.supabaseAnonKey}',
        'Content-Type': 'application/json',
      })
      ..body = jsonEncode({
        'session_id': sessionId,
        'query': content,
      });

    final response = await http.Client().send(request);

    if (response.statusCode != 200) {
      throw Exception('Lỗi kết nối AI: ${response.statusCode}');
    }

    await for (final line in response.stream
        .transform(utf8.decoder)
        .transform(const LineSplitter())) {
      if (line.startsWith('data: ')) {
        final dataStr = line.substring(6);
        if (dataStr == '[DONE]') {
          yield ChatStreamChunk(textDelta: '', isDone: true);
          break;
        }

        try {
          final data = jsonDecode(dataStr);
          yield ChatStreamChunk(
            textDelta: data['text'] ?? '',
            citations: List<String>.from(data['citations'] ?? []),
          );
        } catch (e) {
          // Bỏ qua nếu dòng không phải JSON hợp lệ
        }
      }
    }
  }
}

final aiChatRepositoryProvider = Provider<AiChatRepository>((ref) {
  return AiChatRepository(Supabase.instance.client);
});

final currentChatSessionIdProvider = FutureProvider<String>((ref) async {
  return ref.watch(aiChatRepositoryProvider).getOrCreateSession();
});
