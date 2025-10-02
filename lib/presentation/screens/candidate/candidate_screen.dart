import 'package:flutter/material.dart';
import 'package:flutter_application_votacion/data/models/candidate_models.dart';
import 'package:flutter_application_votacion/presentation/screens/votation/PerfilUsuarioScreen.dart';

class CandidatoScreen extends StatefulWidget {
  final CandidatoModel candidato;
  const CandidatoScreen({super.key, required this.candidato});

  @override
  CandidatoScreenState createState() => CandidatoScreenState();
}

class CandidatoScreenState extends State<CandidatoScreen> {
   bool mostrarCorreo = false;
  final Map<int, bool> mostrarBiografia = {};
  final Map<int, bool> mostrarTrayectoria = {};
  final Map<int, bool> mostrarPropuestas = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white, size: 28),
        title: const Text('Información del Candidato'),
        centerTitle: true,
        backgroundColor: Colors.blue.shade700,
        elevation: 4,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const PerfilUsuarioScreen(),
            ),
          );
        },
        label: const Text('Votar'),
        icon: const Icon(Icons.how_to_vote),
        backgroundColor: Colors.orangeAccent,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade50, Colors.indigo.shade100],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 60,
                backgroundColor: Colors.grey.shade200,
                child: const FadeInImage(
                  placeholder: AssetImage('assets/giphy.gif'),
                  image: AssetImage('assets/candidatos.png'),
                ),
              ),
              const SizedBox(height: 12),
              _buildNombreCandidato(),
              const SizedBox(height: 20),
              _buildGeneralInfoCard(),
              const SizedBox(height: 16),
              _buildContactoCard(),
              const SizedBox(height: 16),
              _buildTrayectoriaProfesionalCard(),
              const SizedBox(height: 16),
              _buildTrayectoriaPoliticaCard(),
              const SizedBox(height: 16),
              _buildPropuestasCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNombreCandidato() {
    return Column(
      children: [
        const Text(
          "Candidato:",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black,
            shadows: [
              Shadow(offset: Offset(1, 1), blurRadius: 2, color: Colors.black26)
            ],
          ),
        ),
        Card(
          elevation: 9,
          color: Colors.grey.shade200,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: Text(
              widget.candidato.nombreCandidato,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.indigo,
                shadows: [
                  Shadow(
                      offset: Offset(1, 1),
                      blurRadius: 2,
                      color: Colors.black26)
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGeneralInfoCard() {
    return _buildSectionCard(
      title: 'Información General',
      gradientColors: [Colors.indigo.shade400, Colors.blue.shade300],
      child: Wrap(
        spacing: 10,
        runSpacing: 8,
        children: [
          _buildBadge(Icons.flag, 'Partido: ${widget.candidato.partido}'),
          _buildBadge(Icons.people, widget.candidato.sexo),
          _buildBadge(Icons.school_outlined,
              'Estudios: ${widget.candidato.escolaridad}'),
          _buildBadge(Icons.access_time, '${widget.candidato.edad} años'),
          _buildBadge(
              Icons.maps_ugc_rounded, 'Entidad: ${widget.candidato.entidad}'),
        ],
      ),
    );
  }

  Widget _buildContactoCard() {
    return _buildSectionCard(
      title: 'Contacto',
      gradientColors: [Colors.red.shade300, Colors.red.shade200],
      child: Column(
        children: [
          _buildToggleSection(
            icon: Icons.email_outlined,
            title: 'Correo Electrónico',
            content: widget.candidato.correoElectronico.isNotEmpty
                ? widget.candidato.correoElectronico
                : 'Información no disponible',
            mostrar: mostrarCorreo,
            onPressed: () {
              setState(() => mostrarCorreo = !mostrarCorreo);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTrayectoriaProfesionalCard() {
    final puestosVistos = <String>{};
    final historiaFiltrada = widget.candidato.historiaProfesional.where((h) {
      if (puestosVistos.contains(h.puesto)) return false;
      puestosVistos.add(h.puesto);
      return true;
    }).toList();

    return _buildSectionCard(
      title: 'Trayectoria Profesional',
      gradientColors: [Colors.green.shade300, Colors.blue.shade200],
      child: Column(
        children: historiaFiltrada.isNotEmpty
            ? historiaFiltrada.asMap().entries.map((entry) {
                int index = entry.key;
                HistoriaProfesionalModel h = entry.value;
                mostrarBiografia[index] ??= false;
                return _buildToggleSection(
                  icon: Icons.work_outline,
                  title: 'Trayectoria',
                  content: '${h.institucion} | ${h.periodo}',
                  mostrar: mostrarBiografia[index]!,
                  onPressed: () {
                    setState(() {
                      mostrarBiografia[index] = !mostrarBiografia[index]!;
                    });
                  },
                );
              }).toList()
            : [const Text('No hay trayectoria profesional disponible')],
      ),
    );
  }

  Widget _buildTrayectoriaPoliticaCard() {
    final cargosVistos = <String>{};
    final trayectoriaFiltrada = widget.candidato.trayectoriaPolitica.where((t) {
      if (cargosVistos.contains(t.cargo)) return false;
      cargosVistos.add(t.cargo);
      return true;
    }).toList();

    return _buildSectionCard(
      title: 'Trayectoria Política',
      gradientColors: [Colors.green.shade200, Colors.green.shade50],
      child: Column(
        children: trayectoriaFiltrada.isNotEmpty
            ? trayectoriaFiltrada.asMap().entries.map((entry) {
                int index = entry.key;
                TrayectoriaPoliticaModel t = entry.value;
                mostrarTrayectoria[index] ??= false;
                return _buildToggleSection(
                  icon: Icons.timeline,
                  title: '${t.cargo} (${t.partido})',
                  content: t.periodo,
                  mostrar: mostrarTrayectoria[index]!,
                  onPressed: () {
                    setState(() {
                      mostrarTrayectoria[index] = !mostrarTrayectoria[index]!;
                    });
                  },
                );
              }).toList()
            : [const Text('No hay trayectoria política disponible')],
      ),
    );
  }

  Widget _buildPropuestasCard() {
     final titulosVistos = <String>{};
    final propuestasFiltradas = widget.candidato.propuestas.where((p) {
      if (titulosVistos.contains(p.titulo)) return false;
      titulosVistos.add(p.titulo);
      return true;
    }).toList();

    return _buildSectionCard(
      title: 'Propuestas',
      gradientColors: [Colors.indigo.shade300, Colors.indigo.shade200],
      child: Column(
        children: propuestasFiltradas.isNotEmpty
            ? propuestasFiltradas.asMap().entries.map((entry) {
                int index = entry.key;
                PropuestaModel p = entry.value;
                mostrarPropuestas[index] ??= false;
                return _buildToggleSection(
                  icon: Icons.handshake_rounded,
                  title: p.titulo,
                  content: p.descripcion.isNotEmpty
                      ? p.descripcion
                      : 'Información no disponible',
                  mostrar: mostrarPropuestas[index]!,
                  onPressed: () {
                    setState(() {
                      mostrarPropuestas[index] = !mostrarPropuestas[index]!;
                    });
                  },
                );
              }).toList()
            : [const Text('No hay propuestas disponibles')],
      ),
    );
  }

 
  Widget _buildSectionCard({
    required String title,
    required List<Color> gradientColors,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(2, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: [
                  Shadow(
                      offset: Offset(1, 1),
                      blurRadius: 2,
                      color: Colors.black26)
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }

  Widget _buildBadge(IconData icon, String text) {
    return Chip(
      avatar: Icon(icon, size: 18, color: Colors.white),
      label: Text(
        text,
        style:
            const TextStyle(color: Colors.white, fontWeight: FontWeight.w900),
      ),
      backgroundColor: Colors.indigo,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    );
  }

  Widget _buildToggleSection({
    required IconData icon,
    required String title,
    required String content,
    required bool mostrar,
    required VoidCallback onPressed,
  }) {
    return Card(
      color: Colors.white.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 9,
      child: ExpansionTile(
        leading: Icon(icon, color: Colors.white),
        title: Text(
          title,
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        collapsedBackgroundColor: Colors.transparent,
        onExpansionChanged: (_) => onPressed(),
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              content,
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
