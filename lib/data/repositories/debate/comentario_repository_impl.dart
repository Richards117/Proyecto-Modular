import 'package:flutter_application_votacion/data/data_sources/debate/coments_remote_data_source.dart';
import 'package:flutter_application_votacion/data/mappers/coments_debate.dart';
import 'package:flutter_application_votacion/data/models/debates_models/coments_deabte_models.dart';
import 'package:flutter_application_votacion/domian/entities/coments.dart';
import 'package:flutter_application_votacion/domian/repositories/coments.dart';

class ComentarioRepositoryImpl implements ComentarioRepository {
  final ComentariosRemoteDataSource remoteDataSource;

  ComentarioRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<Comentario>> getComentarios(String debateId) async {
    final rawList = await remoteDataSource.getComentarios(debateId);
    final modelList = rawList.map((e) => ComentarioModel.fromJson(e)).toList();
    return modelList.map(ComentarioMapper.modelToEntity).toList();
  }

  @override
  Future<void> agregarComentario(Comentario comentario) async {
    final model = ComentarioMapper.entityToModel(comentario);
    await remoteDataSource.agregarComentario(
      comentario.debateId.toString(),
      model.contenido,
      model.autor,
      comentario.userId,
      parentId: model.parentId,
    );
  }

  @override
  Future<void> eliminarComentario(int id) {
    return remoteDataSource.eliminarComentario(id);
  }

  @override
  Future<void> editarComentario(int id, String nuevoContenido) {
    return remoteDataSource.editarComentario(id, nuevoContenido);
  }

   @override
  Stream<Comentario> subscribeToComentarios(String debateId) {
    return remoteDataSource.subscribeToComentarios(debateId).map((raw) {
      final model = ComentarioModel.fromJson(raw);
      return ComentarioMapper.modelToEntity(model);
    });
  }
}
