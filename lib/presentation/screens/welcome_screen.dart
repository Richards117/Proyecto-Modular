import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.white, Colors.blueAccent],
                ),
              ),
              child: Opacity(
                opacity: 0.2,
                child: Image.asset(
                  'assets/image_back.jpg',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          LayoutBuilder(builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 80),
                        // Título
                        Text(
                          '¡Bienvenido!',
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Colors.indigo.shade700,
                            letterSpacing: 1.2,
                            shadows: const [
                              Shadow(
                                  color: Colors.black26,
                                  offset: Offset(2, 2),
                                  blurRadius: 4)
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Subtítulo informativo
                        const Text(
                          'Explora los candidatos y sus propuestas.\nVota informado',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.black87,
                              height: 1.4,
                              fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 12),
                        // Texto adicional
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            "Esta app te ayuda a conocer los candidatos disponibles en tu comunidad. ¡Infórmate antes de votar!",
                            textAlign: TextAlign.center,
                            style:
                                TextStyle(fontSize: 16, color: Colors.black54),
                          ),
                        ),
                        const SizedBox(height: 24),
                        // Imagen
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 20,
                                offset: Offset(0, 10),
                              )
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.asset(
                              'assets/vote_intro.png',
                              fit: BoxFit.contain,
                              height: size.height * 0.3,
                            ),
                          ),
                        ),
                        const SizedBox(height: 50),
                        // Botón
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          child: ElevatedButton.icon(
                            onPressed: () => Navigator.pushReplacementNamed(
                                context, '/home'),
                            icon: const Icon(Icons.how_to_vote,
                                color: Colors.white, size: 28),
                            label: const Text(
                              'Empezar',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              elevation: 12,
                              backgroundColor: Colors.indigoAccent.shade400,
                              shadowColor: Colors.black38,
                              minimumSize: Size(double.infinity, 55),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        // Texto apoyo
                        const Text(
                          '¡Comienza tu experiencia electoral ahora!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.black54),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            );
          })
        ],
      ),
    );
  }
}
