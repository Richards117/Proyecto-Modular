import 'package:flutter_application_votacion/data/models/debates_models/debate_models.dart';
import 'package:flutter_application_votacion/domian/entities/debate.dart';

class DebateMapper {
  // Convierte entidad a modelo
  static DebateModel entityToModel(Debate debate) => DebateModel(
        id: debate.id,
        title: debate.title,
        author: debate.author,
        description: debate.description,
        commentsCount: debate.commentsCount,
        createdAt: debate.createdAt,
        imageUrl: debate.imageUrl,
        categoria: debate.categoria,
      );
  // Convierte modelo a entidad (usar en domian)
  static Debate modelToEntity(DebateModel model) => Debate(
        id: model.id,
        title: model.title,
        author: model.author,
        description: model.description,
        commentsCount: model.commentsCount,
        createdAt: model.createdAt,
        imageUrl: model.imageUrl,
        categoria: model.categoria,
      );
}
