import 'package:flutter/material.dart';
import 'package:flutter_application_votacion/data/models/candidate_models.dart';

class ComparativeCandidate extends StatefulWidget {
  final List<CandidatoModel> candidatos;

  const ComparativeCandidate({super.key, required this.candidatos});

  @override
  ComparativeCandidateState createState() => ComparativeCandidateState();
}

class ComparativeCandidateState extends State<ComparativeCandidate> {
  PropuestaModel? _selectedProposal;
  late final Map<String, PropuestaModel> _uniquePropuestas;

  @override
  void initState() {
    super.initState();
    final allPropuestas =
        widget.candidatos.expand((c) => c.propuestas).toList();
    _uniquePropuestas = {for (var p in allPropuestas) p.titulo: p};
  }

  PropuestaModel _getPropuestaForCandidato(
      CandidatoModel candidato, String titulo) {
    return candidato.propuestas.firstWhere(
      (p) => p.titulo == titulo,
      orElse: () => PropuestaModel(
        titulo: titulo,
        descripcion: 'No aplica para este candidato (No hay propuesta )',
        categoria: '',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Comparativa de Candidatos"),
        backgroundColor: Colors.blue.shade100,
        iconTheme: const IconThemeData(color: Colors.black87, size: 30),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade100, Colors.blue.shade50],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            _ProposalDropdown(
              uniquePropuestas: _uniquePropuestas,
              selectedProposal: _selectedProposal,
              onChanged: (value) => setState(() => _selectedProposal = value),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _selectedProposal == null
                    ? const Center(
                        child: Text(
                          "Selecciona una propuesta para comparar",
                          style: TextStyle(fontSize: 16, color: Colors.black54),
                        ),
                      )
                    : ListView.builder(
                        key: ValueKey(_selectedProposal!.titulo),
                        itemCount: widget.candidatos.length,
                        itemBuilder: (context, index) {
                          final candidato = widget.candidatos[index];
                          final propuesta = _getPropuestaForCandidato(
                              candidato, _selectedProposal!.titulo);

                          return CandidateCardModern(
                            candidato: candidato,
                            propuesta: propuesta,
                            index: index,
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ------------------- DROPDOWN -------------------

class _ProposalDropdown extends StatelessWidget {
  final Map<String, PropuestaModel> uniquePropuestas;
  final PropuestaModel? selectedProposal;
  final ValueChanged<PropuestaModel?> onChanged;

  const _ProposalDropdown({
    required this.uniquePropuestas,
    required this.selectedProposal,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: DropdownButton<PropuestaModel>(
        hint: const Text('Selecciona una propuesta',
            style: TextStyle(fontSize: 16, color: Colors.black54)),
        value: selectedProposal,
        isExpanded: true,
        onChanged: onChanged,
        dropdownColor: Colors.white,
        borderRadius: BorderRadius.circular(12),
        elevation: 6,
        icon: const Icon(Icons.arrow_drop_down, color: Colors.blueAccent),
        underline: const SizedBox(),
        items: uniquePropuestas.values
            .map(
              (p) => DropdownMenuItem(
                value: p,
                child: Row(
                  children: [
                    const Icon(Icons.star, size: 16, color: Colors.blueAccent),
                    const SizedBox(width: 8),
                    Expanded(
                        child: Text(p.titulo,
                            style: const TextStyle(fontSize: 16))),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

 
class CandidateCardModern extends StatefulWidget {
  final CandidatoModel candidato;
  final PropuestaModel propuesta;
  final int index;

  const CandidateCardModern({
    super.key,
    required this.candidato,
    required this.propuesta,
    required this.index,
  });

  @override
  State<CandidateCardModern> createState() => _CandidateCardModernState();
}

class _CandidateCardModernState extends State<CandidateCardModern> {
  bool _expanded = false;

  void _toggleExpanded() {
    setState(() => _expanded = !_expanded);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: widget.index.isEven ? Colors.white : Colors.blue.shade50,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      shadowColor: Colors.black12,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Text(
              widget.candidato.nombreCandidato,
              style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87),
            ),
            const SizedBox(height: 6),

            // Partido
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.blue.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                widget.candidato.partido,
                style: const TextStyle(fontSize: 12, color: Colors.black87),
              ),
            ),

            const Divider(height: 20, thickness: 1),

            // Contenedor de propuesta
            GestureDetector(
              onTap: _toggleExpanded,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue.shade50, Colors.blue.shade100],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Titulo y categoria
                    Row(
                      children: [
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                              color: Colors.blueAccent,
                              borderRadius: BorderRadius.circular(3)),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            widget.propuesta.titulo,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ),
                        if (widget.propuesta.categoria.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.orange.shade200,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              widget.propuesta.categoria,
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.black),
                            ),
                          ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // Descripcion
                    Text(
                      widget.propuesta.descripcion,
                      style:
                          const TextStyle(fontSize: 14, color: Colors.black87),
                      maxLines: _expanded ? 20 : 4,
                      overflow: TextOverflow.ellipsis,
                    ),

                     Align(
                      alignment: Alignment.centerRight,
                      child: Icon(
                        _expanded
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        color: Colors.blueAccent,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
