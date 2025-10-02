import 'package:flutter/material.dart';
import 'package:flutter_application_votacion/presentation/screens/user/login/register.dart';
import 'package:flutter_application_votacion/presentation/widgets/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_votacion/presentation/providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  bool _obscurePassword = true;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    await ref.read(authNotifierProvider.notifier).signIn(email, password);

    final authState = ref.read(authNotifierProvider);
    if (authState.isAuthenticated) {
      Navigator.pushReplacementNamed(context, '/welcome');
    } else if (authState.error != null) {
      alertLogin(context);
    }
  }

  void showPasswordResetDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController resetEmailController =
            TextEditingController();
        return alertPassword(resetEmailController, context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final authState = ref.watch(authNotifierProvider);

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            const AuthBackground(),
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
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
                          "¡Bienvenido!",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade800,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "Ingresa tus datos para continuar",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 25),

                        // Email
                        LoginField(
                          keyboardType: TextInputType.emailAddress,
                          controller: emailController,
                          label: "Correo Electrónico",
                          icon: Icons.email,
                          isPassword: false,
                          hintex: 'ejemplo@correo.com',
                          autocorrect: false,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Ingresa tu correo';
                            }
                            if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                .hasMatch(value)) {
                              return 'Correo inválido';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),

                        // Password
                        LoginField(
                          controller: passwordController,
                          label: "Contraseña",
                          icon: Icons.lock,
                          hintex: '',
                          autocorrect: false,
                          isPassword: _obscurePassword,
                          suffixIcon: IconButton(
                            icon: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 200),
                              child: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                key: ValueKey(_obscurePassword),
                                color: Colors.indigoAccent.shade200,
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Ingresa tu contraseña';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 15),

                        // Olvide contraseña
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.help_outline,
                                color: Colors.redAccent.shade400, size: 18),
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.redAccent.shade400,
                                  textStyle: const TextStyle(
                                    decoration: TextDecoration.underline,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                onPressed: showPasswordResetDialog,
                                child: const Text('¿Contraseña olvidada?'),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),

                        // Boton login
                        AnimatedScale(
                          scale: authState.loading ? 0.97 : 1.0,
                          duration: const Duration(milliseconds: 100),
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.indigoAccent.shade200,
                                  Colors.blueAccent.shade200
                                ],
                              ),
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.black54,
                                elevation: 12,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 15),
                              ),
                              onPressed: authState.loading
                                  ? null
                                  : () async {
                                      await handleLogin();
                                      final state =
                                          ref.read(authNotifierProvider);
                                      if (state.error != null) {
                                        alertLogin(context);
                                      }
                                    },
                              child: authState.loading
                                  ? const SizedBox(
                                      height: 24,
                                      width: 24,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 3,
                                      ),
                                    )
                                  : const Text(
                                      "Iniciar Sesión",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 15),

                        // Register
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const RegisterScreen(),
                              ),
                            );
                          },
                          child: const Text(
                            "¿No tienes cuenta? Regístrate",
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
          ],
        ),
      ),
    );
  }
}
