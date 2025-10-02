import 'dart:async';
import 'package:flutter_application_votacion/data/data_sources/debate/coments_remote_data_source.dart';
import 'package:flutter_application_votacion/data/repositories/debate/comentario_repository_impl.dart';
import 'package:flutter_application_votacion/domian/entities/coments.dart';
import 'package:flutter_application_votacion/domian/repositories/coments.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

 final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

 final comentariosRemoteDataSourceProvider =
    Provider<ComentariosRemoteDataSource>((ref) {
  final client = ref.read(supabaseClientProvider);
  return ComentariosRemoteDataSource(client);
});

 final comentarioRepositoryProvider = Provider<ComentarioRepository>((ref) {
  final remoteDataSource = ref.read(comentariosRemoteDataSourceProvider);
  return ComentarioRepositoryImpl(remoteDataSource);
});

 class ComentarioNotifier extends StateNotifier<AsyncValue<List<Comentario>>> {
  final ComentarioRepository repository;
  StreamSubscription<Comentario>? _comentariosSubscription;

  ComentarioNotifier(this.repository) : super(const AsyncValue.loading());

   Future<void> cargarComentarios(String debateId) async {
    try {
      state = const AsyncValue.loading();
      final comentarios = await repository.getComentarios(debateId);
      state = AsyncValue.data(comentarios);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Agregar comentario
  Future<void> agregarComentario(Comentario comentario) async {
    try {
      await repository.agregarComentario(comentario);
      await cargarComentarios(comentario.debateId.toString());
    } catch (e) {}
  }

  /// Editar comentario
  Future<void> editarComentario(
      int id, String nuevoContenido, String debateId) async {
    try {
      await repository.editarComentario(id, nuevoContenido);
      await cargarComentarios(debateId);
    } catch (e) {}
  }

  /// Eliminar comentario
  Future<void> eliminarComentario(int id, String debateId) async {
    try {
      await repository.eliminarComentario(id);
      await cargarComentarios(debateId);
    } catch (e) {}
  }

   void escucharComentarios(String debateId) {
    _comentariosSubscription?.cancel();

    _comentariosSubscription =
        repository.subscribeToComentarios(debateId).listen((nuevoComentario) {
      final comentariosActuales = state.value ?? [];

      // Actualizar o agregar
      final index =
          comentariosActuales.indexWhere((c) => c.id == nuevoComentario.id);
      if (index >= 0) {
        comentariosActuales[index] = nuevoComentario;
      } else {
        comentariosActuales.add(nuevoComentario);
      }

      state = AsyncValue.data([...comentariosActuales]);
    });
  }

   void cancelarSuscripcion() {
    _comentariosSubscription?.cancel();
    _comentariosSubscription = null;
  }

  @override
  void dispose() {
    cancelarSuscripcion();
    super.dispose();
  }
}

 final comentarioProvider =
    StateNotifierProvider<ComentarioNotifier, AsyncValue<List<Comentario>>>(
  (ref) {
    final repo = ref.read(comentarioRepositoryProvider);
    return ComentarioNotifier(repo);
  },
);
