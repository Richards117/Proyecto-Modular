import 'package:flutter/material.dart';

class DropdownCustom extends StatelessWidget {
  final String title;
  final String? value;
  final List<String> options;
  final ValueChanged<String?> onChanged;
  final bool enabled;

  const DropdownCustom({
    super.key,
    required this.title,
    required this.value,
    required this.options,
    required this.onChanged,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.blueAccent,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 8),
          Card(
            elevation: enabled ? 3 : 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: AbsorbPointer(
                absorbing: !enabled,
                child: DropdownButtonFormField<String>(
                  isExpanded: true,
                  borderRadius: BorderRadius.circular(12),
                  value: value,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 16),
                    hintText: 'Seleccione una opción',
                  ),
                  icon: Icon(
                    Icons.arrow_drop_down_circle_outlined,
                    color: enabled ? Colors.blueAccent : Colors.grey,
                    size: 28,
                  ),
                  items: options
                      .map((opt) => DropdownMenuItem(
                            value: opt,
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.list_alt,
                                  size: 20,
                                  color: Colors.blueGrey,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Container(
                                    margin: const EdgeInsets.only(right: 50),
                                    decoration: BoxDecoration(
                                      color: Colors.indigo.shade100,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    padding: const EdgeInsets.only(
                                        right: 50, left: 20),
                                    child: Text(opt,
                                        overflow: TextOverflow.ellipsis),
                                  ),
                                ),
                              ],
                            ),
                          ))
                      .toList(),
                  onChanged: enabled ? onChanged : null,
                  validator: (val) =>
                      val == null ? 'Por favor seleccione una opción' : null,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
