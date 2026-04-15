import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/network/base_repository.dart';

class AuthRepository extends BaseRepository {
  Future<AuthResponse> signIn({required String identifier, required String password}) async {
    return await handleError(() => supabase.auth.signInWithPassword(
          email: identifier,
          password: password,
        ));
  }

  Future<AuthResponse> signUp({
    required String email,
    required String password,
    required String fullName,
    String? preferredTempleId,
  }) async {
    final response = await handleError(() => supabase.auth.signUp(
          email: email,
          password: password,
          data: {
            'full_name': fullName,
            'preferred_temple_id': ?preferredTempleId,
          },
        ));
    // Sign out ngay sau khi tạo tk để user phải đăng nhập thủ công
    // Tránh auto-login khi Supabase tắt email confirmation
    await supabase.auth.signOut();
    return response;
  }

  Future<void> signOut() async {
    await handleError(() => supabase.auth.signOut());
  }

  User? get currentUser => supabase.auth.currentUser;
  
  Stream<AuthState> get authStateChanges => supabase.auth.onAuthStateChange;
}

