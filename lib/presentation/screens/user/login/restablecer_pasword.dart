import 'package:flutter/material.dart';

class PasswordResetConfirmationScreen extends StatelessWidget {
  const PasswordResetConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Restablecer Contraseña'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.email_outlined,
                size: 100,
                color: Colors.blueAccent,
              ),
              const SizedBox(height: 20),
              const Text(
                'Hemos enviado un enlace de restablecimiento a tu correo electrónico.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent.shade200,
                ),
                child: const Text('Volver a Iniciar Sesión'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
