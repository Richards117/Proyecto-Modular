import 'package:flutter/material.dart';
import 'package:flutter_application_votacion/presentation/providers/votaciones/votacion_provider.dart';
import 'package:flutter_application_votacion/presentation/screens/votation/votacion_results.dart';
import 'package:flutter_application_votacion/presentation/screens/votation/votation.dart';
import 'package:flutter_application_votacion/presentation/widgets/votacion/dropdown_custom.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_votacion/data/mappers/mapeos.dart';
import 'package:flutter_application_votacion/presentation/screens/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PerfilUsuarioScreen extends ConsumerStatefulWidget {
  const PerfilUsuarioScreen({super.key});

  @override
  ConsumerState<PerfilUsuarioScreen> createState() =>
      _PerfilUsuarioScreenState();
}

class _PerfilUsuarioScreenState extends ConsumerState<PerfilUsuarioScreen> {
  @override
  void initState() {
    super.initState();
    _loadSavedSelections();  
  }

  Future<void> _loadSavedSelections() async {
    final prefs = await SharedPreferences.getInstance();
    final notifier = ref.read(votacionNotifierProvider.notifier);

     notifier.setSelectedGenero(prefs.getString('selectedGenero'));
    notifier.setSelectedEdad(prefs.getString('selectedEdad'));
    notifier.setSelectedEducacion(prefs.getString('selectedEducacion'));
    notifier.setSelectedOcupacion(prefs.getString('selectedOcupacion'));
    notifier.setSelectedEstadoCivil(prefs.getString('selectedEstadoCivil'));
    notifier.setTemaInteres(prefs.getString('temaInteres'));
    notifier.setPrioridadCandidato(prefs.getString('prioridadCandidato'));
    notifier.setFrecuenciaVoto(prefs.getString('frecuenciaVoto'));
    notifier.setFuenteInformacion(prefs.getString('fuenteInformacion'));
    notifier
        .setSelectedEntidadUsuario(prefs.getString('selectedEntidadUsuario'));

     final state = ref.read(votacionNotifierProvider);
    if (state.entidadesUsuario.isEmpty ||
        state.cargos.isEmpty ||
        state.partidosFiltrados.isEmpty) {
      notifier.loadInitialData();
    }
  }

  Future<void> _saveSelections() async {
    final prefs = await SharedPreferences.getInstance();
    final state = ref.read(votacionNotifierProvider);

    await prefs.setString('selectedGenero', state.selectedGenero ?? '');
    await prefs.setString('selectedEdad', state.selectedEdad ?? '');
    await prefs.setString('selectedEducacion', state.selectedEducacion ?? '');
    await prefs.setString('selectedOcupacion', state.selectedOcupacion ?? '');
    await prefs.setString(
        'selectedEstadoCivil', state.selectedEstadoCivil ?? '');
    await prefs.setString('temaInteres', state.temaInteres ?? '');
    await prefs.setString('prioridadCandidato', state.prioridadCandidato ?? '');
    await prefs.setString('frecuenciaVoto', state.frecuenciaVoto ?? '');
    await prefs.setString('fuenteInformacion', state.fuenteInformacion ?? '');
    await prefs.setString(
        'selectedEntidadUsuario', state.selectedEntidadUsuario ?? '');
  }

  Future<String?> _calcularRecomendacion() async {
    final state = ref.read(votacionNotifierProvider);

    final campos = {
      'Género': state.selectedGenero,
      'Edad': state.selectedEdad,
      'Educación': state.selectedEducacion,
      'Ocupación': state.selectedOcupacion,
      'Estado civil': state.selectedEstadoCivil,
      'Tema de interés': state.temaInteres,
      'Prioridad en candidato': state.prioridadCandidato,
      'Frecuencia de votación': state.frecuenciaVoto,
      'Fuente de información': state.fuenteInformacion,
      'Entidad usuario': state.selectedEntidadUsuario,
    };

    for (final entry in campos.entries) {
      if (entry.value == null || entry.value!.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Por favor completa el campo: ${entry.key}')),
        );
        return null;
      }
    }

