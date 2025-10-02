// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:flutter_application_votacion/presentation/widgets/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_votacion/presentation/providers/auth_provider.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  bool _obscurePassword = true;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController fullNameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    // Escucha cambios en el estado de autenticación
    ref.listenManual<AuthState>(authNotifierProvider, (previous, next) {
      if (next.error != null) {
        if (next.error!.contains("email-already-in-use")) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('⚠️ El correo ya está registrado')),
          );
        } else {
          alertRegister(context);
        }
      } else if (!next.isAuthenticated && previous?.loading == true) {
        // Registro exitoso pero falta verificar correo
        alertRegistroExitoso(
          context,
          mensaje: "Te hemos enviado un correo de verificación. "
              "Por favor revisa tu bandeja y confirma tu cuenta.",
          onConfirm: () {
            Navigator.pushReplacementNamed(context, '/login');
          },
        );
      } else if (next.isAuthenticated) {
        // Caso raro: si la confirmación de email está desactivada
        Navigator.pushReplacementNamed(context, '/welcome');
      }
    });
  }

  Future<void> handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final fullName = fullNameController.text.trim();

    await ref
        .read(authNotifierProvider.notifier)
        .signUp(email, password, fullName);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          const AuthBackground(),
          Padding(
            padding: const EdgeInsets.all(30),
            child: Center(
              child: SingleChildScrollView(
                child: Container(
                  width: size.width * 0.85,
                  padding:
                      const EdgeInsets.symmetric(vertical: 30, horizontal: 25),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 20,
                        offset: Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Crear Cuenta',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade800,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "Por favor, completa tus datos para registrarte",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 25),
                        // Email
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            LoginField(
                              keyboardType: TextInputType.emailAddress,
                              controller: emailController,
                              label: "Correo Electrónico",
                              icon: Icons.email,
                              isPassword: false,
                              hintex: 'ejemplo@correo.com',
                              autocorrect: false,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Por favor ingresa tu correo electrónico';
                                }
                                final emailRegex =
                                    RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                                if (!emailRegex.hasMatch(value)) {
                                  return 'Formato de correo no válido';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 5),
                            const Text(
                              "📧 Ingresa un correo válido donde recibirás tu mensaje de verificación, por ejemplo: ejemplo@correo.com",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.indigoAccent,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        // Contraseña
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            LoginField(
                              controller: passwordController,
                              label: "Contraseña",
                              icon: Icons.lock,
                              isPassword: _obscurePassword,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: Colors.indigoAccent.shade200,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
                              hintex: '',
                              autocorrect: false,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Por favor ingresa tu contraseña';
                                }
                                if (value.length < 8) {
                                  return 'Debe tener al menos 8 caracteres';
                                }
                                if (!RegExp(r'[A-Z]').hasMatch(value)) {
                                  return 'Debe contener al menos una mayúscula';
                                }
                                if (!RegExp(r'[0-9]').hasMatch(value)) {
                                  return 'Debe contener al menos un número';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 5),
                            const Text(
                              "🔒 Tu contraseña debe tener al menos 8 caracteres, una letra mayúscula y un número para mantener tu cuenta segura.",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.indigoAccent,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        // Nombre completo
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            LoginField(
                              controller: fullNameController,
                              label: "Nombre Completo",
                              icon: Icons.person,
                              isPassword: false,
                              hintex: 'Tu nombre y apellido',
                              autocorrect: false,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Por favor ingresa tu nombre completo';
                                }
                                if (!value.trim().contains(" ")) {
                                  return 'Debes ingresar nombre y apellido';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 5),
                            const Text(
                              " Ingresa tu nombre y apellido completos, separados por un espacio, para que podamos dirigirte correctamente.",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.indigoAccent,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 25),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.indigoAccent.shade200,
                              shape: ContinuousRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                              shadowColor: Colors.black54,
                              elevation: 12,
                              padding: const EdgeInsets.symmetric(vertical: 15),
                            ),
                            onPressed: handleRegister,
                            child: const Text(
                              "Registrarse",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text(
                            "¿Ya tienes cuenta? Inicia sesión",
                            style: TextStyle(
                              color: Colors.indigoAccent,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
