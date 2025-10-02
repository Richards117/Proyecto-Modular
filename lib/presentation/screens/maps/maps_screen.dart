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

 