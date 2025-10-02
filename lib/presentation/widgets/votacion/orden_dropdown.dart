import 'package:flutter/material.dart';

class CustomDropdown<T> extends StatelessWidget {
  final T? selectedValue;
  final List<T> items;
  final ValueChanged<T?> onChanged;
  final String hint;
  final String? Function(T) labelBuilder;

  const CustomDropdown({
    super.key,
    required this.selectedValue,
    required this.items,
    required this.onChanged,
    required this.hint,
    required this.labelBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue.shade100.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.indigo.shade300),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: selectedValue,
          isExpanded: true,
          dropdownColor: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12),
          icon: Icon(Icons.arrow_drop_down, color: Colors.blue.shade600),
          style: const TextStyle(fontSize: 16, color: Colors.black87),
          hint: Text(hint),
          items: [
            if (T != String)
              DropdownMenuItem<T>(
                value: null,
                child: Card(
                  color: Colors.blue.shade100,
                  child: Container(
                      margin: const EdgeInsets.all(10),
                      child: const Text('Todas')),
                ),
              ),
            ...items.map(
              (item) => DropdownMenuItem<T>(
                value: item,
                child: Card(
                    color: Colors.blue.shade100,
                    child: Container(
                        margin: const EdgeInsets.all(10),
                        child: Text(labelBuilder(item) ?? ''))),
              ),
            ),
          ],
          onChanged: onChanged,
        ),
      ),
    );
  }
}
