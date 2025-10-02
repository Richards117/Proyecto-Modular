// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_application_votacion/presentation/widgets/alerts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ContainerWhite extends ConsumerWidget {
  final String displayName;
  final String email;

  const ContainerWhite({
    super.key,
    required this.displayName,
    required this.email,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.blue.shade100,
          boxShadow: const [
            BoxShadow(
              color: Colors.black87,
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          children: [
            CardInfo(
              icon: Icons.person,
              text: 'Nombre Usuario:',
              subtext: displayName,
            ),
            CardInfo(
              icon: Icons.email,
              text: 'Correo:',
              subtext: email,
            ),
            const CardInfo(
              icon: Icons.lock,
              text: 'Contraseña:',
              subtext: '***********',
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                alertsesion(context, ref);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent.shade200,
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Cerrar Sesión',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

class CardInfo extends StatelessWidget {
  final String text;
  final String? subtext;
  final IconData icon;
  const CardInfo({
    super.key,
    required this.text,
    required this.subtext,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: Card(
        elevation: 9,
        shadowColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: const BorderSide(color: Colors.black26, width: 1.5),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: LinearGradient(colors: [
              Colors.blue.shade100,
              Colors.indigo.shade100,
              Colors.blue.shade100,
              Colors.indigo.shade100,
            ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
          ),
          child: ListTile(
            leading: SizedBox.fromSize(
              size: const Size(35, 35),
              child: ClipOval(
                child: Material(
                  color: Colors.blue.withOpacity(0.2),
                  child: Icon(icon, color: Colors.blueAccent.shade400),
                ),
              ),
            ),
            title: Text(
              text,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            subtitle: Text(
              subtext ?? "No disponible",
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ),
    );
  }
}
