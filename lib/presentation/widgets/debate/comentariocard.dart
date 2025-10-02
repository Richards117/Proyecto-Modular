import 'package:flutter/material.dart';
import 'package:flutter_application_votacion/domian/entities/coments.dart';
import 'package:flutter_application_votacion/presentation/providers/debate/coments_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class ComentarioCard extends StatelessWidget {
  final Comentario comentario;
  final bool esTuyo;
  final String debateId;
  final void Function(Comentario) onEditar;
  final void Function()? onResponder;
  final WidgetRef ref;
  final String? autorPadre;
  final String? textoPadre;

  const ComentarioCard({
    super.key,
    required this.comentario,
    required this.esTuyo,
    required this.debateId,
    required this.onEditar,
    required this.ref,
    this.onResponder,
    this.autorPadre,
    this.textoPadre,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        left: comentario.parentId != null ? 40 : 0,
        top: 6,
        bottom: 6,
      ),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (comentario.parentId != null)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        const Icon(Icons.arrow_right,
                            color: Colors.grey, size: 20),
                        Container(
                          width: 2,
                          height: 30,
                          color: Colors.grey.shade300,
                        ),
                      ],
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          "En respuesta a ${autorPadre ?? 'otro comentario'}: ${textoPadre != null ? (textoPadre!.length > 40 ? '${textoPadre!.substring(0, 40)}...' : textoPadre!) : ''}",
                          style: const TextStyle(
                              fontSize: 13,
                              fontStyle: FontStyle.italic,
                              color: Colors.grey),
                        ),
                      ),
                    ),
                  ],
                ),

              const SizedBox(height: 8),
              Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor:
                        esTuyo ? Colors.green.shade400 : Colors.blueAccent,
                    child: Text(
                      comentario.autor[0].toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          esTuyo ? 'Tú' : comentario.autor,
                          style: const TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 15),
                        ),
                        Text(
                          _formatFecha(comentario.createdAt),
                          style:
                              const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  if (esTuyo)
                    PopupMenuButton<String>(
                      borderRadius: BorderRadius.circular(13),
                      icon: const Icon(Icons.more_vert,
                          size: 20, color: Colors.grey),
                      onSelected: (value) {
                        if (value == 'editar') onEditar(comentario);
                        if (value == 'eliminar') {
                          ref
                              .read(comentarioProvider.notifier)
                              .eliminarComentario(comentario.id, debateId);
                        }
                      },
                      itemBuilder: (_) => [
                        const PopupMenuItem(
                          value: 'editar',
                          child: Row(children: [
                            Icon(Icons.edit, color: Colors.blue),
                            SizedBox(width: 8),
                            Text('Editar')
                          ]),
                        ),
                        const PopupMenuItem(
                          value: 'eliminar',
                          child: Row(children: [
                            Icon(Icons.delete_outline, color: Colors.red),
                            SizedBox(width: 8),
                            Text('Eliminar')
                          ]),
                        ),
                      ],
                    ),
                ],
              ),
              const SizedBox(height: 12),
              const Divider(height: 1, color: Colors.black12),
              const SizedBox(height: 12),
              Text(
                comentario.contenido,
                style: const TextStyle(fontSize: 15, height: 1.4),
              ),

              if (comentario.updatedAt != null)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    'Editado ${timeAgo(comentario.updatedAt!)}',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ),

              // Botón Responder
              if (onResponder != null)
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    onPressed: onResponder,
                    icon: const Icon(Icons.reply,
                        size: 18, color: Colors.blueAccent),
                    label: const Text("Responder"),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.blueAccent,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatFecha(DateTime fecha) =>
      DateFormat('dd MMM yyyy, hh:mm a').format(fecha.toLocal());
}

/// Función helper para calcular tiempo relativo
String timeAgo(DateTime date) {
  final now = DateTime.now();
  final difference = now.difference(date);

  if (difference.inSeconds < 60) return 'hace unos segundos';
  if (difference.inMinutes < 60) return 'hace ${difference.inMinutes} min';
  if (difference.inHours < 24) return 'hace ${difference.inHours} h';
  return 'hace ${difference.inDays} d';
}
