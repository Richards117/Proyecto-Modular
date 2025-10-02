import 'package:flutter/material.dart';
import 'package:flutter_application_votacion/presentation/widgets/drawer_widget.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white, size: 30),
        centerTitle: true,
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.info_outline, color: Colors.white),
            SizedBox(width: 8),
            Text('Nosotros', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        backgroundColor: Colors.blue.shade200,
      ),
      drawer: const DrawerMain(),
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.blue.shade100,
                Colors.blueAccent.shade100,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  textAlign: TextAlign.center,
                  'Somos una institución no gubernamental que administra la información de candidatos y candidatas para mostrarte sus propuestas y que tomes decisiones informadas para nuestro futuro.',
                  style: TextStyle(
                    height: 1.9,
                    letterSpacing: 3.0,
                    wordSpacing: 5.0,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                  ),
                ),
                Divider(
                  color: Colors.white,
                  endIndent: 20,
                  indent: 20,
                ),
                SizedBox(height: 20),
                ContainerInfo(
                  text: 'Misión',
                  info:
                      'Facilitar el acceso a información clara, organizada y objetiva sobre los candidatos y sus propuestas, promoviendo la participación ciudadana informada y responsable en los procesos electorales.',
                ),
                SizedBox(height: 20),
                ContainerInfo(
                  text: 'Visión',
                  info:
                      'Convertirnos en la plataforma de referencia en la administración de información electoral, empoderando a millones de ciudadanos para tomar decisiones conscientes.',
                ),
                SizedBox(height: 20),
                ContainerInfo(
                  text: 'Valores',
                  info:
                      'Transparencia, Objetividad, Innovación, Compromiso Cívico, y Accesibilidad.',
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ContainerInfo extends StatelessWidget {
  final String info;
  final String text;
  const ContainerInfo({
    super.key,
    required this.text,
    required this.info,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(blurRadius: 5, color: Colors.black),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 200,
            decoration: BoxDecoration(
                color: Colors.blueAccent.shade200,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                ),
                boxShadow: const [
                  BoxShadow(
                    blurRadius: 5,
                  )
                ]),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.info_outline, color: Colors.white),
                  const SizedBox(width: 5),
                  Text(
                    text,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text(
              textAlign: TextAlign.center,
              info,
              style: const TextStyle(
                color: Colors.black54,
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
