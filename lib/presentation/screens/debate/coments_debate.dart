import 'package:flutter/material.dart';
import 'package:flutter_application_votacion/domian/entities/coments.dart';
import 'package:flutter_application_votacion/domian/entities/debate.dart';
import 'package:flutter_application_votacion/presentation/providers/auth_provider.dart';
import 'package:flutter_application_votacion/presentation/providers/debate/coments_provider.dart';
import 'package:flutter_application_votacion/presentation/widgets/debate/comentariocard.dart';
import 'package:flutter_application_votacion/presentation/widgets/debate/debatecard.dart';
import 'package:flutter_application_votacion/presentation/widgets/debate/nuevocomentarioinput.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Cosutmdebat extends ConsumerStatefulWidget {
  final Debate debate;
  const Cosutmdebat({super.key, required this.debate});

  @override
  ConsumerState<Cosutmdebat> createState() => _CosutmdebatState();
}

class _CosutmdebatState extends ConsumerState<Cosutmdebat> {
  final TextEditingController _comentarioController = TextEditingController();

  late ComentarioNotifier _comentarioNotifier; // 👈 guardamos el notifier aquí

  final currentUserProvider = Provider<User?>((ref) {
    final authRepository = ref.watch(authRepositoryProvider);
    return authRepository.getCurrentUser();
  });

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      _comentarioNotifier = ref.read(comentarioProvider.notifier);

      // Cargar comentarios iniciales
      _comentarioNotifier.cargarComentarios(widget.debate.id.toString());

      // Activar la escucha en tiempo real
      _comentarioNotifier.escucharComentarios(widget.debate.id.toString());
    });
  }

  @override
  void dispose() {
    _comentarioController.dispose();
    _comentarioNotifier.cancelarSuscripcion(); // 👈 ya no usamos ref
    super.dispose();
  }

  /// Dialogo para editar comentario
  void _mostrarDialogoEdicion(Comentario comentario) {
    final TextEditingController editarController =
        TextEditingController(text: comentario.contenido);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.edit, color: Colors.blueAccent),
            SizedBox(width: 10),
            Text('Editar Comentario'),
          ],
        ),
        content: TextField(
          controller: editarController,
          maxLines: null,
          decoration: const InputDecoration(
            hintText: 'Escribe el nuevo contenido...',
            border: OutlineInputBorder(),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blueAccent),
            ),
            contentPadding: EdgeInsets.all(12),
          ),
        ),
        actions: [
          TextButton.icon(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.close),
            label: const Text('Cancelar'),
            style: TextButton.styleFrom(foregroundColor: Colors.redAccent),
          ),
          ElevatedButton.icon(
            onPressed: () async {
              final nuevoContenido = editarController.text.trim();
              if (nuevoContenido.isEmpty) return;

              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) =>
                    const Center(child: CircularProgressIndicator()),
              );

              await _comentarioNotifier.editarComentario(
                comentario.id,
                nuevoContenido,
                widget.debate.id.toString(),
              );

              Navigator.of(context)
                ..pop()
                ..pop();
            },
            icon: const Icon(Icons.save),
            label: const Text('Guardar'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  /// Dialogo para responder un comentario
  void _mostrarDialogoRespuesta(Comentario padre, String autor) {
    final TextEditingController respuestaController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text("Responder a ${padre.autor}"),
        content: TextField(
          controller: respuestaController,
          maxLines: null,
          decoration: const InputDecoration(
            hintText: 'Escribe tu respuesta...',
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.all(12),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar"),
          ),
          ElevatedButton(
            onPressed: () async {
              final texto = respuestaController.text.trim();
              if (texto.isEmpty) return;

              final respuesta = Comentario(
                id: 0,
                debateId: padre.debateId,
                contenido: texto,
                autor: autor,
                createdAt: DateTime.now(),
                parentId: padre.id,
              );

              await _comentarioNotifier.agregarComentario(respuesta);
              await _comentarioNotifier
                  .cargarComentarios(widget.debate.id.toString());

              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              foregroundColor: Colors.white,
            ),
            child: const Text("Responder"),
          ),
        ],
      ),
    );
  }

  /// Mostrar comentario + respuestas
  Widget buildComentarioConRespuestas(
      Comentario c, Map<int, Comentario> comentariosMap, String displayName) {
    final respuestas =
        comentariosMap.values.where((r) => r.parentId == c.id).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ComentarioCard(
          comentario: c,
          esTuyo: c.autor == displayName,
          debateId: widget.debate.id.toString(),
          onEditar: _mostrarDialogoEdicion,
          ref: ref,
          onResponder: () => _mostrarDialogoRespuesta(c, displayName),
          autorPadre:
              c.parentId != null ? comentariosMap[c.parentId!]?.autor : null,
          textoPadre: c.parentId != null
              ? comentariosMap[c.parentId!]?.contenido
              : null,
        ),
        if (respuestas.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 40, top: 4),
            child: Column(
              children: respuestas
                  .map((r) => buildComentarioConRespuestas(
                      r, comentariosMap, displayName))
                  .toList(),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final comentariosAsync = ref.watch(comentarioProvider);
    final user = ref.watch(currentUserProvider);
    final displayName = user?.userMetadata?['display_name'] ?? "Anónimo";

    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      appBar: AppBar(
        title: const Text("Foro de Debate"),
        backgroundColor: Colors.blueAccent.shade200,
        centerTitle: true,
      ),
      body: Column(
        children: [
          DebateCard(debate: widget.debate),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Respuestas:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Expanded(
            child: comentariosAsync.when(
              data: (comentarios) {
                if (comentarios.isEmpty) {
                  return const Center(
                    child: Text(
                      "Sé el primero en responder este debate.",
                      style: TextStyle(color: Colors.grey),
                    ),
                  );
                }

                final comentariosMap = {for (var c in comentarios) c.id: c};
                final principales =
                    comentarios.where((c) => c.parentId == null).toList();

                return ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: principales
                      .map((c) => buildComentarioConRespuestas(
                          c, comentariosMap, displayName))
                      .toList(),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
            ),
          ),
          const Divider(height: 1),
          NuevoComentarioInput(
            controller: _comentarioController,
            onEnviar: (texto) async {
              if (texto.trim().isEmpty) return;
              final nuevo = Comentario(
                id: 0,
                debateId: widget.debate.id!,
                contenido: texto.trim(),
                autor: displayName,
                createdAt: DateTime.now(),
                parentId: null,
              );
              await _comentarioNotifier.agregarComentario(nuevo);
              await _comentarioNotifier
                  .cargarComentarios(widget.debate.id.toString());
              _comentarioController.clear();
            },
          ),
        ],
      ),
    );
  }
}
