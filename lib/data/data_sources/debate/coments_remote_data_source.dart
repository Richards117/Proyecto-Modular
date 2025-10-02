import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';

class ComentariosRemoteDataSource {
  final SupabaseClient _client;

  ComentariosRemoteDataSource(this._client);

  Future<List<Map<String, dynamic>>> getComentarios(String debateId) async {
    final data = await _client
        .from('comentarios')
        .select()
        .eq('debate_id', debateId)
        .order('created_at');
    return List<Map<String, dynamic>>.from(data);
  }

  Future<void> agregarComentario(
    String debateId,
    String contenido,
    String autor,
    String? userId, {
    int? parentId,
  }) async {
    await _client.from('comentarios').insert({
      'debate_id': debateId,
      'contenido': contenido,
      'autor': autor,
      'user_id': userId,
      'parent_id': parentId,
    });
  }

  Future<void> eliminarComentario(int id) async {
    await _client.from('comentarios').delete().eq('id', id);
  }

  Future<void> editarComentario(int id, String nuevoContenido) async {
    final now = DateTime.now().toIso8601String();
    await _client.from('comentarios').update({
      'contenido': nuevoContenido,
      'updated_at': now,
    }).eq('id', id);
  }

  /// Realtime
  Stream<Map<String, dynamic>> subscribeToComentarios(String debateId) {
    final controller = StreamController<Map<String, dynamic>>();

    final channel = _client.channel('public:comentarios');

    channel
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'comentarios',
          callback: (payload) {
            if (payload.newRecord['debate_id'].toString() == debateId) {
              controller.add(payload.newRecord);
            }
          },
        )
        .onPostgresChanges(
          event: PostgresChangeEvent.update,
          schema: 'public',
          table: 'comentarios',
          callback: (payload) {
            if (payload.newRecord['debate_id'].toString() == debateId) {
              controller.add(payload.newRecord);
            }
          },
        )
        .onPostgresChanges(
          event: PostgresChangeEvent.delete,
          schema: 'public',
          table: 'comentarios',
          callback: (payload) {
            if (payload.oldRecord['debate_id'].toString() == debateId) {
              controller.add(payload.oldRecord);
            }
          },
        )
        .subscribe();

    return controller.stream;
  }
}
