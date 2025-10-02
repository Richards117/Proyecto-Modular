class Debate {
  final int? id;
  final String title;
  final String author;
  final String description;
  final DateTime? createdAt;
  final int commentsCount;
  final int likesCount;
  final String? imageUrl;
  final String? categoria;

  Debate({
    this.id,
    required this.title,
    required this.author,
    required this.description,
    this.createdAt,
    this.commentsCount = 0,
    this.likesCount = 0,
    this.imageUrl,
    this.categoria,
  });
}
