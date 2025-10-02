/*import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_application_votacion/presentation/providers/tipo_eleccion_provider.dart';
import 'package:flutter_application_votacion/presentation/widgets/maps/candidatos_bottomsheet.dart';
import 'package:flutter_application_votacion/services/maps_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EntidadMarkerWidget extends ConsumerWidget {
  final EntidadModel entidad;
  final double size;

  const EntidadMarkerWidget({super.key, required this.entidad, this.size = 45});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return candidatosAsync.when(
      loading: () => const CircularProgressIndicator(), // mientras carga
      error: (err, _) => Text('Error: $err'),
      data: (candidatosEnEstado) {
        final tieneCandidatos = candidatosEnEstado.isNotEmpty;
        final tipoSeleccionado = ref.watch(tipoEleccionProvider);

        return Tooltip(
          decoration: BoxDecoration(
            color: Colors.black87,
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: const TextStyle(color: Colors.white),
          padding: const EdgeInsets.all(8),
          message: entidad.nombre,
          child: GestureDetector(
            onTap: () {
              showModalBottomSheet(
                context: context,
                backgroundColor: Colors.transparent,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                builder: (_) => ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(20)),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      color: Colors.white.withOpacity(0.3),
                      child: tieneCandidatos
                          ? CandidatosBottomSheet(
                              candidatos:
                                  candidatosEnEstado, // ya es List<CandidatoModel>
                              entidad: entidad,
                            )
                          : Center(
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text(
                                  'Actualmente no hay candidatos para "$tipoSeleccionado" en ${entidad.nombre}.',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                    ),
                  ),
                ),
              );
            },
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                gradient: entidad.nombre.toUpperCase() == 'NACIONAL'
                    ? LinearGradient(
                        colors: [
                          Colors.redAccent.shade200,
                          Colors.redAccent.shade700
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : LinearGradient(
                        colors: [
                          Colors.blueAccent.shade200,
                          Colors.blueAccent.shade700
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
              child: const Icon(Icons.place, color: Colors.white, size: 22),
            ),
          ),
        );
      },
    );
  }
}
*/
