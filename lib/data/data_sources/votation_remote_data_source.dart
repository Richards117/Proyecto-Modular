import 'package:flutter_application_votacion/data/models/candidate_models.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class VotacionRemoteDataSource {
  final SupabaseClient supabase;

  VotacionRemoteDataSource(this.supabase);

   Future<List<CandidatoModel>> getCandidatos() async {
    try {
      final List<dynamic> response =
          await supabase.from('candidatos').select('''
            *,
            propuestas(*),
            redes_sociales(*),
            historia_profesional(*),
            trayectoria_politica(*),
            cursos(*),
            partidos(nombre),
            tipos_eleccion(nombre)
          ''');

      return response.map((json) => CandidatoModel.fromMap(json)).toList();
    } catch (e) {
      throw Exception('Error al obtener candidatos: $e');
    }
  }

   Future<List<CandidatoModel>> getCandidatosPorTipo(String tipo) async {
    try {
      final List<dynamic> response =
          await supabase.from('candidatos').select('''
            *,
            propuestas(*),
            redes_sociales(*),
            historia_profesional(*),
            trayectoria_politica(*),
            cursos(*),
            partidos(nombre),
            tipos_eleccion(nombre)
          ''').eq('tipo_eleccion_id', await _getTipoEleccionId(tipo));

      return response.map((json) => CandidatoModel.fromMap(json)).toList();
    } catch (e) {
      throw Exception('Error al obtener candidatos por tipo: $e');
    }
  }

   Future<int> _getTipoEleccionId(String nombre) async {
    final List<dynamic> result =
        await supabase.from('tipos_eleccion').select('id').eq('nombre', nombre);

    if (result.isEmpty) {
      throw Exception('Tipo de elección no encontrado: $nombre');
    }

    return result.first['id'] as int;
  }
}
