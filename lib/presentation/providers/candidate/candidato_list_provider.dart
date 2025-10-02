import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_votacion/presentation/controllers/candidato_list_provider.dart';
import 'package:flutter_application_votacion/data/models/candidate_models.dart';

final candidatoListControllerProvider =
    ChangeNotifierProvider.family<CandidatoListProvider, List<CandidatoModel>>(
        (ref, candidatos) {
  return CandidatoListProvider(candidatos);
});
