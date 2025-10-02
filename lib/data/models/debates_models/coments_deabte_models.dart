class ComentarioModel {
  final int id;
  final int debateId;
  final String contenido;
  final String autor;
  final String createdAt;
  final String? updatedAt;
  final int? parentId;

  ComentarioModel({
    required this.id,
    required this.debateId,
    required this.contenido,
    required this.autor,
    required this.createdAt,
    this.updatedAt,
    this.parentId,
  });

  factory ComentarioModel.fromJson(Map<String, dynamic> json) =>
      ComentarioModel(
        id: json['id'] ?? 0,
        debateId: json['debate_id'] ?? 0,
        contenido: json['contenido'] ?? '',
        autor: json['autor'] ?? '',
        createdAt: json['created_at'] ?? '',
        updatedAt: json['updated_at'],
        parentId: json['parent_id'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'debate_id': debateId,
        'contenido': contenido,
        'autor': autor,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'parent_id': parentId,
      };
}
