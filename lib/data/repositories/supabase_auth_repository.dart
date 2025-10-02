import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domian/repositories/auth_repository.dart';

class SupabaseAuthRepository implements AuthRepository {
  final SupabaseClient _supabase;

  SupabaseAuthRepository(this._supabase);

  @override
  Future<void> signUp(String email, String password, String displayName) async {
    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: {'display_name': displayName},
      );

      final userId = response.user?.id ?? _supabase.auth.currentUser!.id;

      await _supabase.from('profiles').insert({
        'id': userId,
        'display_name': displayName,
        'role': 'user',
      });
    } catch (e) {
      throw Exception("Error al registrar: ${e.toString()}");
    }
  }

  @override
  Future<void> signIn(String email, String password) async {
    try {
      await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      throw Exception("Error al iniciar sesión: ${e.toString()}");
    }
  }

  @override
  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  @override
  User? getCurrentUser() => _supabase.auth.currentUser;

  @override
  Future<String?> getDisplayName() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return null;

    final response = await _supabase
        .from('profiles')
        .select('display_name')
        .eq('id', user.id)
        .maybeSingle();

    return response?['display_name'] as String?;
  }

  @override
  Future<String?> getUserRole() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return null;

    final response = await _supabase
        .from('profiles')
        .select('role')
        .eq('id', user.id)
        .maybeSingle();

    return response?['role'] as String?;
  }
}
