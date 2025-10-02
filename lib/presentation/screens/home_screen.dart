import 'package:flutter/material.dart';
import 'package:flutter_application_votacion/data/models/candidate_models.dart';
import 'package:flutter_application_votacion/presentation/providers/candidate/candidate_provider.dart';
import 'package:flutter_application_votacion/presentation/providers/tipo_eleccion_provider.dart';
import 'package:flutter_application_votacion/presentation/screens/candidate/candidate_list_screen.dart';
import 'package:flutter_application_votacion/presentation/widgets/carrusel.dart';
import 'package:flutter_application_votacion/presentation/widgets/drawer_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final candidatosAsync = ref.watch(candidatosProvider);
    final tipoSeleccionado = ref.watch(tipoEleccionProvider);

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.indigo),
        title: Text(
          "Candidaturas ($tipoSeleccionado)",
          style: const TextStyle(
            color: Colors.indigo,
            fontSize: 25,
            fontWeight: FontWeight.w700,
            shadows: [Shadow(blurRadius: 5, color: Colors.white)],
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue.shade100,
      ),
      drawer: const DrawerMain(),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.blue.shade100, Colors.indigo.shade100],
              end: Alignment.bottomCenter,
              begin: Alignment.topCenter),
        ),
        child: candidatosAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, _) => Center(child: Text("Error: $err")),
          data: (candidatos) {
            final candidatosFiltrados = candidatos
                .where((c) => c.tipoEleccion == tipoSeleccionado)
                .toList();

             final Map<String, List<CandidatoModel>> candidatosPorCargo = {};
            for (var candidato in candidatosFiltrados) {
              candidatosPorCargo.putIfAbsent(candidato.cargo, () => []);
              candidatosPorCargo[candidato.cargo]!.add(candidato);
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Novedades",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const CarruselImages(),
                  const Divider(),
                  const Text(
                    "Conoce los cargos y sus candidatos",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    "Explora quiénes se postulan para cada cargo público.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                  Text(
                    "Haz Clic en cualquer Tarjeta para conocer mas informacion de cada candito que hay en cada Cargo",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 16,
                        backgroundColor: Colors.indigo.shade100,
                        color: Colors.black54,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  GridView.count(
                    shrinkWrap: true,
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    physics: const NeverScrollableScrollPhysics(),
                    childAspectRatio: 0.9,
                    children: candidatosPorCargo.entries.map((entry) {
                      return _GridCargoCard(
                        cargo: entry.key,
                        candidatos: entry.value,
                      );
                    }).toList(),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _GridCargoCard extends StatefulWidget {
  final String cargo;
  final List<CandidatoModel> candidatos;

  const _GridCargoCard({required this.cargo, required this.candidatos});

  @override
  State<_GridCargoCard> createState() => _GridCargoCardState();
}

class _GridCargoCardState extends State<_GridCargoCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CandidatoListScreen(
              cargo: widget.cargo,
              candidatos: widget.candidatos,
            ),
          ),
        );
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black38, width: 2),
            color: Colors.indigo.shade100,
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 10,
                offset: const Offset(3, 4),
              ),
              BoxShadow(
                color: Colors.blueAccent.withOpacity(0.2),
                blurRadius: 15,
                offset: const Offset(-3, -3),
              ),
            ],
          ),
          padding: const EdgeInsets.all(18),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _isPressed
                      ? Colors.red.withOpacity(0.3)
                      : Colors.indigo.shade400,
                ),
                padding: const EdgeInsets.all(12),
                child: const Icon(
                  Icons.how_to_vote,
                  size: 36,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 14),
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    widget.cargo,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 17,
                      color: Colors.black54,
                      shadows: [
                        Shadow(
                          color: Colors.black26,
                          blurRadius: 4,
                          offset: Offset(1, 1),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.7,
                ),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.indigo.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      '${widget.candidatos.length} postulados',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
