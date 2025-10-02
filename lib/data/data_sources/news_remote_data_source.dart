import 'dart:convert';
import 'package:flutter_application_votacion/data/models/news_models.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

abstract class NewsRemoteDataSource {
  Future<List<Article>> fetchNews(String query);
}

class NewsRemoteDataSourceImpl implements NewsRemoteDataSource {
  @override
  Future<List<Article>> fetchNews(String query) async {
    final String? apiKey = dotenv.env['NEWS_API_KEY'];
    if (apiKey == null || apiKey.isEmpty) {
      throw Exception('NEWS_API_KEY no está definido en .env');
    }

    final finalQuery = query.isEmpty ? 'elecciones México 2024' : query;

    final encodedQuery = Uri.encodeQueryComponent(finalQuery);

    final url =
        'https://newsapi.org/v2/everything?q=$encodedQuery&language=es&sortBy=publishedAt&apiKey=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final articlesJson = data['articles'] as List<dynamic>;
      return articlesJson.map((json) => Article.fromJson(json)).toList();
    } else {
      throw Exception(
          'Failed to load news: ${response.statusCode} - ${response.reasonPhrase}');
    }
  }
}
