import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_votacion/presentation/providers/news_provider.dart';
import 'package:flutter_application_votacion/domian/entities/article.dart';

/// Devuelve una lista filtrada de artículos usando el provider de noticias.
Future<List<ArticleEntity>> fetchFilteredNews(
    WidgetRef ref, String query) async {
  // Carga las noticias usando el notifier
  await ref.read(newsProvider.notifier).loadNews(query);

  // Obtiene el estado actual después de cargar
  final state = ref.read(newsProvider);

  // Filtra las noticias si hay query
  if (query.isNotEmpty) {
    return state.articles
        .where((article) =>
            article.title.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  return state.articles;
}
