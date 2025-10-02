import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final profileImageProvider =
    StateNotifierProvider<ProfileImageNotifier, String?>(
  (ref) => ProfileImageNotifier(),
);

class ProfileImageNotifier extends StateNotifier<String?> {
  final SupabaseClient _supabase = Supabase.instance.client;

  ProfileImageNotifier() : super(null) {
    loadProfileImage();
  }

  Future<void> loadProfileImage() async {
    final user = _supabase.auth.currentUser;
    final avatarUrl = user?.userMetadata?['avatar_url'] as String?;
    state = avatarUrl;
  }

  Future<void> updateProfileImage(String newUrl) async {
    await _supabase.auth.updateUser(
      UserAttributes(data: {'avatar_url': newUrl}),
    );
    await loadProfileImage();
  }
}
