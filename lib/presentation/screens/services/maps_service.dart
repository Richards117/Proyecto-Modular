import 'package:flutter_application_votacion/data/models/candidate_models.dart';
import 'package:latlong2/latlong.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

const String tablaEntidades = 'Entidades';
const String tablaCandidatos = 'candidatos';

// Modelo de entidad
class EntidadModel {
  final int id;
  final String nombre;
  final LatLng coords;

  EntidadModel({
    required this.id,
    required this.nombre,
    required this.coords,
  });

  factory EntidadModel.fromMap(Map<String, dynamic> map) {
    return EntidadModel(
      id: map['id'],
      nombre: map['nombre'],
      coords: LatLng(map['lat'], map['lng']),
    );
  }
}

// Obtener todas las entidades con coordenadas
Future<List<EntidadModel>> obtenerEntidadesConCoords() async {
  try {
    final response =
        await Supabase.instance.client.from(tablaEntidades).select('*');

    return response
        .map<EntidadModel>((item) => EntidadModel.fromMap(item))
        .toList();
  } catch (e) {
    print('Error al obtener entidades: $e');
    return [];
  }
}

// Obtener candidatos filtrando por nombre de entidad (string)
Future<List<CandidatoModel>> obtenerCandidatosPorEntidad(
    String nombreEntidad, String tipoEleccion) async {
  try {
    final nombre = nombreEntidad.trim();
    final response =
        await Supabase.instance.client.from(tablaCandidatos).select('''
          *,
          propuestas(*),
          redes_sociales(*),
          historia_profesional(*),
          trayectoria_politica(*),
          cursos(*),
          partidos(nombre),
          tipos_eleccion(nombre)
        ''').ilike('entidad', nombre);

    if (response.isNotEmpty) {
      // Filtrar por tipo de elección
      final candidatos =
          response.map((json) => CandidatoModel.fromMap(json)).toList();
      return candidatos.where((c) => c.tipoEleccion == tipoEleccion).toList();
    }
  } catch (e) {
    print('Error al obtener candidatos: $e');
  }
  return [];
}
