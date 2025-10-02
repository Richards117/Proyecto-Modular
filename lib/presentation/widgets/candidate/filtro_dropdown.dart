import 'package:flutter/material.dart';

class FiltroDropdown extends StatelessWidget {
  final String? valorSeleccionado;
  final List<String> opciones;
  final String hint;
  final Icon icono;
  final ValueChanged<String?> onChanged;

  const FiltroDropdown({
    super.key,
    required this.valorSeleccionado,
    required this.opciones,
    required this.hint,
    required this.icono,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        child: DropdownButtonFormField<String>(
          isExpanded: true,
          borderRadius: BorderRadius.circular(14),
          value: valorSeleccionado,
          decoration: InputDecoration(
            prefixIcon: icono,
            border: InputBorder.none,
            hintText: hint,
            hintStyle: TextStyle(
              color: Colors.grey.shade500,
              fontSize: 15,
            ),
          ),
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
          dropdownColor: Colors.white,
          icon: const Icon(Icons.arrow_drop_down, color: Colors.blueGrey),
          selectedItemBuilder: (context) => opciones
              .map((op) => Text(op, overflow: TextOverflow.ellipsis))
              .toList(),
          items: List.generate(opciones.length, (index) {
            final op = opciones[index];
            return DropdownMenuItem(
              value: op,
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.list_alt,
                        size: 20,
                        color: Colors.blueGrey,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          op,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  if (index < opciones.length - 1) ...[
                    const SizedBox(height: 8),
                    Divider(
                      color: Colors.grey.shade300,
                      height: 1,
                      thickness: 0.8,
                      indent: 30,
                      endIndent: 10,
                    ),
                  ]
                ],
              ),
            );
          }),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
