// presentation/screens/news/news_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_votacion/domian/entities/article.dart';
import 'package:flutter_application_votacion/presentation/providers/news_provider.dart';
import 'package:flutter_application_votacion/presentation/screens/news/news_read_screen.dart';
import 'package:flutter_application_votacion/presentation/widgets/carrusel.dart';
import 'package:flutter_application_votacion/presentation/widgets/drawer_widget.dart';

class NewsScreen extends ConsumerStatefulWidget {
  const NewsScreen({super.key});

  @override
  ConsumerState<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends ConsumerState<NewsScreen> {
  late TextEditingController searchController;

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
    Future.microtask(() => ref.read(newsProvider.notifier).loadNews(''));
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(newsProvider);

    return Scaffold(
      drawer: const DrawerMain(),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // SliverAppBar con carrusel colapsable
            SliverAppBar(
              pinned: true,
              expandedHeight: 250,
              backgroundColor: Colors.blue.shade50,
              leading: Builder(
                builder: (context) => IconButton(
                  icon: const Icon(Icons.menu, color: Colors.black),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                ),
              ),
              flexibleSpace: const FlexibleSpaceBar(
                background: CarruselImages(),
                collapseMode: CollapseMode.parallax,
              ),
              title: const Text(
                'Noticias',
                style: TextStyle(fontSize: 18),
              ),
              centerTitle: true,
            ),

            // Campo de búsqueda
            SliverToBoxAdapter(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Material(
                  elevation: 4,
                  borderRadius: BorderRadius.circular(30),
                  child: TextField(
                    controller: searchController,
                    onChanged: (query) =>
                        ref.read(newsProvider.notifier).loadNews(query),
                    decoration: InputDecoration(
                      hintText: "Buscar noticia...",
                      hintStyle:
                          const TextStyle(color: Colors.black54, fontSize: 16),
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon:
                          const Icon(Icons.search, color: Colors.blueAccent),
                      suffixIcon: searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear,
                                  color: Colors.redAccent),
                              onPressed: () {
                                searchController.clear();
                                ref.read(newsProvider.notifier).loadNews('');
                              },
                            )
                          : null,
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 14, horizontal: 20),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15)),
                    ),
                  ),
                ),
              ),
            ),

            // Título Noticias Relevantes
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Noticias",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            // Lista de noticias
            if (state.isLoading)
              const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              )
            else if (state.error.isNotEmpty)
              SliverFillRemaining(
                child: Center(
                    child: Text('Error al cargar noticias: ${state.error}')),
              )
            else if (state.articles.isEmpty)
              const SliverFillRemaining(
                child: Center(child: Text('No hay noticias disponibles')),
              )
            else
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final article = state.articles[index];
                    return _Noticia(article: article, index: index);
                  },
                  childCount: state.articles.length,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ------------------ Tarjeta de noticia ------------------
class _Noticia extends StatefulWidget {
  final ArticleEntity article;
  final int index;

  const _Noticia({required this.article, required this.index});

  @override
  State<_Noticia> createState() => _NoticiaState();
}

class _NoticiaState extends State<_Noticia> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) {
          setState(() => _isPressed = false);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => NoticiaWebScreen(
                  url: widget.article.url, titulo: widget.article.title),
            ),
          );
        },
        onTapCancel: () => setState(() => _isPressed = false),
        child: AnimatedScale(
          scale: _isPressed ? 0.97 : 1.0,
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOut,
          child: Card(
            elevation: 6,
            shadowColor: Colors.black26,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black54),
                borderRadius: BorderRadius.circular(20),
                color: _isPressed
                    ? Colors.red.withOpacity(0.1)
                    : Colors.blue.shade50,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Hero(
                        tag: '${widget.article.url}-${widget.index}',
                        child:
                            _TarjetaImagen(imageUrl: widget.article.urlToImage),
                      ),
                      Positioned(
                        top: 12,
                        left: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            widget.article.publishedAt.split("T").first,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      widget.article.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  if (widget.article.description.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      child: Text(
                        widget.article.description,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontSize: 14,
                          height: 1.3,
                        ),
                      ),
                    ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ------------------ Imagen de noticia ------------------
class _TarjetaImagen extends StatelessWidget {
  final String? imageUrl;
  const _TarjetaImagen({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      child: (imageUrl != null && imageUrl!.isNotEmpty)
          ? FadeInImage(
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
              placeholder: const AssetImage('assets/giphy.gif'),
              image: NetworkImage(imageUrl!),
              imageErrorBuilder: (context, error, stackTrace) {
                return const Image(
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  image: AssetImage('assets/No-image-available.png'),
                );
              },
            )
          : const Image(
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
              image: AssetImage('assets/giphy.gif'),
            ),
    );
  }
}
