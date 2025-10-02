import 'package:flutter_application_votacion/data/data_sources/votation_remote_data_source.dart';
import 'package:flutter_application_votacion/data/models/candidate_models.dart';
import 'package:flutter_application_votacion/data/repositories/votation_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabaseProvider = Provider((ref) => Supabase.instance.client);

final votacionRemoteDataSourceProvider = Provider(
  (ref) => VotacionRemoteDataSource(ref.read(supabaseProvider)),
);

final votacionRepositoryProvider = Provider(
  (ref) => VotacionRepositoryImpl(ref.read(votacionRemoteDataSourceProvider)),
);

final candidatosProvider = FutureProvider<List<CandidatoModel>>((ref) async {
  final repository = ref.read(votacionRepositoryProvider);
  return repository.getCandidatos();
});
