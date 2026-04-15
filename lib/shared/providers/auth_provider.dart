import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Provider cung cấp Supabase Client cho toàn bộ app
final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

// StreamProvider lắng nghe mọi thay đổi trạng thái đăng nhập/đăng xuất
final authStateProvider = StreamProvider<AuthState>((ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return supabase.auth.onAuthStateChange;
});

// Provider tiện ích để lấy User hiện tại
final currentUserProvider = Provider<User?>((ref) {
  // Lấy ra AuthState hiện tại từ stream
  final authState = ref.watch(authStateProvider).value;
  return authState?.session?.user;
});
