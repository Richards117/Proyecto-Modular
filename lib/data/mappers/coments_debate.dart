import 'package:flutter_application_votacion/data/models/debates_models/coments_deabte_models.dart';
import 'package:flutter_application_votacion/domian/entities/coments.dart';

class ComentarioMapper {
  static ComentarioModel entityToModel(Comentario comentario) {
    return ComentarioModel(
      id: comentario.id,
      contenido: comentario.contenido,
      autor: comentario.autor,
      createdAt: comentario.createdAt.toIso8601String(),
      updatedAt: comentario.updatedAt?.toIso8601String(),
      debateId: comentario.debateId,
      parentId: comentario.parentId,
    );
  }

  static Comentario modelToEntity(ComentarioModel model) {
    return Comentario(
      id: model.id,
      contenido: model.contenido,
      autor: model.autor,
      createdAt: DateTime.parse(model.createdAt),
      updatedAt:
          model.updatedAt != null ? DateTime.parse(model.updatedAt!) : null,
      debateId: model.debateId,
      parentId: model.parentId,
    );
  }
}
