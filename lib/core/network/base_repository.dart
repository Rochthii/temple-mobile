import 'package:supabase_flutter/supabase_flutter.dart';

abstract class BaseRepository {
  final SupabaseClient supabase = Supabase.instance.client;

  // Common error handling wrapper
  Future<T> handleError<T>(Future<T> Function() call) async {
    try {
      return await call();
    } catch (e) {
      // Log error, throw specific exceptions
      rethrow;
    }
  }
}
