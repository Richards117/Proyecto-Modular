import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

 class SupabaseService {
  Future<List<Map<String, dynamic>>> fetchResultados() async {
    try {
      final response =
          await Supabase.instance.client.from('vista_resultados').select();

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Error al cargar resultados: $e');
    }
  }
}

 final resultadosProvider =
    FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final service = SupabaseService();
  return await service.fetchResultados();
});

 Map<String, List<Map<String, dynamic>>> agruparPorCargo(
    List<Map<String, dynamic>> resultados) {
  final Map<String, List<Map<String, dynamic>>> agrupado = {};
  for (final voto in resultados) {
    final cargo = voto['cargo'] ?? 'Otro';
    agrupado.putIfAbsent(cargo, () => []).add(voto);
  }
  return agrupado;
}

 final resultadosAgrupadosProvider =
    Provider<AsyncValue<Map<String, List<Map<String, dynamic>>>>>((ref) {
  final resultadosAsync = ref.watch(resultadosProvider);

  return resultadosAsync.whenData(agruparPorCargo);
});

 enum OrdenResultados {
  masVotados,
  menosVotados,
  alfabeticoCandidato,
}

 final ordenResultadosProvider = StateProvider<OrdenResultados>((ref) {
  return OrdenResultados.masVotados;
});

 List<Map<String, dynamic>> ordenarVotos(
  List<Map<String, dynamic>> votos,
  OrdenResultados orden,
) {
  final votosOrdenados = [...votos];

  switch (orden) {
    case OrdenResultados.masVotados:
      votosOrdenados.sort(
        (a, b) => (b['total_votos'] ?? 0).compareTo(a['total_votos'] ?? 0),
      );
      break;

    case OrdenResultados.menosVotados:
      votosOrdenados.sort(
        (a, b) => (a['total_votos'] ?? 0).compareTo(b['total_votos'] ?? 0),
      );
      break;

    case OrdenResultados.alfabeticoCandidato:
      votosOrdenados.sort(
        (a, b) => (a['candidato'] ?? '').toString().compareTo(
              (b['candidato'] ?? '').toString(),
            ),
      );
      break;
  }

  return votosOrdenados;
}
