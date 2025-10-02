import 'package:flutter/material.dart';
import 'package:flutter_application_votacion/domian/entities/debate.dart';
import 'package:flutter_application_votacion/presentation/providers/debate/debate_provider.dart';
import 'package:flutter_application_votacion/presentation/screens/debate/create_debate_screen.dart';
import 'package:flutter_application_votacion/presentation/screens/debate/coments_debate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class DebateScreen extends ConsumerStatefulWidget {
  const DebateScreen({super.key});

  @override
  ConsumerState<DebateScreen> createState() => _DebateScreenState();
}

class _DebateScreenState extends ConsumerState<DebateScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';

  // Variables para filtro por categoría
  String _selectedCategory = 'Todos';
  final List<String> _categories = [
    'Todos',
    'Política',
    'Tecnología',
    'Deportes',
    'Cultura',
    'Educación',
    'General',
  ];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchText = _searchController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final debatesAsync = ref.watch(debateProvider);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade200, Colors.blue.shade50],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.comment, color: Colors.white),
            SizedBox(width: 8),
            Text('Foro De Debate',
                style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Buscador
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Buscar Debate...",
                filled: true,
                fillColor: Colors.white,
                prefixIcon: const Icon(Icons.search, color: Colors.blueAccent),
                suffixIcon: _searchText.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear, color: Colors.red.shade400),
                        onPressed: () {
                          _searchController.clear();
                          FocusScope.of(context).unfocus();
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
            ),
          ),
          // Dropdown de categoría
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
              ),
              items: _categories
                  .map((cat) => DropdownMenuItem(
                        value: cat,
                        child: Text(cat),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value!;
                });
              },
            ),
          ),
          // Lista de debates
          Expanded(
            child: debatesAsync.when(
              data: (debates) {
                final filteredDebates = debates.where((debate) {
                  final matchesSearch = debate.title
                          .toLowerCase()
                          .contains(_searchText) ||
                      debate.description.toLowerCase().contains(_searchText) ||
                      debate.author.toLowerCase().contains(_searchText);

                  final matchesCategory = _selectedCategory == 'Todos' ||
                      (debate.categoria?.toLowerCase() ==
                          _selectedCategory.toLowerCase());

                  return matchesSearch && matchesCategory;
                }).toList();

                if (filteredDebates.isEmpty) {
                  return const Center(
                      child: Text('No se encontraron debates.'));
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: filteredDebates.length,
                  itemBuilder: (context, index) {
                    final debate = filteredDebates[index];
                    return _TarjetDebate(debate: debate);
                  },
                );
              },
              loading: () => const Center(
                  child: CircularProgressIndicator(strokeWidth: 3)),
              error: (e, _) => Center(child: Text('Error: $e')),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
            side: const BorderSide(color: Colors.black26, width: 2)),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CreateDebateScreen()),
          );

          if (result != null) {
            ref.read(debateProvider.notifier).cargarDebates();
          }
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
      backgroundColor: Colors.blue.shade50,
    );
  }
}

// Tarjeta de Debate
class _TarjetDebate extends StatefulWidget {
  final Debate debate;

  const _TarjetDebate({required this.debate});

  @override
  State<_TarjetDebate> createState() => _TarjetDebateState();
}

class _TarjetDebateState extends State<_TarjetDebate> {
  bool _isPressed = false;

  Color _avatarColor(String author) {
    final hash = author.codeUnits.fold(0, (prev, elem) => prev + elem);
    final colors = [
      Colors.blueAccent,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.indigo,
      Colors.redAccent,
    ];
    return colors[hash % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) {
          setState(() => _isPressed = false);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => Cosutmdebat(debate: widget.debate),
            ),
          );
        },
        onTapCancel: () => setState(() => _isPressed = false),
        child: AnimatedScale(
          scale: _isPressed ? 0.97 : 1.0,
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOut,
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            elevation: _isPressed ? 2 : 6,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  colors: _isPressed
                      ? [Colors.blue.shade100, Colors.blue.shade50]
                      : [Colors.white, Colors.blue.shade50],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: _isPressed ? 6 : 12,
                    offset: const Offset(2, 4),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: widget.debate.imageUrl == null
                              ? _avatarColor(widget.debate.author)
                              : Colors.transparent,
                        ),
                        child: ClipOval(
                          child: widget.debate.imageUrl != null &&
                                  widget.debate.imageUrl!.isNotEmpty
                              ? Image.network(
                                  widget.debate.imageUrl!,
                                  width: 56,
                                  height: 56,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => CircleAvatar(
                                    radius: 28,
                                    backgroundColor:
                                        _avatarColor(widget.debate.author),
                                    child: Text(
                                      widget.debate.author.isNotEmpty
                                          ? widget.debate.author[0]
                                              .toUpperCase()
                                          : "?",
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                )
                              : CircleAvatar(
                                  radius: 28,
                                  backgroundColor:
                                      _avatarColor(widget.debate.author),
                                  child: Text(
                                    widget.debate.author.isNotEmpty
                                        ? widget.debate.author[0].toUpperCase()
                                        : "?",
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.debate.title,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                  color: Colors.black87),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Por ${widget.debate.author} • ${widget.debate.createdAt != null ? DateFormat('dd MMM yyyy').format(widget.debate.createdAt!) : ''}",
                              style: TextStyle(
                                  color: Colors.grey.shade600, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      SizedBox.fromSize(
                        size: const Size(30, 30),
                        child: ClipOval(
                          child: Material(
                            color: Colors.blue.withOpacity(0.2),
                            child: const Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 18,
                              color: Colors.blueGrey,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (widget.debate.description.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Text(
                      widget.debate.description,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style:
                          const TextStyle(fontSize: 14, color: Colors.black87),
                    ),
                  ],
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      _buildBadge(Icons.comment,
                          widget.debate.commentsCount.toString(), Colors.blue),
                      _buildBadge(
                        Icons.category,
                        widget.debate.categoria ?? "General",
                        Colors.green,
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBadge(IconData icon, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.85),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.white),
          const SizedBox(width: 4),
          Text(
            text,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
