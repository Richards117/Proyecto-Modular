// providers/candidate_provider.dart
import 'package:flutter_application_votacion/presentation/providers/candidate/candidate_provider.dart';
import 'package:flutter_application_votacion/presentation/providers/tipo_eleccion_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_votacion/data/models/candidate_models.dart';

final candidatosProvider = FutureProvider<List<CandidatoModel>>((ref) async {
  final repo = ref.watch(votacionRepositoryProvider);
  final tipoEleccion = ref.watch(tipoEleccionProvider);
  return await repo.getCandidatosPorTipo(tipoEleccion);
});
