class ArticleEntity {
  final String title;
  final String description;
  final String urlToImage;
  final String publishedAt;
  final String url;
  final String author;
  final String sourceName;

  ArticleEntity({
    required this.title,
    required this.description,
    required this.urlToImage,
    required this.publishedAt,
    required this.url,
    this.author = 'Desconocido',
    this.sourceName = 'Desconocido',
  });
}
