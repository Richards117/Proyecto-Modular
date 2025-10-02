import 'package:flutter_application_votacion/domian/entities/coments.dart';

abstract class ComentarioRepository {
  Future<List<Comentario>> getComentarios(String debateId);
  Future<void> agregarComentario(Comentario comentario);
  Future<void> eliminarComentario(int id);
  Future<void> editarComentario(int id, String nuevoContenido);

  /// 🔥 Nuevo método para suscripción Realtime
  Stream<Comentario> subscribeToComentarios(String debateId);
}
