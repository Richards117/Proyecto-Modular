import 'package:flutter/material.dart';
import 'package:flutter_application_votacion/domian/entities/debate.dart';

class DebateCard extends StatelessWidget {
  final Debate debate;
  const DebateCard({super.key, required this.debate});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Text(debate.title,
                  style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent)),
            ),
            const SizedBox(height: 8),
            Text('Iniciado por ${debate.author}',
                style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 12),
            Text(debate.description, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
