//Alerta de LoginScreen--------------------------------------
// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_application_votacion/presentation/providers/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

//Alerta  de Login----------------------------------------------
Future<String?> alertLogin(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        titlePadding: const EdgeInsets.all(20),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 24, vertical: 15),
        actionsPadding: const EdgeInsets.only(bottom: 15),
        title: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.red.shade100.withOpacity(0.6),
                borderRadius: BorderRadius.circular(30),
              ),
              padding: const EdgeInsets.all(12),
              child: Icon(
                Icons.error_outline,
                size: 40,
                color: Colors.redAccent.shade200,
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Text(
                '¡Atención!',
                style: TextStyle(
                  color: Colors.redAccent.shade200,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
            ),
          ],
        ),
        content: const Text(
          'Algún campo está mal, revíselo nuevamente.',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.redAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              'Aceptar',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      );
    },
  );
}

//Alerta  de RegisterExitoso----------------------------------------------
Future<String?> alertRegistroExitoso(BuildContext context,
    {required Null Function() onConfirm, required String mensaje}) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        titlePadding: const EdgeInsets.all(20),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 24, vertical: 15),
        actionsPadding: const EdgeInsets.only(bottom: 15),
        title: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.green.shade100.withOpacity(0.6),
                borderRadius: BorderRadius.circular(30),
              ),
              padding: const EdgeInsets.all(12),
              child: Icon(
                Icons.check_circle_outline,
                size: 40,
                color: Colors.green.shade700,
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Text(
                '¡Éxito!',
                style: TextStyle(
                  color: Colors.green.shade700,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
            ),
          ],
        ),
        content: const Text(
          '¡Registro completado con éxito!\n\n'
          'Por favor, verifica tu correo electrónico para activar tu cuenta.',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 16,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
          ),
          textAlign: TextAlign.center,
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.green.shade700,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
            ),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/login');
            },
            child: const Text(
              'Aceptar',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      );
    },
  );
}

//Alerta  de Reistro----------------------------------------------
Future<String?> alertRegister(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        titlePadding: const EdgeInsets.all(20),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 24, vertical: 15),
        actionsPadding: const EdgeInsets.only(bottom: 15),
        title: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.red.shade100.withOpacity(0.6),
                borderRadius: BorderRadius.circular(30),
              ),
              padding: const EdgeInsets.all(12),
              child: Icon(
                Icons.error_outline,
                size: 40,
                color: Colors.redAccent.shade200,
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Text(
                '¡Atención!',
                style: TextStyle(
                  color: Colors.redAccent.shade200,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
            ),
          ],
        ),
        content: const Text(
          'Por favor, completa todos los campos antes de continuar o revise si los datos ya fueron usados previamente.',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.redAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              'Aceptar',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      );
    },
  );
}

//Alerta Cierre de Sesion PerfilScreen
Future<String?> alertsesion(BuildContext context, WidgetRef ref) {
  return showDialog<String>(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              borderRadius: BorderRadius.circular(30),
            ),
            padding: const EdgeInsets.all(10),
            child: const Icon(
              Icons.warning_amber_rounded,
              size: 40,
              color: Colors.red,
            ),
          ),
          const SizedBox(width: 15),
          const Text(
            '¡Alerta!',
            style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
              fontSize: 26,
            ),
          ),
        ],
      ),
      content: const Text(
        '¿Estas Seguro de Cerrar la Sesión?',
        style: TextStyle(
          color: Colors.black87,
          fontSize: 18,
        ),
        textAlign: TextAlign.center,
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent.shade700,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                elevation: 3,
              ),
              onPressed: () => Navigator.pop(context, 'Cancelar'),
              child: const Text(
                'No',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                elevation: 3,
              ),
              onPressed: () {
                // 🔹 1️⃣ Cerrar sesión usando AuthNotifier
                ref.read(authNotifierProvider.notifier).signOut();

                // 🔹 2️⃣ Navegar al login y limpiar el historial
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/login',
                  (route) => false,
                );
              },
              child: const Text(
                'Si',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

//Alerta Cambio de foto PerfilScreen
Future<int?> alertfoto(BuildContext context) {
  return showDialog<int>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        title: const Text(
          'Seleccione una imagen o tome una fotografía',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
          textAlign: TextAlign.center,
        ),
        content: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.blue.withOpacity(0.1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop(1);
                        },
                        child: Column(
                          children: [
                            Icon(
                              Icons.camera_alt,
                              size: 50,
                              color: Colors.blueAccent.shade200,
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Cámara',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.blue.withOpacity(0.1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop(2);
                        },
                        child: Column(
                          children: [
                            Icon(
                              Icons.storage,
                              size: 50,
                              color: Colors.blueAccent.shade200,
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Galería',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: <Widget>[
          Center(
            child: TextButton(
              style: TextButton.styleFrom(
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(12),
                backgroundColor: Colors.red.withOpacity(0.1),
              ),
              child: const Icon(
                Icons.close_rounded,
                color: Colors.red,
                size: 30,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ],
      );
    },
  );
}

//Alert cambio de contraseña
AlertDialog alertPassword(
    TextEditingController emailController, BuildContext context) {
  return AlertDialog(
    title: const Text("Restablecer Contraseña"),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
            "Ingresa tu correo electrónico para recibir un enlace de restablecimiento."),
        TextField(
          controller: emailController,
          decoration: const InputDecoration(
            labelText: 'Correo Electrónico',
            hintText: 'Ingresa tu correo',
          ),
          keyboardType: TextInputType.emailAddress,
        ),
      ],
    ),
    actions: [
      TextButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Text("Cancelar"),
      ),
      TextButton(
        onPressed: () async {
          String email = emailController.text.trim();
          if (email.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('Por favor, ingresa tu correo electrónico')),
            );
            return;
          }

          try {
            await Supabase.instance.client.auth.resetPasswordForEmail(email);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content:
                      Text('Enlace de restablecimiento enviado a tu correo')),
            );

            Navigator.pop(context);
          } catch (error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${error.toString()}')),
            );
          }
        },
        child: const Text("Enviar"),
      ),
    ],
  );
}
