import 'package:flutter_application_votacion/data/repositories/news_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_votacion/domian/entities/article.dart';
import 'package:flutter_application_votacion/domian/repositories/news_repository.dart';
import 'package:flutter_application_votacion/data/data_sources/news_remote_data_source.dart';

 class NewsState {
  final List<ArticleEntity> articles;
  final bool isLoading;
  final String error;

  NewsState({
    required this.articles,
    required this.isLoading,
    required this.error,
  });

  NewsState copyWith({
    List<ArticleEntity>? articles,
    bool? isLoading,
    String? error,
  }) =>
      NewsState(
        articles: articles ?? this.articles,
        isLoading: isLoading ?? this.isLoading,
        error: error ?? this.error,
      );

  factory NewsState.initial() =>
      NewsState(articles: [], isLoading: false, error: '');
}

 class NewsNotifier extends StateNotifier<NewsState> {
  final NewsRepository repository;

  NewsNotifier({required this.repository}) : super(NewsState.initial());

  Future<void> loadNews(String query) async {
    state = state.copyWith(isLoading: true, error: '');
    try {
      final articles = await repository.getNews(query);
      state = state.copyWith(articles: articles, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

 final newsRepositoryProvider = Provider<NewsRepository>((ref) {
  final remoteDataSource = NewsRemoteDataSourceImpl();
  return NewsRepositoryImpl(remoteDataSource: remoteDataSource);
});

 final newsProvider = StateNotifierProvider<NewsNotifier, NewsState>((ref) {
  final repository = ref.watch(newsRepositoryProvider);
  return NewsNotifier(repository: repository);
});
