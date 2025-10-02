class DebateModel {
  final int? id;
  final String title;
  final String author;
  final String description;
  final DateTime? createdAt;
  final int commentsCount;
  final String? imageUrl;
  final String? categoria;

  DebateModel({
    this.id,
    required this.title,
    required this.author,
    required this.description,
    this.createdAt,
    this.commentsCount = 0,
    this.imageUrl,
    this.categoria,
  });

  factory DebateModel.fromJson(Map<String, dynamic> json) => DebateModel(
        id: json['id'] as int?,
        title: json['title'] ?? '',
        author: json['author'] ?? '',
        description: json['description'] ?? '',
        createdAt: json['created_at'] != null
            ? DateTime.parse(json['created_at'])
            : null,
        commentsCount: (json['comentarios'] as List?)?.length ?? 0,
        imageUrl: json['image_url'] as String?,
        categoria: json['categoria'] as String?,
      );

  Map<String, dynamic> toJson() => {
        if (id != null) 'id': id,
        'title': title,
        'author': author,
        'description': description,
        if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
        'image_url': imageUrl,
        'categoria': categoria,
      };
}
