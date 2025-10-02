class Article {
  final String title;
  final String description;
  final String urlToImage;
  final String publishedAt;
  final String url;
  final String author;
  final String sourceName;

  Article({
    required this.title,
    required this.description,
    required this.urlToImage,
    required this.publishedAt,
    required this.url,
    this.author = 'Desconocido',
    this.sourceName = 'Desconocido',
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      urlToImage: json['urlToImage'] ?? '',
      publishedAt: json['publishedAt'] ?? '',
      url: json['url'] ?? '',
      author: json['author'] ?? 'Desconocido',
      sourceName: json['source']?['name'] ?? 'Desconocido',
    );
  }
}
