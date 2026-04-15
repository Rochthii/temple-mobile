import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseClient {
  static SupabaseClient get instance => Supabase.instance.client as SupabaseClient;
}

// Extension to help with common queries if needed
extension SupabaseClientX on SupabaseClient {
  // Add common helper methods here
}
