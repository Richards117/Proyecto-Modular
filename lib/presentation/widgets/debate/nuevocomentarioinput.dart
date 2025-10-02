import 'package:flutter/material.dart';

class NuevoComentarioInput extends StatelessWidget {
  final TextEditingController controller;
  final Future<void> Function(String) onEnviar;

  const NuevoComentarioInput(
      {super.key, required this.controller, required this.onEnviar});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: 'Escribe tu respuesta aquí...',
                filled: true,
                fillColor: Colors.grey.shade100,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(35),
                    borderSide: BorderSide.none),
              ),
              maxLines: null,
            ),
          ),
          const SizedBox(width: 6),
          CircleAvatar(
            backgroundColor: Colors.blueAccent,
            radius: 25,
            child: IconButton(
              icon: const Icon(Icons.send_rounded, color: Colors.white),
              onPressed: () => onEnviar(controller.text),
            ),
          ),
        ],
      ),
    );
  }
}
