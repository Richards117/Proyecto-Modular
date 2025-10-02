import 'package:supabase_flutter/supabase_flutter.dart';

abstract class AuthRepository {
  Future<void> signUp(String email, String password, String displayName);
  Future<void> signIn(String email, String password);
  Future<void> signOut();
  User? getCurrentUser();

  Future<String?> getDisplayName();

  Future<String?> getUserRole() async => null;
}
