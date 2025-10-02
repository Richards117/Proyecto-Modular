import 'package:flutter_application_votacion/data/data_sources/news_remote_data_source.dart';
import 'package:flutter_application_votacion/domian/entities/article.dart';
import 'package:flutter_application_votacion/domian/repositories/news_repository.dart';

class NewsRepositoryImpl implements NewsRepository {
  final NewsRemoteDataSource remoteDataSource;

  NewsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<ArticleEntity>> getNews(String query) async {
    final articles = await remoteDataSource.fetchNews(query);
    return articles
        .map((a) => ArticleEntity(
              title: a.title,
              description: a.description,
              urlToImage: a.urlToImage,
              publishedAt: a.publishedAt,
              url: a.url,
              author: a.author,
              sourceName: a.sourceName,
            ))
        .toList();
  }
}
