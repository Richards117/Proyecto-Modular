import 'package:flutter_application_votacion/presentation/controllers/votacion_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabaseServiceProvider = Provider<SupabaseService>((ref) {
  return SupabaseService();
});

final votacionNotifierProvider =
    ChangeNotifierProvider<VotacionNotifier>((ref) {
  final supabaseService = ref.read(supabaseServiceProvider);
  return VotacionNotifier(supabaseService: supabaseService);
});

class SupabaseService {
  final supabase = Supabase.instance.client;

   Future<List<String>> fetchEntidades() async {
    final data = await supabase.from('Votacion').select('ENTIDAD');
    return data.map((e) => e['ENTIDAD'] as String).toSet().toList();
  }

   Future<List<String>> fetchCargos() async {
    final data = await supabase.from('Votacion').select('CARGO');
    return data.map((e) => e['CARGO'] as String).toSet().toList();
  }

   Future<List<String>> fetchPartidosFiltrados({
    required String entidad,
    required String cargo,
  }) async {
    final data = await supabase
        .from('Votacion')
        .select('PARTIDO_COALICION, NOMBRE_CANDIDATO')
        .eq('ENTIDAD', entidad)
        .eq('CARGO', cargo);

    final partidosValidos = data
        .where((e) =>
            (e['NOMBRE_CANDIDATO'] as String?)?.trim().isNotEmpty ?? false)
        .map((e) => e['PARTIDO_COALICION'] as String)
        .toSet()
        .toList();

    return partidosValidos;
  }

   Future<List<String>> fetchCandidatos({
    required String entidad,
    required String partido,
    required String cargo,
  }) async {
    final data = await supabase
        .from('Votacion')
        .select('NOMBRE_CANDIDATO')
        .eq('ENTIDAD', entidad)
        .eq('PARTIDO_COALICION', partido)
        .eq('CARGO', cargo);

    return data
        .map((e) => e['NOMBRE_CANDIDATO'] as String)
        .where((name) => name.trim().isNotEmpty)
        .toList();
  }

   Future<bool> usuarioYaVotoPorCargo(String userId, String cargo) async {
    final data = await supabase
        .from('votos')
        .select()
        .eq('user_id', userId)
        .eq('cargo', cargo)
        .limit(1);
    return data.isNotEmpty;
  }

   Future<void> guardarVoto({
    required String userId,
    required String genero,
    required String entidadUser,
    required String entidadCandidato,
    required String partido,
    required String cargo,
    required String candidato,
    String? edad,
    String? educacion,
    String? ocupacion,
    String? estadoCivil,
    String? temaInteres,
    String? prioridadCandidato,
    String? frecuenciaVoto,
    String? fuenteInformacion,
  }) async {
    if (await usuarioYaVotoPorCargo(userId, cargo)) {
      throw Exception('Ya has votado para este cargo');
    }

    await supabase.from('votos').insert({
      'user_id': userId,
      'genero': genero,
      'entidad_user': entidadUser,
      'entidad': entidadCandidato,
      'partido': partido,
      'cargo': cargo,
      'candidato': candidato,
      'edad': edad,
      'educacion': educacion,
      'ocupacion': ocupacion,
      'estado_civil': estadoCivil,
      'tema_interes': temaInteres,
      'prioridad_candidato': prioridadCandidato,
      'frecuencia_voto': frecuenciaVoto,
      'fuente_informacion': fuenteInformacion,
      'created_at': DateTime.now().toIso8601String(),
    });
  }

   Future<List<String>> fetchEntidadesConCandidatos(String cargo) async {
    final data = await supabase
        .from('Votacion')
        .select('ENTIDAD, NOMBRE_CANDIDATO')
        .eq('CARGO', cargo)
        .neq('NOMBRE_CANDIDATO', '');  

     final entidadesUnicas = data
        .map((e) => e['ENTIDAD'] as String)
        .toSet()  
        .toList();

    return entidadesUnicas;
  }
}
