import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_votacion/presentation/providers/news_provider.dart';
import 'package:flutter_application_votacion/presentation/screens/news/news_read_screen.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class CarruselImages extends ConsumerStatefulWidget {
  const CarruselImages({super.key});

  @override
  ConsumerState<CarruselImages> createState() => _CarruselImagesState();
}

class _CarruselImagesState extends ConsumerState<CarruselImages> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(newsProvider.notifier).loadNews(''));
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(newsProvider);

    if (state.isLoading) {
      return const SizedBox(
        height: 220,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (state.error.isNotEmpty) {
      return SizedBox(
        height: 220,
        child: Center(
          child: Text(
            'Error al cargar noticias.\n${state.error}',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    if (state.articles.isEmpty) {
      return const SizedBox(
        height: 220,
        child: Center(child: Text('No hay noticias disponibles.')),
      );
    }

    final articles = state.articles;

    return Column(
      children: [
        CarouselSlider.builder(
          itemCount: articles.length,
          options: CarouselOptions(
            height: 220,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 5),
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            enlargeCenterPage: true,
            viewportFraction: 0.85,
            scrollPhysics: const BouncingScrollPhysics(),
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
          itemBuilder: (context, index, realIndex) {
            final article = articles[index];

            return InkWell(
              borderRadius: BorderRadius.circular(22),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => NoticiaWebScreen(
                      url: article.url,
                      titulo: article.title,
                    ),
                  ),
                );
              },
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(22),
                ),
                elevation: 6,
                shadowColor: Colors.black26,
                clipBehavior: Clip.antiAlias,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Hero(
                      tag: article.url,
                      child: article.urlToImage.isNotEmpty
                          ? Image.network(
                              article.urlToImage,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                color: Colors.grey.shade300,
                                child: const Icon(Icons.broken_image, size: 50),
                              ),
                            )
                          : Container(
                              color: Colors.grey.shade300,
                              child: const Icon(Icons.image, size: 50),
                            ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.6),
                            Colors.black.withOpacity(0.85),
                          ],
                          stops: const [0.4, 0.75, 1.0],
                        ),
                      ),
                    ),
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 3, horizontal: 8),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          article.publishedAt.split("T").first,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 14,
                      left: 14,
                      right: 14,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            article.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                              shadows: [
                                Shadow(
                                  offset: Offset(0, 1),
                                  blurRadius: 4,
                                  color: Colors.black54,
                                ),
                              ],
                            ),
                          ),
                          if (article.description.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Text(
                              article.description,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 13,
                              ),
                            ),
                          ],
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  article.sourceName,
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Flexible(
                                child: Text(
                                  article.author,
                                  style: const TextStyle(
                                    color: Colors.white60,
                                    fontSize: 11,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 12),
        AnimatedSmoothIndicator(
          activeIndex: _currentIndex,
          count: articles.length,
          effect: ScrollingDotsEffect(
            activeDotColor: Colors.blueAccent,
            dotColor: Colors.grey.shade400,
            dotHeight: 8,
            dotWidth: 8,
          ),
        )
      ],
    );
  }
}
