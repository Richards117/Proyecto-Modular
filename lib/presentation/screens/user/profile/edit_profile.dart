import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EditProfileDialog extends StatefulWidget {
  const EditProfileDialog({super.key});

  @override
  State<EditProfileDialog> createState() => _EditProfileDialogState();
}

class _EditProfileDialogState extends State<EditProfileDialog> {
  final TextEditingController _displayNameController = TextEditingController();
  final supabase = Supabase.instance.client;
  bool _isLoading = false;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final user = supabase.auth.currentUser;
    if (user != null) {
      final name = user.userMetadata?['display_name'] ?? '';
      setState(() {
        _displayNameController.text = name;
      });
    }
  }

  Future<void> _saveUser() async {
    final newName = _displayNameController.text.trim();

    if (newName.isEmpty || newName.length < 3) {
      setState(() {
        _errorText = "El nombre debe tener al menos 3 caracteres";
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorText = null;
    });

    final response = await supabase.auth.updateUser(
      UserAttributes(data: {'display_name': newName}),
    );

    setState(() => _isLoading = false);

    if (response.user != null) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Perfil actualizado con éxito  '),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error al guardar '),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Editar Perfil",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent.shade700,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _displayNameController,
              decoration: InputDecoration(
                labelText: "Nombre para mostrar",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.person),
                errorText: _errorText,
              ),
            ),
            const SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: _isLoading ? null : () => Navigator.pop(context),
                  child: const Text("Cancelar"),
                ),
                const SizedBox(width: 10),
                ElevatedButton.icon(
                  onPressed: _isLoading ? null : _saveUser,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent.shade200,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  icon: _isLoading
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.save),
                  label: Text(_isLoading ? "Guardando..." : "Guardar"),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
