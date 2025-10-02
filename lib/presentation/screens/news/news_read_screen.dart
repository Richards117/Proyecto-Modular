import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class NoticiaWebScreen extends StatefulWidget {
  final String url;
  final String titulo;

  const NoticiaWebScreen({super.key, required this.url, required this.titulo});

  @override
  State<NoticiaWebScreen> createState() => _NoticiaWebScreenState();
}

class _NoticiaWebScreenState extends State<NoticiaWebScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) {
            setState(() {
              _isLoading = true;
            });
          },
          onPageFinished: (_) {
            setState(() {
              _isLoading = false;
            });
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  Future<void> _openInBrowser() async {
    final uri = Uri.tryParse(widget.url);

    if (uri == null ||
        !(uri.isAbsolute && (uri.scheme == 'http' || uri.scheme == 'https'))) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('La URL no es válida')),
      );
      return;
    }

    try {
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (!launched) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se pudo abrir el navegador')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al abrir el navegador: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.titulo,
          style: const TextStyle(fontSize: 16),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.blue.shade700,
        actions: [
          IconButton(
            icon: const Icon(Icons.open_in_browser),
            onPressed: _openInBrowser,
            tooltip: 'Abrir en navegador',
          )
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(3),
          child: _isLoading
              ? const LinearProgressIndicator(
                  color: Colors.blueAccent,
                  minHeight: 3,
                )
              : const SizedBox(height: 3),
        ),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
