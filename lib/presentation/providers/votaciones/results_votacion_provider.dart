import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Servicio que consulta la base de datos Supabase con manejo de errores
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

/// Provider base que obtiene los resultados desde Supabase
final resultadosProvider =
    FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final service = SupabaseService();
  return await service.fetchResultados();
});

/// Función que agrupa los resultados por 'cargo'
Map<String, List<Map<String, dynamic>>> agruparPorCargo(
    List<Map<String, dynamic>> resultados) {
  final Map<String, List<Map<String, dynamic>>> agrupado = {};
  for (final voto in resultados) {
    final cargo = voto['cargo'] ?? 'Otro';
    agrupado.putIfAbsent(cargo, () => []).add(voto);
  }
  return agrupado;
}

/// Provider que agrupa los resultados por 'cargo' usando la función modular
final resultadosAgrupadosProvider =
    Provider<AsyncValue<Map<String, List<Map<String, dynamic>>>>>((ref) {
  final resultadosAsync = ref.watch(resultadosProvider);

  return resultadosAsync.whenData(agruparPorCargo);
});

/// Enum para definir el orden de resultados
enum OrdenResultados {
  masVotados,
  menosVotados,
  alfabeticoCandidato,
}

/// Provider para estado de orden global (opcional)
final ordenResultadosProvider = StateProvider<OrdenResultados>((ref) {
  return OrdenResultados.masVotados;
});

/// Función para ordenar votos según el criterio seleccionado
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
