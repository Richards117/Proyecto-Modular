import 'package:flutter/material.dart';

class InfoSection extends StatelessWidget {
  const InfoSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.red, size: 24),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                "Esta es una simulación de votación.",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Icon(Icons.info, color: Colors.blue.shade500, size: 20),
          const SizedBox(width: 8),
          const Expanded(
            child: Text(
              "Cada votante puede emitir un voto por cargo.\n"
              "Si un campo está bloqueado es porque depende de una selección anterior.",
              style: TextStyle(fontSize: 14),
            ),
          ),
        ]),
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.info_outline,
                color: Colors.blueAccent.shade700, size: 20),
            const SizedBox(width: 8),
            const Expanded(
              child: Text(
                "Solo entonces podrás seleccionar la entidad del candidato, partido y finalmente al candidato.",
                style: TextStyle(fontSize: 14),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        const Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.lock, color: Colors.deepOrange, size: 20),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                "Si una opción no aparece o está bloqueada, es porque aún no has completado un paso anterior, "
                "o no hay candidatos disponibles para esa combinación.",
                style: TextStyle(fontSize: 14),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
