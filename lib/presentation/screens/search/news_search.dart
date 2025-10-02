import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_votacion/presentation/providers/news_provider.dart';
import 'package:flutter_application_votacion/domian/entities/article.dart';

 Future<List<ArticleEntity>> fetchFilteredNews(
    WidgetRef ref, String query) async {
   await ref.read(newsProvider.notifier).loadNews(query);

   final state = ref.read(newsProvider);

   if (query.isNotEmpty) {
    return state.articles
        .where((article) =>
            article.title.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  return state.articles;
}
