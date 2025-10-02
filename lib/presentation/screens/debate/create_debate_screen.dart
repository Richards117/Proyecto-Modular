// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_application_votacion/presentation/providers/debate/debate_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

enum TipoValidacion { usuario, titulo }

class CreateDebateScreen extends ConsumerStatefulWidget {
  const CreateDebateScreen({super.key});

  @override
  ConsumerState<CreateDebateScreen> createState() => _CreateDebateScreenState();
}

class _CreateDebateScreenState extends ConsumerState<CreateDebateScreen> {
  final List<String> _categorias = [
    'Política',
    'Tecnología',
    'Deportes',
    'Cultura',
    'Educación',
    'General',
  ];

  String? _categoriaSeleccionada;

  final _formKey = GlobalKey<FormState>();
  final _tituloController = TextEditingController();
  final _autorController = TextEditingController();
  final _descripcionController = TextEditingController();

  File? _selectedImageFile;
  String? _uploadedImageUrl;
  bool _isUploadingImage = false;

  final ImagePicker _picker = ImagePicker();

  static const int maxImageSize = 10 * 1024 * 1024; // 10MB
  static const allowedExtensions = ['jpg', 'jpeg', 'png', 'webp'];

  @override
  void initState() {
    super.initState();
    final user = Supabase.instance.client.auth.currentUser;
    if (user != null) {
      _autorController.text = user.userMetadata?['displayName'] ?? '';
    }
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _autorController.dispose();
    _descripcionController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 70);
    if (pickedFile == null) return;

    final file = File(pickedFile.path);
    final bytes = await file.length();

    if (bytes > maxImageSize) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('La imagen no puede superar 10 MB')),
      );
      return;
    }

    final extension = pickedFile.path.split('.').last.toLowerCase();
    if (!allowedExtensions.contains(extension)) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Solo se permiten imágenes JPG, PNG o WEBP')),
      );
      return;
    }

    setState(() => _selectedImageFile = file);
  }

  Future<String?> _uploadImage(File file) async {
    setState(() => _isUploadingImage = true);
    final fileName =
        'debates/${DateTime.now().millisecondsSinceEpoch}.${file.path.split('.').last}';
    try {
      await Supabase.instance.client.storage
          .from('debates')
          .upload(fileName, file);
      return Supabase.instance.client.storage
          .from('debates')
          .getPublicUrl(fileName);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al subir la imagen: $e')),
        );
      }
      return null;
    } finally {
      if (mounted) setState(() => _isUploadingImage = false);
    }
  }

  String? _validarCampo(String? value, String label, {TipoValidacion? tipo}) {
    if (label != 'Descripción (opcional)' && (value == null || value.isEmpty)) {
      return 'Este campo es requerido';
    }
    if (tipo == TipoValidacion.usuario) {
      final regex = RegExp(r'^[a-zA-Z ]{3,20}$');
      if (!regex.hasMatch(value!)) {
        return 'Solo letras, números y guiones bajos (3-20 caracteres)';
      }
    } else if (tipo == TipoValidacion.titulo) {
      final regex = RegExp(r'^[a-zA-Z0-9áéíóúÁÉÍÓÚüÜñÑ\s,.!?-]{3,50}$');
      if (!regex.hasMatch(value!)) {
        return 'Título inválido (3-50 caracteres, solo letras, números y puntuación básica)';
      }
    }
    return null;
  }

  Widget _buildTextField(
      TextEditingController controller, String label, IconData icon,
      {int maxLines = 1, TipoValidacion? tipoValidacion}) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: 'Ingrese $label',
        filled: true,
        fillColor: Colors.grey.shade50,
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.blueAccent.shade700),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
      validator: (value) => _validarCampo(value, label, tipo: tipoValidacion),
    );
  }

  Future<void> _crearDebate() async {
    if (!_formKey.currentState!.validate()) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Por favor completa todos los campos requeridos')),
      );
      return;
    }

    String? imageUrl;
    if (_selectedImageFile != null) {
      imageUrl = await _uploadImage(_selectedImageFile!);
      if (imageUrl == null) return; // Error al subir imagen
      setState(() => _uploadedImageUrl = imageUrl);
    }

    await ref.read(debateProvider.notifier).crearDebateDesdeFormulario(
          context: context,
          formKey: _formKey,
          tituloController: _tituloController,
          autorController: _autorController,
          descripcionController: _descripcionController,
          imageUrl: imageUrl,
          categoria: _categoriaSeleccionada,
        );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(debateProvider).isLoading;

    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            "Crear Debate",
            style: TextStyle(
              color: Colors.black87,
              fontSize: 22,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        backgroundColor: Colors.blue.shade50,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade50, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                _buildTextField(
                    _tituloController, 'Título del debate', Icons.title,
                    tipoValidacion: TipoValidacion.titulo),
                const SizedBox(height: 16),
                _buildTextField(
                    _autorController, 'Nombre usuario', Icons.person,
                    tipoValidacion: TipoValidacion.usuario),
                const SizedBox(height: 16),
                _buildTextField(_descripcionController,
                    'Descripción (opcional)', Icons.description,
                    maxLines: 3),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Categoría',
                    filled: true,
                    fillColor: Colors.grey.shade50,
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                  ),
                  value: _categoriaSeleccionada,
                  items: _categorias
                      .map((cat) =>
                          DropdownMenuItem(value: cat, child: Text(cat)))
                      .toList(),
                  onChanged: (value) =>
                      setState(() => _categoriaSeleccionada = value),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Por favor selecciona una categoría'
                      : null,
                ),
                const SizedBox(height: 16),
                Text(
                  "Imagen representativa (opcional)",
                  style: TextStyle(
                      fontWeight: FontWeight.w600, color: Colors.grey.shade800),
                ),
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  onPressed: _isUploadingImage ? null : _pickImage,
                  icon: const Icon(Icons.image),
                  label: const Text("Seleccionar Imagen"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent.shade200,
                  ),
                ),
                const SizedBox(height: 10),
                if (_isUploadingImage || isLoading)
                  const Center(child: CircularProgressIndicator()),
                if (_uploadedImageUrl != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      _uploadedImageUrl!,
                      height: 150,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        height: 150,
                        color: Colors.grey.shade200,
                        child: const Icon(Icons.broken_image, size: 50),
                      ),
                    ),
                  ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: isLoading
                      ? null
                      : () async {
                          final confirmar = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Confirmar creación'),
                              content: const Text(
                                  '¿Estás seguro que quieres crear este debate?'),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(false),
                                  child: const Text('Cancelar'),
                                ),
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(true),
                                  child: const Text('Confirmar'),
                                ),
                              ],
                            ),
                          );
                          if (confirmar == true) await _crearDebate();
                        },
                  icon: const Icon(Icons.send, color: Colors.white),
                  label: const Text(
                    "Crear Debate",
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent.shade200,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
