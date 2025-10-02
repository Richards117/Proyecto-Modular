import 'package:flutter_application_votacion/domian/entities/article.dart';

abstract class NewsRepository {
  Future<List<ArticleEntity>> getNews(String query);
}
