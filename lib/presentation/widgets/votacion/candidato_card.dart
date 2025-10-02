import 'package:flutter/material.dart';

class CandidatoCard extends StatelessWidget {
  final String candidato;
  final String partido;
  final String entidad;
  final int totalVotos;

  const CandidatoCard({
    super.key,
    required this.candidato,
    required this.partido,
    required this.entidad,
    required this.totalVotos,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      color: Colors.blue.shade50,
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.blue.shade200,
                  radius: 28,
                  child: const Icon(Icons.how_to_vote, color: Colors.white),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        candidato,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        partido,
                        style: TextStyle(
                            fontSize: 14, color: Colors.grey.shade600),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.location_on,
                        color: Colors.blue.shade500, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      entidad,
                      style:
                          const TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                  ],
                ),
                Text(
                  'Votos: $totalVotos',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade700,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
