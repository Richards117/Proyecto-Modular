import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_application_votacion/config/supabase/config.dart';
import 'package:flutter_application_votacion/config/theme/apptheme.dart';
import 'package:flutter_application_votacion/data/data_sources/debate/debate_remote_data_source.dart';
import 'package:flutter_application_votacion/data/repositories/debate/debate_repository_impl.dart';
import 'package:flutter_application_votacion/presentation/providers/debate/debate_provider.dart';
import 'package:flutter_application_votacion/presentation/screens/home_screen.dart';
import 'package:flutter_application_votacion/presentation/screens/user/login/login_screen.dart';
import 'package:flutter_application_votacion/presentation/screens/user/profile/profile_screen.dart';
import 'package:flutter_application_votacion/presentation/screens/welcome_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  await initializeDateFormatting('es-MX', null);

  await Supabase.initialize(
    url: Enviorament.supabaseUrl,
    anonKey: Enviorament.supabaseAnonKey,
  );

  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.dumpErrorToConsole(details);
    _showGlobalError(details.exceptionAsString());
  };

  runZonedGuarded(
    () {
      runApp(
        ProviderScope(
          overrides: [
            debateRepositoryProvider.overrideWithValue(
              DebateRepositoryImpl(
                DebateRemoteDataSource(),
              ),
            ),
          ],
          child: const MyApp(),
        ),
      );
    },
    (error, stack) {
      debugPrint("Error capturado por runZonedGuarded: $error");
      _showGlobalError(error.toString());
    },
  );
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void _showGlobalError(String message) {
  navigatorKey.currentState?.pushAndRemoveUntil(
    MaterialPageRoute(
      builder: (_) => const ErrorScreen(),
    ),
    (_) => false,
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: AppTheme().getTheme().copyWith(
            appBarTheme: const AppBarTheme(),
          ),
      initialRoute: '/login',
      routes: {
        '/home': (context) => const HomeScreen(),
        '/perfil': (context) => const PerfilScreen(),
        '/login': (context) => const LoginScreen(),
        '/welcome': (context) => const WelcomeScreen(),
      },
    );
  }
}

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          "Ocurrió un error inesperado.\nPor favor, intenta de nuevo más tarde.",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
