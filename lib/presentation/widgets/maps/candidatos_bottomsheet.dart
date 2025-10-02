// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_application_votacion/data/models/candidate_models.dart';
import 'package:flutter_application_votacion/presentation/screens/candidate/candidate_screen.dart';
import 'package:flutter_application_votacion/presentation/screens/services/maps_service.dart';

class CandidatosBottomSheet extends StatefulWidget {
  final List<CandidatoModel> candidatos;
  final EntidadModel entidad;

  const CandidatosBottomSheet({
    super.key,
    required this.candidatos,
    required this.entidad,
  });

  @override
  State<CandidatosBottomSheet> createState() => _CandidatosBottomSheetState();
}

class _CandidatosBottomSheetState extends State<CandidatosBottomSheet> {
  String searchText = '';

  @override
  Widget build(BuildContext context) {
    final filteredCandidatos = widget.candidatos
        .where((c) =>
            c.nombreCandidato.toLowerCase().contains(searchText.toLowerCase()))
        .toList();

    return Column(
      children: [
        _BottomSheetHeader(entidadNombre: widget.entidad.nombre),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: TextField(
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.blue.shade50,
              hintText: "Buscar candidato...",
              prefixIcon: Icon(Icons.search, color: Colors.blueAccent.shade200),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: Colors.blue.shade200, width: 1.2),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide:
                    const BorderSide(color: Colors.blueAccent, width: 1.5),
              ),
            ),
            onChanged: (value) => setState(() => searchText = value),
          ),
        ),
        const SizedBox(height: 5),
        Expanded(
          child: filteredCandidatos.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.info_outline,
                          size: 50, color: Colors.grey.shade400),
                      const SizedBox(height: 10),
                      Text(
                        widget.candidatos.isEmpty
                            ? 'Actualmente no hay candidatos en ${widget.entidad.nombre}'
                            : 'No se encontraron resultados para "$searchText"',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 16, color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: filteredCandidatos.length,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemBuilder: (context, index) {
                    final candidato = filteredCandidatos[index];
                    return _CandidatoCard(candidato: candidato);
                  },
                ),
        ),
      ],
    );
  }
}

/// Header
class _BottomSheetHeader extends StatelessWidget {
  final String entidadNombre;
  const _BottomSheetHeader({required this.entidadNombre});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.blueAccent.shade100.withOpacity(0.8),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
              child: Text(
                'Candidatos para: $entidadNombre',
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 5),
            child: SizedBox.fromSize(
              size: const Size(40, 40),
              child: ClipOval(
                child: Material(
                  color: Colors.red.shade600,
                  child: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Card candidato
class _CandidatoCard extends StatefulWidget {
  final CandidatoModel candidato;

  const _CandidatoCard({required this.candidato});

  @override
  State<_CandidatoCard> createState() => _CandidatoCardState();
}

class _CandidatoCardState extends State<_CandidatoCard> {
  // Cambiar color según partido
  Color getColorByParty(String partido) {
    switch (partido.toLowerCase()) {
      case 'partido rojo':
        return Colors.redAccent.shade200;
      case 'partido azul':
        return Colors.blueAccent.shade200;
      case 'partido verde':
        return Colors.green.shade300;
      default:
        return Colors.grey.shade300;
    }
  }

  // Tipo de elección
  Widget typeBadge(String tipoEleccion) {
    Color color;
    switch (tipoEleccion.toLowerCase()) {
      case 'federal':
        color = Colors.purpleAccent;
        break;
      case 'local':
        color = Colors.orangeAccent;
        break;
      case 'estudiantil':
        color = Colors.teal;
        break;
      default:
        color = Colors.grey;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration:
          BoxDecoration(color: color, borderRadius: BorderRadius.circular(12)),
      child: Text(
        tipoEleccion,
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
    );
  }

  // Icono según nivel
  Widget locationIcon(String nivel) {
    switch (nivel.toLowerCase()) {
      case 'estado':
        return const Icon(Icons.location_city,
            color: Colors.blueAccent, size: 20);
      case 'municipio':
        return const Icon(Icons.location_on, color: Colors.redAccent, size: 20);
      default:
        return const Icon(Icons.public, color: Colors.green, size: 20);
    }
  }

  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) {
          setState(() => _isPressed = false);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CandidatoScreen(candidato: widget.candidato),
            ),
          );
        },
        onTapCancel: () => setState(() => _isPressed = false),
        child: AnimatedScale(
          scale: _isPressed ? 0.97 : 1.0,
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOut,
          child: Card(
            elevation: 5,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: getColorByParty(widget.candidato.partido),
              ),
              child: Row(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _isPressed
                          ? Colors.red.withOpacity(0.3)
                          : Colors.blueAccent.shade100,
                    ),
                    child: CircleAvatar(
                      radius: 28,
                      backgroundColor: Colors.indigo.shade100,
                      child: Text(
                        widget.candidato.nombreCandidato.isNotEmpty
                            ? widget.candidato.nombreCandidato[0]
                            : '?',
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            typeBadge(widget.candidato.tipoEleccion),
                            const SizedBox(width: 6),
                            locationIcon(widget.candidato.nivel),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.candidato.nombreCandidato,
                          style: const TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 16),
                        ),
                        Text(
                          widget.candidato.partido,
                          style: const TextStyle(
                              fontSize: 14, color: Colors.black54),
                        ),
                        Text(
                          widget.candidato.cargo,
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios,
                      size: 20, color: Colors.white),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