    try {
      final datos = [
        generoMap[state.selectedGenero] ?? 0,
        edadMap[state.selectedEdad] ?? 0,
        educacionMap[state.selectedEducacion] ?? 0,
        ocupacionMap[state.selectedOcupacion] ?? 0,
        estadoCivilMap[state.selectedEstadoCivil] ?? 0,
        temaInteresMap[state.temaInteres] ?? 0,
        prioridadMap[state.prioridadCandidato] ?? 0,
        frecuenciaMap[state.frecuenciaVoto] ?? 0,
        fuenteInfoMap[state.fuenteInformacion] ?? 0,
        entidadMap[state.selectedEntidadUsuario] ?? 0,
      ];

      final partido = await PrediccionService.predecirPartido(datos);
      return partido;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al calcular recomendación: $e')),
      );
      return null;
    }
  }

  void _irAVotacion(String recomendacion) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => VotacionScreen(recomendacion: recomendacion),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(votacionNotifierProvider);
    final notifier = ref.read(votacionNotifierProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Perfil del Usuario"),
        backgroundColor: Colors.blue.shade200,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ResultadosScreen()),
                );
              },
              icon: Icon(Icons.bar_chart))
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            DropdownCustom(
              title: 'Género',
              value: state.selectedGenero,
              options: const ['Masculino', 'Femenino', 'Otro'],
              onChanged: (val) {
                notifier.setSelectedGenero(val);
                _saveSelections();
              },
            ),
            DropdownCustom(
              title: 'Entidad Usuario',
              value: state.selectedEntidadUsuario,
              options: state.entidadesUsuario.isEmpty
                  ? ['Cargando...']
                  : state.entidadesUsuario,
              onChanged: (val) {
                if (val != null && val != 'Cargando...') {
                  notifier.setSelectedEntidadUsuario(val);
                  _saveSelections();
                }
              },
            ),
            DropdownCustom(
              title: 'Edad',
              value: state.selectedEdad,
              options: const ['18-25', '26-35', '36-45', '46-60', '60+'],
              onChanged: (val) {
                notifier.setSelectedEdad(val);
                _saveSelections();
              },
            ),
            DropdownCustom(
              title: 'Nivel educativo',
              value: state.selectedEducacion,
              options: const [
                'Primaria',
                'Secundaria',
                'Pregrado',
                'Postgrado'
              ],
              onChanged: (val) {
                notifier.setSelectedEducacion(val);
                _saveSelections();
              },
            ),
            DropdownCustom(
              title: 'Ocupación',
              value: state.selectedOcupacion,
              options: const [
                'Estudiante',
                'Empleado',
                'Independiente',
                'Desempleado'
              ],
              onChanged: (val) {
                notifier.setSelectedOcupacion(val);
                _saveSelections();
              },
            ),
            DropdownCustom(
              title: 'Estado civil',
              value: state.selectedEstadoCivil,
              options: const ['Soltero', 'Casado', 'Divorciado', 'Viudo'],
              onChanged: (val) {
                notifier.setSelectedEstadoCivil(val);
                _saveSelections();
              },
            ),
            DropdownCustom(
              title: 'Tema de interés',
              value: state.temaInteres,
              options: const [
                'Economía',
                'Educación',
                'Salud',
                'Medio ambiente',
                'Seguridad'
              ],
              onChanged: (val) {
                notifier.setTemaInteres(val);
                _saveSelections();
              },
            ),
            DropdownCustom(
              title: 'Prioridad en un candidato',
              value: state.prioridadCandidato,
              options: const [
                'Honestidad',
                'Experiencia',
                'Propuestas',
                'Carisma'
              ],
              onChanged: (val) {
                notifier.setPrioridadCandidato(val);
                _saveSelections();
              },
            ),
            DropdownCustom(
              title: 'Frecuencia de votación',
              value: state.frecuenciaVoto,
              options: const ['Siempre voto', 'A veces voto', 'Nunca voto'],
              onChanged: (val) {
                notifier.setFrecuenciaVoto(val);
                _saveSelections();
              },
            ),
            DropdownCustom(
              title: 'Fuente de información política',
              value: state.fuenteInformacion,
              options: const [
                'Televisión',
                'Redes sociales',
                'Periódicos',
                'Amigos/familia'
              ],
              onChanged: (val) {
                notifier.setFuenteInformacion(val);
                _saveSelections();
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async {
                final recomendacion = await _calcularRecomendacion();
                if (recomendacion != null) {
                  _irAVotacion(recomendacion);
                }
              },
              child: const Text("Siguiente: Votación"),
            ),
          ],
        ),
      ),
    );
  }
}
