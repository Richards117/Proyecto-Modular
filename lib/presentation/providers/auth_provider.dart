import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/repositories/supabase_auth_repository.dart';
import '../../domian/repositories/auth_repository.dart';

 final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

 final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return SupabaseAuthRepository(client);
});

 class AuthState {
  final bool loading;
  final String? error;
  final bool isAuthenticated;
  final String? role;

  AuthState({
    this.loading = false,
    this.error,
    this.isAuthenticated = false,
    this.role,
  });

  AuthState copyWith({
    bool? loading,
    String? error,
    bool? isAuthenticated,
    String? role,
  }) {
    return AuthState(
      loading: loading ?? this.loading,
      error: error,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      role: role ?? this.role,
    );
  }
}

 class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _authRepository;

  AuthNotifier(this._authRepository) : super(AuthState());

  Future<void> signUp(String email, String password, String displayName) async {
    state = state.copyWith(loading: true, error: null);
    try {
       await _authRepository.signUp(email, password, displayName);
      state =
          state.copyWith(isAuthenticated: false); 
    } catch (e) {
      state = state.copyWith(error: e.toString());
    } finally {
      state = state.copyWith(loading: false);
    }
  }

  Future<void> signIn(String email, String password) async {
    state = state.copyWith(loading: true, error: null);
    try {
      await _authRepository.signIn(email, password);
      final role = await _authRepository.getUserRole();
      state = state.copyWith(isAuthenticated: true, role: role);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isAuthenticated: false);
    } finally {
      state = state.copyWith(loading: false);
    }
  }

  Future<String?> getUserDisplayName() async {
    final user = _authRepository.getCurrentUser();
    if (user == null) return null;

     final response = await Supabase.instance.client
        .from('profiles')
        .select('display_name')  
        .eq('id', user.id)
        .maybeSingle();

    final displayNameFromProfile = response?['display_name'] as String?;
    if (displayNameFromProfile != null && displayNameFromProfile.isNotEmpty) {
      return displayNameFromProfile;
    }

     return user.userMetadata?['display_name'] as String?;
  }

  void signOut() {
    _authRepository.signOut();
   }

  Future<String?> getUserRole() async => _authRepository.getUserRole();
}

 final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return AuthNotifier(repo);
});
