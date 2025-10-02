import 'dart:io';

import 'package:flutter_application_votacion/data/data_sources/debate/debate_remote_data_source.dart';
import 'package:flutter_application_votacion/data/mappers/debate_mapper.dart';
import 'package:flutter_application_votacion/domian/entities/debate.dart';
import 'package:flutter_application_votacion/domian/repositories/debate_repositorie.dart';

class DebateRepositoryImpl implements DebateRepository {
  final DebateRemoteDataSource remoteDataSource;

  DebateRepositoryImpl(this.remoteDataSource);

  @override
  Future<Debate> insertDebate(Debate debate) async {
    final model = DebateMapper.entityToModel(debate);
    final newModel = await remoteDataSource.insert(model);
    return DebateMapper.modelToEntity(newModel);
  }

  @override
  Future<List<Debate>> fetchDebates() async {
    final models = await remoteDataSource.fetchAll();
    return models.map((m) => DebateMapper.modelToEntity(m)).toList();
  }

  @override
  Future<String> uploadImage(File file) {
    throw UnimplementedError();
  }
}
