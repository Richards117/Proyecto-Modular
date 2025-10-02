import 'package:flutter_application_votacion/data/models/candidate_models.dart';

abstract class VotacionRepository {
  Future<List<CandidatoModel>> getCandidatos();
}
