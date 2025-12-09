import 'package:supabase_flutter/supabase_flutter.dart';

import 'supabase_service.dart';
import '../models/user_profile.dart';

class AuthService {
  final _client = SupabaseService.client;

  Future<AuthResponse> signIn(String email, String password) {
    return _client.auth.signInWithPassword(email: email, password: password);
  }

  Future<UserProfile?> getCurrentProfile() async {
    final user = _client.auth.currentUser;
    if (user == null) return null;

    final data = await _client
        .from('profiles')
        .select()
        .eq('id', user.id)
        .maybeSingle();

    if (data == null) return null;
    return UserProfile.fromMap(data);
  }
}
