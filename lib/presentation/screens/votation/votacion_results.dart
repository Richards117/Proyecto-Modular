import 'package:flutter/material.dart';
import 'package:flutter_application_votacion/presentation/providers/votaciones/results_votacion_provider.dart';
import 'package:flutter_application_votacion/presentation/screens/home_screen.dart';
import 'package:flutter_application_votacion/presentation/screens/votation/PerfilUsuarioScreen.dart';
import 'package:flutter_application_votacion/presentation/widgets/votacion/candidato_card.dart';
import 'package:flutter_application_votacion/presentation/widgets/votacion/orden_dropdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';

class ResultadosScreen extends ConsumerStatefulWidget {
  const ResultadosScreen({super.key});

  @override
  ConsumerState<ResultadosScreen> createState() => _ResultadosScreenState();
}

class _ResultadosScreenState extends ConsumerState<ResultadosScreen> {
  final Map<String, OrdenResultados> ordenPorCargo = {};
  final Map<String, String?> entidadSeleccionadaPorCargo = {};
  final Map<String, bool> mostrarTodosPorCargo = {};

  Map<String, double> calcularEstadisticas(List<Map<String, dynamic>> votos) {
    Map<String, int> conteoPartidos = {};
    for (var v in votos) {
      final partido = v['partido_recomendado'] ?? v['partido'] ?? 'Desconocido';
      conteoPartidos[partido] = (conteoPartidos[partido] ?? 0) + 1;
    }
    final total = votos.length;
    return conteoPartidos.map((k, v) => MapEntry(k, (v / total) * 100));
  }

  Widget graficoPartidos(List<Map<String, dynamic>> votos) {
    final stats = calcularEstadisticas(votos);
    if (stats.isEmpty) return const Text("Aún no hay registros");

    final colores = [
      Colors.blueAccent,
      Colors.greenAccent,
      Colors.orangeAccent,
      Colors.redAccent,
      Colors.purpleAccent
    ];

    final barras = stats.entries.map((e) {
      final color =
          colores[stats.keys.toList().indexOf(e.key) % colores.length];
      return BarChartGroupData(
        x: e.key.hashCode,
        barRods: [
          BarChartRodData(
            toY: e.value,
            color: color,
            width: 22,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
        showingTooltipIndicators: [0],
      );
    }).toList();

    return SizedBox(
      height: 250,
      child: BarChart(
        BarChartData(
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final key = stats.keys.firstWhere(
                    (k) => k.hashCode == value.toInt(),
                    orElse: () => '',
                  );
                  return Transform.rotate(
                    angle: -0.7,
                    child: Text(
                      key,
                      style: const TextStyle(
                          fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                  );
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: true),
            ),
          ),
          borderData: FlBorderData(show: false),
          barGroups: barras,
          gridData: FlGridData(show: true, drawHorizontalLine: true),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final resultadosAgrupados = ref.watch(resultadosAgrupadosProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Resultados de Votación',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
            shadows: const [Shadow(blurRadius: 4, color: Colors.black26)],
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue.shade400,
        elevation: 4,
        actions: [
          IconButton(
            icon: const Icon(Icons.how_to_vote_outlined),
            tooltip: 'Inicio Votacion',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PerfilUsuarioScreen(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.home),
            tooltip: 'Inicio',
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
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade50, Colors.indigo.shade50],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: resultadosAgrupados.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(
            child: Text('Error: $error', style: const TextStyle(fontSize: 16)),
          ),
          data: (agrupadoPorCargo) {
            if (agrupadoPorCargo.isEmpty) {
              return const Center(
                child: Text(
                  'Aún no hay votos registrados.',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: agrupadoPorCargo.length,
              itemBuilder: (context, index) {
                final cargo = agrupadoPorCargo.keys.elementAt(index);
                final votosOriginal = agrupadoPorCargo[cargo]!;
                final orden =
                    ordenPorCargo[cargo] ?? OrdenResultados.masVotados;
                final entidadSeleccionada = entidadSeleccionadaPorCargo[cargo];
                final entidades = votosOriginal
                    .map((v) => (v['entidad'] ?? 'NACIONAL').toString())
                    .toSet()
                    .toList();
                final votosFiltrados = entidadSeleccionada == null
                    ? votosOriginal
                    : votosOriginal
                        .where((v) => v['entidad'] == entidadSeleccionada)
                        .toList();
                final votosOrdenados = ordenarVotos(votosFiltrados, orden);
                final mostrarTodos = mostrarTodosPorCargo[cargo] ?? false;
                final votosAMostrar = mostrarTodos
                    ? votosOrdenados
                    : votosOrdenados.take(5).toList();

                return Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.badge, color: Colors.blue.shade700),
                          const SizedBox(width: 8),
                          Text(
                            cargo,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue.shade800,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        color: Colors.white,
                        margin: const EdgeInsets.symmetric(vertical: 12),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Distribución de $cargo",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 16),
                              graficoPartidos(votosFiltrados),
                            ],
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: CustomDropdown<OrdenResultados>(
                              selectedValue: orden,
                              items: OrdenResultados.values,
                              onChanged: (nuevoOrden) {
                                if (nuevoOrden != null) {
                                  setState(() {
                                    ordenPorCargo[cargo] = nuevoOrden;
                                  });
                                }
                              },
                              hint: 'Ordenar resultados',
                              labelBuilder: (orden) {
                                switch (orden) {
                                  case OrdenResultados.masVotados:
                                    return '🔝 Más votados';
                                  case OrdenResultados.menosVotados:
                                    return '⬇️ Menos votados';
                                  case OrdenResultados.alfabeticoCandidato:
                                    return '🔤 A-Z Candidato';
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: CustomDropdown<String?>(
                              selectedValue: entidadSeleccionada,
                              items: entidades,
                              onChanged: (nuevaEntidad) {
                                setState(() {
                                  entidadSeleccionadaPorCargo[cargo] =
                                      nuevaEntidad;
                                });
                              },
                              hint: 'Filtrar por entidad',
                              labelBuilder: (entidad) => entidad ?? 'Todas',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ...votosAMostrar.map(
                        (v) => CandidatoCard(
                          candidato: v['candidato'] ?? 'Desconocido',
                          partido: v['partido'] ?? 'Sin partido',
                          entidad: v['entidad'] ?? 'NACIONAL',
                          totalVotos: v['total_votos'] ?? 0,
                        ),
                      ),
                      if (votosOrdenados.length > 5)
                        Align(
                          alignment: Alignment.centerLeft,
                          child: TextButton.icon(
                            onPressed: () {
                              setState(() {
                                mostrarTodosPorCargo[cargo] = !mostrarTodos;
                              });
                            },
                            icon: Icon(
                              mostrarTodos
                                  ? Icons.expand_less
                                  : Icons.expand_more,
                            ),
                            label: Text(
                                mostrarTodos ? 'Mostrar menos' : 'Mostrar más'),
                          ),
                        ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
