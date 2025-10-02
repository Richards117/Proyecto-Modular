import 'package:flutter/material.dart';
import 'package:flutter_application_votacion/presentation/providers/votaciones/votacion_provider.dart';
import 'package:flutter_application_votacion/presentation/screens/home_screen.dart';
import 'package:flutter_application_votacion/presentation/screens/votation/votacion_results.dart';
import 'package:flutter_application_votacion/presentation/widgets/votacion/dropdown_custom.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class VotacionScreen extends ConsumerStatefulWidget {
  final String recomendacion;
  const VotacionScreen({super.key, required this.recomendacion});

  @override
  ConsumerState<VotacionScreen> createState() => _VotacionScreenState();
}

class _VotacionScreenState extends ConsumerState<VotacionScreen> {
  bool _isSaving = false;

  Future<void> _confirmVote() async {
    final notifier = ref.read(votacionNotifierProvider.notifier);
    final state = ref.read(votacionNotifierProvider);

    if (state.selectedCargo == null ||
        state.selectedPartido == null ||
        state.selectedCandidato == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor completa todos los campos')),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      await notifier.guardarVoto(
        genero: state.selectedGenero!,
        entidadUser: state.selectedEntidadUsuario!,
        entidadCandidatoParam: state.selectedEntidadCandidato ?? 'NACIONAL',
        partido: state.selectedPartido!,
        cargo: state.selectedCargo!,
        candidato: state.selectedCandidato!,
        edad: state.selectedEdad,
        educacion: state.selectedEducacion,
        ocupacion: state.selectedOcupacion,
        estadoCivil: state.selectedEstadoCivil,
        temaInteres: state.temaInteres,
        prioridadCandidato: state.prioridadCandidato,
        frecuenciaVoto: state.frecuenciaVoto,
        fuenteInformacion: state.fuenteInformacion,
      );

      if (mounted) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('¡Gracias por votar!'),
            content:
                const Text('Tu participación ha sido registrada exitosamente.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cerrar'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(votacionNotifierProvider);
    final notifier = ref.read(votacionNotifierProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text('Votación - Recomendación: ${widget.recomendacion}'),
        centerTitle: true,
        backgroundColor: Colors.blue.shade200,
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            tooltip: 'Actualizar resultados',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomeScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            // Banner de recomendación
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.blueAccent.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Recomendación con Modelo de predicción: ${widget.recomendacion}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            // Dropdown de Cargo
            DropdownCustom(
              title: 'Cargo *',
              value: state.selectedCargo,
              options: state.cargos,
              onChanged: (val) async {
                await notifier.setSelectedCargo(val);
              },
            ),

            // Indicador visual si ya votó
            if (state.yaVotoPorCargo)
              Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(vertical: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.error_outline, color: Colors.red.shade700),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Ya has votado para este cargo',
                        style: TextStyle(
                          color: Colors.red.shade700,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            // Dropdown de Entidad Candidato (solo si no es Presidencia)
            if (state.selectedCargo != null &&
                state.selectedCargo != 'PRESIDENCIA DE LA REPÚBLICA')
              DropdownCustom(
                title: 'Entidad Candidato',
                value: state.selectedEntidadCandidato,
                options: state.entidadesCandidato,
                onChanged: (val) async {
                  await notifier.setSelectedEntidadCandidato(val);
                },
              ),

            // Dropdown de Partido (solo si hay partidos filtrados)
            if (state.partidosFiltrados.isNotEmpty)
              DropdownCustom(
                title: 'Partido',
                value: state.selectedPartido,
                options: state.partidosFiltrados,
                onChanged: (val) async {
                  await notifier.setSelectedPartido(val);
                },
              ),

            // Dropdown de Candidato (solo si hay candidatos filtrados)
            if (state.candidatosFiltrados.isNotEmpty)
              DropdownCustom(
                title: 'Candidato',
                value: state.selectedCandidato,
                options: state.candidatosFiltrados,
                onChanged: notifier.setSelectedCandidato,
              ),

            const SizedBox(height: 24),

            // Botón Confirmar voto
            ElevatedButton.icon(
              icon: _isSaving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Icon(Icons.check_box),
              label: Text(_isSaving ? 'Guardando...' : 'Confirmar voto'),
              onPressed:
                  state.yaVotoPorCargo || _isSaving ? null : _confirmVote,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: Colors.blueAccent.shade700,
                foregroundColor: Colors.white,
              ),
            ),

            const SizedBox(height: 12),

            // Botón Ver Resultados
            ElevatedButton.icon(
              icon: const Icon(Icons.bar_chart),
              label: const Text('Ver Resultados de Votación'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ResultadosScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: Colors.green.shade400,
                foregroundColor: Colors.white,
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
