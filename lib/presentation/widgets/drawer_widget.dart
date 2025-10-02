import 'package:flutter/material.dart';
import 'package:flutter_application_votacion/presentation/providers/auth_provider.dart';
import 'package:flutter_application_votacion/presentation/screens/votation/PerfilUsuarioScreen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_votacion/presentation/screens/information/guie.dart';
import 'package:flutter_application_votacion/presentation/screens/screens.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DrawerMain extends ConsumerWidget {
  const DrawerMain({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authRepository = ref.watch(authRepositoryProvider);
    final User? user = authRepository.getCurrentUser();

    final displayName = user?.userMetadata?['display_name'] ?? 'Usuario';
    final email = user?.email ?? 'Sin correo';
    final photoUrl = user?.userMetadata?['avatar_url'];

    const String placeholderImage =
        'https://i.pinimg.com/136x136/d9/d8/8e/d9d88e3d1f74e2b8ced3df051cecb81d.jpg';

    Widget buildSectionTitle(String title) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Text(
          title.toUpperCase(),
          style: const TextStyle(
            fontSize: 12,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }

    return Drawer(
      elevation: 16,
      child: Container(
        color: Colors.blue.shade100,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header del Drawer
              Material(
                color: Colors.blue.shade100,
                child: Padding(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top,
                    bottom: 24,
                    left: 16,
                    right: 16,
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 32,
                        backgroundImage:
                            (photoUrl != null && photoUrl.isNotEmpty)
                                ? NetworkImage(photoUrl)
                                : const NetworkImage(placeholderImage),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              displayName,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              email,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Menú de opciones
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    Colors.blue.shade100,
                    Colors.indigo.shade100,
                    Colors.indigo.shade100,
                    Colors.blue.shade100,
                  ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildSectionTitle('Explorar'),
                    const Divider(
                      color: Colors.white,
                      endIndent: 25,
                      indent: 20,
                    ),
                    ListTile(
                      leading:
                          const Icon(Icons.home_outlined, color: Colors.blue),
                      title: const Text(
                        'Inicio',
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w600),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HomeScreen(),
                          ),
                        );
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.newspaper_outlined,
                          color: Colors.redAccent),
                      title: const Text(
                        'Noticias',
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w400),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const NewsScreen(),
                          ),
                        );
                      },
                    ),
                    ListTile(
                      leading:
                          const Icon(Icons.question_mark, color: Colors.orange),
                      title: const Text(
                        'Preguntas',
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w600),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => QuestionsScreen(),
                          ),
                        );
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.how_to_vote_outlined,
                          color: Colors.deepPurple),
                      title: const Text(
                        'Votar',
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w400),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PerfilUsuarioScreen(),
                          ),
                        );
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.map, color: Colors.green),
                      title: const Text(
                        'Mapa',
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w600),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MapaEntidadesPage(),
                          ),
                        );
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.calendar_month_outlined,
                          color: Colors.teal),
                      title: const Text(
                        'Calendario',
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w400),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CalendarScreen(),
                          ),
                        );
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.comment, color: Colors.pink),
                      title: const Text(
                        'Debate',
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w600),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const DebateScreen(),
                          ),
                        );
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.info_outline,
                          color: Colors.blueAccent.shade200),
                      title: const Text(
                        'Guia',
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w400),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const GuiasScreen(),
                          ),
                        );
                      },
                    ),
                    const Divider(
                      color: Colors.white,
                      endIndent: 25,
                      indent: 20,
                    ),
                    buildSectionTitle('Cuenta'),
                    ListTile(
                      leading: const Icon(Icons.person, color: Colors.indigo),
                      title: const Text(
                        'Perfil',
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w600),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PerfilScreen(),
                          ),
                        );
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.info, color: Colors.cyan),
                      title: const Text('Nosotros'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AboutUsScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
