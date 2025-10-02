import 'package:http/http.dart' as http;
import 'dart:convert';

Future<String> predecirVoto(List<int> registro) async {
  final url = Uri.parse("https://tu-app-render.onrender.com/predict");
  final response = await http.post(
    url,
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({"registro": registro}),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return data["prediccion"];
  } else {
    throw Exception("Error al predecir voto");
  }
}
