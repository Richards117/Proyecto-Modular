import 'package:flutter/material.dart';
import 'package:flutter_application_votacion/data/models/candidate_models.dart';
import 'package:flutter_application_votacion/presentation/screens/candidate/candidate_screen.dart';

class CardCandidate extends StatefulWidget {
  final CandidatoModel candidato;
  final Function(CandidatoModel, bool) onSelected;
  final bool seleccionado;

  const CardCandidate({
    super.key,
    required this.candidato,
    required this.onSelected,
    required this.seleccionado,
  });

  @override
  State<CardCandidate> createState() => _CardCandidateState();
}

class _CardCandidateState extends State<CardCandidate> {
  bool _isPressed = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) {
          setState(() => _isPressed = false);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  CandidatoScreen(candidato: widget.candidato),
            ),
          );
        },
        onTapCancel: () => setState(() => _isPressed = false),
        child: AnimatedScale(
          scale: _isPressed ? 0.97 : 1.0,
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOut,
          child: Card(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: widget.seleccionado
                    ? LinearGradient(
                        colors: [
                          Colors.orange.shade400,
                          Colors.orange.shade200
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : LinearGradient(
                        colors: [Colors.blue.shade50, Colors.indigo.shade50],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: widget.seleccionado ? 12 : 8,
                    offset: const Offset(2, 3),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(20),
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
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
                              backgroundColor: Colors.transparent,
                              radius: 30,
                              child: Text(
                                widget.candidato.nombreCandidato[0]
                                    .toUpperCase(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: Text(
                              widget.candidato.nombreCandidato,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                          // Checkbox para seleccionar
                          Checkbox(
                            value: widget.seleccionado,
                            onChanged: (bool? value) {
                              widget.onSelected(widget.candidato, value!);
                            },
                          ),
                        ],
                      ),
                      const Divider(
                        color: Colors.grey,
                        thickness: 0.5,
                        indent: 30,
                        endIndent: 30,
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: [
                          _buildBadge(Icons.group, widget.candidato.partido,
                              Colors.blue),
                          _buildBadge(Icons.location_on_sharp,
                              widget.candidato.entidad, Colors.green),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SizedBox.fromSize(
                            size: const Size(35, 35),
                            child: ClipOval(
                              child: Material(
                                color: Colors.blue.withOpacity(0.2),
                                child: const Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  color: Colors.blueGrey,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBadge(IconData icon, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.85),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.white),
          const SizedBox(width: 4),
          Text(
            text,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
