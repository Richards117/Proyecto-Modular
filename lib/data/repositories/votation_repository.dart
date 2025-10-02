import 'package:flutter_application_votacion/data/data_sources/votation_remote_data_source.dart';
import 'package:flutter_application_votacion/data/models/candidate_models.dart';
import 'package:flutter_application_votacion/data/repositories/votation_repository_impl.dart';

class VotacionRepositoryImpl implements VotacionRepository {
  final VotacionRemoteDataSource remoteDataSource;

  VotacionRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<CandidatoModel>> getCandidatos() async {
    return await remoteDataSource.getCandidatos();
  }

  Future<List<CandidatoModel>> getCandidatosPorTipo(String tipo) async {
    return await remoteDataSource.getCandidatosPorTipo(tipo);
  }
}
