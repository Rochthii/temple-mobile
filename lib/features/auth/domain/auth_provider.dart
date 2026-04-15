import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../data/auth_repository.dart';

final authProvider = AsyncNotifierProvider<AuthNotifier, User?>(() {
  return AuthNotifier();
});

class AuthNotifier extends AsyncNotifier<User?> {
  late final AuthRepository _repository;

  @override
  Future<User?> build() async {
    _repository = AuthRepository();
    
    // Listen to auth changes and update state
    _repository.authStateChanges.listen((data) {
      state = AsyncValue.data(data.session?.user);
    });

    return _repository.currentUser;
  }

  Future<void> signIn(String identifier, String password) async {
    try {
      await _repository.signIn(identifier: identifier, password: password);
      // State sẽ được cập nhật thông qua stream listener ở build()
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  /// Đăng ký tài khoản mới.
  /// KHÔNG set state=loading() ở đây vì sẽ trigger GoRouter redirect sang /splash
  /// UI loading được quản lý bởi RegisterScreen._isLoading (local state)
  Future<void> signUp({
    required String email,
    required String password,
    required String fullName,
    String? preferredTempleId,
  }) async {
    try {
      await _repository.signUp(
        email: email,
        password: password,
        fullName: fullName,
        preferredTempleId: preferredTempleId,
      );
      // State sẽ được cập nhật qua stream sau khi Supabase xác nhận.
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<void> signOut() async {
    await _repository.signOut();
  }
}

