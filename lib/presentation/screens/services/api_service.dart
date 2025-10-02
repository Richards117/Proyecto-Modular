import 'dart:convert';
import 'package:http/http.dart' as http;

class PrediccionService {
  static const String baseUrl = "https://votacion-api-7592.onrender.com";

  static Future<String> predecirPartido(List<int> datos) async {
    final url = Uri.parse("$baseUrl/predecir");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"datos": datos}),
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return body["prediccion"] ?? "Sin resultado";
    } else {
      throw Exception(
          "Error en API: ${response.statusCode} → ${response.body}");
    }
  }
}
