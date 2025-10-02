import 'package:flutter_dotenv/flutter_dotenv.dart';

class Enviorament {
  static String supabaseUrl = dotenv.env['SUPABASE_URL'] ?? 'No hay URL';
  static String supabaseAnonKey =
      dotenv.env['SUPABASE_ANON_KEY'] ?? 'No hay clave';
  //static String themovieDbKey = dotenv.env['THE_SU_KEY'] ?? 'No hay api key';
}

class Enviorament2 {
  static String baseUrl = dotenv.env['SUPABASE_URL'] ?? 'No hay URL';
  static String apikey = dotenv.env['SUPABASE_ANON_KEY'] ?? 'No hay clave';
  //static String themovieDbKey = dotenv.env['THE_SU_KEY'] ?? 'No hay api key';
}
