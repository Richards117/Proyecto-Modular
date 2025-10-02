import 'package:flutter/material.dart';
import 'package:flutter_application_votacion/presentation/controllers/candidato_list_provider.dart';
import 'package:flutter_application_votacion/presentation/widgets/candidate/filtro_dropdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_votacion/data/models/candidate_models.dart';
import 'package:flutter_application_votacion/presentation/providers/candidate/candidato_list_provider.dart';
import 'package:flutter_application_votacion/presentation/widgets/candidate/card_candidate.dart';
import 'package:flutter_application_votacion/presentation/screens/screens.dart';

class CandidatoListScreen extends ConsumerWidget {
  final String cargo;
  final List<CandidatoModel> candidatos;

  const CandidatoListScreen({
    super.key,
    required this.cargo,
    required this.candidatos,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(candidatoListControllerProvider(candidatos));
    final controllerNotifier =
        ref.read(candidatoListControllerProvider(candidatos).notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          cargo,
          style: const TextStyle(
            color: Colors.indigo,
            fontSize: 25,
            fontWeight: FontWeight.w700,
            shadows: [Shadow(blurRadius: 5, color: Colors.white)],
          ),
        ),
        backgroundColor: Colors.blue.shade100,
        iconTheme: const IconThemeData(color: Colors.black87, size: 30),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () {
              guieComparativealert(context);
            },
          ),
          ButtonDelete(controllerNotifier: controllerNotifier),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue.shade100,
              Colors.indigo.shade100,
              Colors.indigo.shade100,
              Colors.blue.shade100,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              FiltroDropdown(
                valorSeleccionado: null,
                opciones: controller.entidades,
                hint: 'Selecciona una entidad',
                icono: Icon(Icons.location_city, color: Colors.indigo.shade600),
                onChanged: controller.seleccionarEntidad,
              ),
              const SizedBox(height: 10),
              FiltroDropdown(
                valorSeleccionado: null,
                opciones: controller.partidos,
                hint: 'Selecciona un partido',
                icono: Icon(Icons.group, color: Colors.indigo.shade600),
                onChanged: controller.seleccionarPartido,
              ),
              const SizedBox(height: 10),

              // Lista de chips arriba
              if (controller.candidatosSeleccionados.isNotEmpty) ...[
                Text(
                  '${controller.candidatosSeleccionados.length} candidatos seleccionados para comparar',
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 80,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: controller.candidatosSeleccionados.length,
                    itemBuilder: (context, index) {
                      final candidato =
                          controller.candidatosSeleccionados[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Chip(
                          label: Text(candidato.nombreCandidato),
                          deleteIcon: const Icon(Icons.close),
                          onDeleted: () => controllerNotifier.toggleSeleccion(
                              candidato, false),
                        ),
                      );
                    },
                  ),
                ),
              ],
              const SizedBox(height: 10),

              Expanded(
                child: controller.candidatosFiltrados.isEmpty
                    ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.search_off,
                                size: 60, color: Colors.grey),
                            SizedBox(height: 10),
                            Text(
                              'No se encontraron candidatos\nque coincidan con la búsqueda.',
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(fontSize: 16, color: Colors.grey),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: controller.candidatosFiltrados.length,
                        itemBuilder: (context, index) {
                          final candidato =
                              controller.candidatosFiltrados[index];
                          final seleccionado = controller
                              .candidatosSeleccionados
                              .contains(candidato);

                          return CardCandidate(
                            candidato: candidato,
                            seleccionado: seleccionado,
                            onSelected: controllerNotifier.toggleSeleccion,
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: controller.candidatosSeleccionados.length >= 2
          ? FloatingActionButton(
              tooltip:
                  'Comparar ${controller.candidatosSeleccionados.length} candidatos',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ComparativeCandidate(
                        candidatos: controller.candidatosSeleccionados),
                  ),
                );
              },
              shape: const CircleBorder(),
              backgroundColor: Colors.blueAccent.shade100,
              child: const Icon(Icons.compare),
            )
          : null,
    );
  }

//Alerta guia de comparacion
  Future<void> guieComparativealert(BuildContext context) {
    return showDialog(
      context: context,
      builder: (_) => AlertDialog(
        titlePadding: EdgeInsets.zero,
        title: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.blue.shade100,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12), topRight: Radius.circular(12)),
          ),
          child: const Row(
            children: [
              Icon(Icons.info, color: Colors.red, size: 36),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  "¿Cómo comparar?",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
        content: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Text(
            "Sigue estos pasos:\n\n"
            "  Selecciona al menos 2 candidatos de diferente Partido tocando el cuadro en la parte derecha de sus tarjetas.\n\n"
            "  Después de seleccionar los candidatos aparecerá el botón de comparar.\n\n"
            " Presiona el botón para ver sus propuestas y comparar fácilmente.",
            style: TextStyle(fontSize: 17, color: Colors.black87, height: 1.4),
            textAlign: TextAlign.left,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              "Entendido",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}

//Buton Delete Opcion in Appbar
class ButtonDelete extends StatelessWidget {
  const ButtonDelete({
    super.key,
    required this.controllerNotifier,
  });

  final CandidatoListProvider controllerNotifier;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Material(
        color: Colors.redAccent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: controllerNotifier.limpiarFiltros,
          child: const Padding(
            padding: EdgeInsets.all(5),
            child: Icon(Icons.clear, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
