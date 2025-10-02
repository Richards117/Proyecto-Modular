import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_application_votacion/presentation/screens/services/maps_service.dart';
import 'package:flutter_application_votacion/presentation/widgets/maps/button_maps_widget.dart';
import 'package:flutter_application_votacion/presentation/widgets/maps/candidatos_bottomsheet.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_votacion/presentation/providers/tipo_eleccion_provider.dart';

class MapaEntidadesPage extends ConsumerStatefulWidget {
  const MapaEntidadesPage({super.key});

  @override
  MapaEntidadesPageState createState() => MapaEntidadesPageState();
}

class MapaEntidadesPageState extends ConsumerState<MapaEntidadesPage> {
  double zoom = 6.0;
  MapController mapController = MapController();
  final String mapboxToken =
      'pk.eyJ1IjoicGFyYWxsZWxkdWNrIiwiYSI6ImNseGtwbHphajAzczkyaXB4eG40aHA3eXkifQ.WZedrqvzwybmGa93mi-cdg';

  @override
  Widget build(BuildContext context) {
    final tipoSeleccionado = ref.watch(tipoEleccionProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade300,
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.map_outlined, color: Colors.white),
            SizedBox(width: 8),
            Text('Mapa', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
      body: FutureBuilder<List<EntidadModel>>(
        future: obtenerEntidadesConCoords(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final entidades = snapshot.data ?? [];

          return Stack(
            children: [
              FlutterMap(
                mapController: mapController,
                options: MapOptions(
                  initialCenter: const LatLng(23.6345, -102.5528),
                  initialZoom: zoom,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        "https://api.mapbox.com/styles/v1/mapbox/outdoors-v11/tiles/256/{z}/{x}/{y}@2x?access_token=$mapboxToken",
                    additionalOptions: const {'style_id': 'mapbox/streets-v11'},
                  ),
                  MarkerLayer(
                    markers: entidades.map((entidad) {
                      return Marker(
                        point: entidad.coords,
                        width: 45,
                        height: 45,
                        alignment: Alignment.center,
                        child: Tooltip(
                          decoration: BoxDecoration(
                            color: Colors.black87,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          textStyle: const TextStyle(color: Colors.white),
                          padding: const EdgeInsets.all(8),
                          message: entidad.nombre,
                          child: GestureDetector(
                            onTap: () async {
                              // Filtra por entidad y tipo de elección
                              final candidatos =
                                  await obtenerCandidatosPorEntidad(
                                      entidad.nombre, tipoSeleccionado);

                              if (context.mounted) {
                                showModalBottomSheet(
                                  context: context,
                                  backgroundColor: Colors.transparent,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(20)),
                                  ),
                                  builder: (_) {
                                    return ClipRRect(
                                      borderRadius: const BorderRadius.vertical(
                                          top: Radius.circular(20)),
                                      child: BackdropFilter(
                                        filter: ImageFilter.blur(
                                            sigmaX: 10, sigmaY: 10),
                                        child: Container(
                                          color: Colors.white.withOpacity(0.3),
                                          child: CandidatosBottomSheet(
                                            candidatos: candidatos,
                                            entidad: entidad,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                gradient:
                                    entidad.nombre.toUpperCase() == 'NACIONAL'
                                        ? LinearGradient(
                                            colors: [
                                              Colors.redAccent.shade200,
                                              Colors.redAccent.shade700,
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          )
                                        : LinearGradient(
                                            colors: [
                                              Colors.blueAccent.shade200,
                                              Colors.blueAccent.shade700,
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.5),
                                    blurRadius: 5,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.place,
                                color: Colors.white,
                                size: 22,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
              ButtonMapsWidget(mapController: mapController)
            ],
          );
        },
      ),
    );
  }
}

/*
🗳️ FUNCIONES POLÍTICO-ELECTORALES ÚTILES
🧭 1. Guía del Votante
Muestra qué cargos se eligen en tu zona.

Explica qué hace cada cargo (presidente, diputado, alcalde).

Paso a paso de cómo votar.

Ideal para usuarios jóvenes o primeros votantes.

🧾 2. Verificador de Candidatos
Que el usuario pueda escanear un volante, foto o QR de un candidato y ver si es real.

Usa reconocimiento de texto (OCR) y base de datos de candidatos.

Aplica visión artificial (💡 Módulo 4) y combate la desinformación.

🧠 3. Simulador de Voto
Una urna virtual donde el usuario puede “ensayar” su voto.

Puede usarse para estadísticas anónimas del voto popular dentro de la app.

📊 4. Comparador de Candidatos
Seleccionas dos candidatos y ves:

Propuestas por tema.

Estudios o experiencia.

Opiniones de usuarios.

Como un “versus” político estilo comparador de productos.

🧠 FUNCIONES INTELIGENTES / IA
🧵 5. Análisis de Opinión
Analiza los comentarios de los usuarios sobre cada candidato.

Muestra si la opinión general es positiva, negativa o neutral.

IA + minería de datos (💡 Módulo 4).

🧠 6. Resumen automático de propuestas
Algoritmo que toma textos largos y genera un resumen claro.

Usa servicios como OpenAI o IA local simple.

🧠 7. Recomendación de noticias
Al ver el comportamiento del usuario (a quién ve, qué temas responde en encuestas), le sugiere noticias relacionadas.

Recomendador basado en hábitos (💡 Módulo 4).

📍 FUNCIONES GEOLOCALIZADAS
📍 8. Ubicación de Casillas Electorales
Muestra en el mapa los lugares donde se puede votar.

Opción para simular búsqueda por calle o colonia.

🚨 9. Alertas de eventos o incidentes
“Hoy hay cierre de vialidades por marcha en el centro.”

“Este candidato canceló evento por lluvia.”

Se pueden enviar como push o banners en app.

👤 FUNCIONES SOCIALES
💬 10. Foro por estado o municipio
Usuarios pueden abrir hilos de discusión: “¿Qué opinan de X propuesta?”

Se pueden votar los comentarios o responder en hilo.

📣 11. Sistema de denuncias
Si un usuario ve contenido ofensivo o fake, puede denunciarlo.

Admin lo revisa desde el panel.

📚 EDUCATIVAS Y DE CONTENIDO
📖 12. Historia Electoral
Línea de tiempo interactiva con hechos clave de elecciones pasadas.

Frases célebres de políticos, datos curiosos.

🧠 13. Trivia o Quiz Electoral
Mini juegos para aprender sobre democracia y derechos políticos.

Pueden ser preguntas tipo “Kahoot” o simple múltiple opción.

🧩 FUNCIONES DE PERSONALIZACIÓN
🎨 14. Modo temático
Cambia colores o diseño según el partido o candidato favorito del usuario.

Cambios estéticos, sin sesgo.

🛠️ 15. Perfil de usuario ampliado
Guarda historial de encuestas respondidas, candidatos vistos, noticias leídas.

Puede mostrar “Tu resumen electoral”.

🚀 FUNCIONES "WOW" PARA TU PRESENTACIÓN
📊 16. Dashboard de analítica en vivo (para admin)
Ver tráfico en tiempo real, zonas más activas, resultados de test recomendador.

Puede ser una app web complementaria o integrada con Flutter Web.

🤖 17. Bot con voz (opcional avanzado)
Usa Text-to-Speech (TTS) y Speech-to-Text (STT) para que la app te lea noticias o propuestas.

Ideal para accesibilidad.

*/
