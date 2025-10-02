import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_application_votacion/presentation/providers/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_votacion/presentation/controllers/perfil_controller.dart';
import 'package:flutter_application_votacion/presentation/screens/user/login/login_screen.dart';
import 'package:flutter_application_votacion/presentation/screens/screens.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PerfilScreen extends ConsumerStatefulWidget {
  const PerfilScreen({super.key});

  @override
  ConsumerState<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends ConsumerState<PerfilScreen> {
  late PerfilController controller;

  String? profileImageUrl;
  String? displayName;
  String? email;
  String? role;
  String? photoPath;
  bool _isPressedCamera = false;

  @override
  void initState() {
    super.initState();
    controller = PerfilController(ref: ref, context: context);
    _loadUserData();
  }

  void _loadUserData() {
    final data = controller.loadUserData();
    setState(() {
      displayName = data['displayName'];
      email = data['email'];
      role = data['role'];
      profileImageUrl = data['profileImageUrl'];
      photoPath = null;
    });
  }

  Future<void> _changeProfilePhoto() async {
    final imageUrl = await controller.changeProfilePhoto();
    if (!mounted) return;
    if (imageUrl != null) {
      setState(() {
        profileImageUrl = imageUrl;
        photoPath = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(authNotifierProvider);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.blueAccent.shade100,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black87, size: 35),
        backgroundColor: Colors.blue.shade200,
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person_pin_rounded, color: Colors.white),
            SizedBox(width: 8),
            Text('Mi Perfil', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: FloatingActionButton(
              heroTag: 'edit-btn',
              mini: true,
              backgroundColor: Colors.indigoAccent.shade200,
              elevation: 6,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => const EditProfileDialog(),
                ).then((_) => _loadUserData());
              },
              child: const Icon(Icons.edit),
            ),
          )
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue.shade200,
              Colors.blue.shade100,
              Colors.blueAccent.shade100,
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              Hero(
                tag: 'profile-image',
                child: Stack(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.indigoAccent.withOpacity(0.3),
                            blurRadius: 12,
                            spreadRadius: 1,
                          ),
                        ],
                        border: Border.all(
                          color: Colors.white,
                          width: 3,
                        ),
                      ),
                      child: GestureDetector(
                        onTap: () {
                          if (profileImageUrl != null &&
                              profileImageUrl!.isNotEmpty) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    FullImageScreen(imageUrl: profileImageUrl!),
                              ),
                            );
                          }
                        },
                        child: CircleAvatar(
                          maxRadius: 80,
                          backgroundImage: photoPath != null
                              ? FileImage(File(photoPath!)) as ImageProvider
                              : (profileImageUrl != null &&
                                      profileImageUrl!.isNotEmpty
                                  ? NetworkImage(profileImageUrl!)
                                  : const AssetImage(
                                      'assets/default_avatar.png')),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 8,
                      right: 8,
                      child: GestureDetector(
                        onTapDown: (_) =>
                            setState(() => _isPressedCamera = true),
                        onTapUp: (_) {
                          setState(() => _isPressedCamera = false);
                          _changeProfilePhoto();
                        },
                        onTapCancel: () =>
                            setState(() => _isPressedCamera = false),
                        child: AnimatedScale(
                          scale: _isPressedCamera ? 0.97 : 1.0,
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.elasticOut,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _isPressedCamera
                                  ? Colors.red.withOpacity(0.6)
                                  : Colors.indigoAccent.shade200,
                            ),
                            padding: const EdgeInsets.all(15),
                            child: const Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              Text(
                displayName ?? "Cargando...",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo.shade900,
                  shadows: const [
                    Shadow(
                      color: Colors.black26,
                      blurRadius: 4,
                      offset: Offset(1, 1),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    _InfoCard(
                      icon: Icons.email,
                      label: 'Correo',
                      value: email ?? "Sin correo",
                    ),
                    const SizedBox(height: 12),
                    _InfoCard(
                      icon: Icons.person_outline,
                      label: 'Rol',
                      value: role ?? "Usuario",
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),
              ButtonScript(mounted: mounted, size: size),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class ButtonScript extends StatelessWidget {
  const ButtonScript({
    super.key,
    required this.mounted,
    required this.size,
  });

  final bool mounted;
  final Size size;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () async {
        await Supabase.instance.client.auth.signOut();
        if (!mounted) return;
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (Route<dynamic> route) => false,
        );
      },
      icon: const Icon(Icons.person),
      label: const Text("Cerrar Sesion"),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.indigoAccent.shade200,
        minimumSize: Size(size.width * 0.5, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shadowColor: Colors.black26,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        leading: Icon(icon, color: Colors.indigoAccent.shade200, size: 28),
        title: Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          value,
          style: const TextStyle(fontSize: 16, color: Colors.black87),
        ),
      ),
    );
  }
}
