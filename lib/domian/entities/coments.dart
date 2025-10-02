class Comentario {
  final int id;
  final int debateId;
  final String contenido;
  final String autor;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String? userId;
  final String? profileId;
  final int? parentId;

  Comentario({
    required this.id,
    required this.debateId,
    required this.contenido,
    required this.autor,
    required this.createdAt,
    this.updatedAt,
    this.userId,
    this.profileId,
    this.parentId,
  });
}
