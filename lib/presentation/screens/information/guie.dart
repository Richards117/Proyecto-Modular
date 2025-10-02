import 'package:flutter/material.dart';
import 'package:flutter_application_votacion/data/models/guia_item_models.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<List<GuiaVotante>> obtenerGuiaVotantes() async {
  final supabase = Supabase.instance.client;

  try {
    final data = await supabase
        .from('guia_votante')
        .select()
        .order('orden', ascending: true);

    final List<Map<String, dynamic>> guiaData =
        List<Map<String, dynamic>>.from(data);
    return guiaData.map((item) => GuiaVotante.fromMap(item)).toList();
  } catch (e) {
    print('Error al cargar guías votantes: $e');
    return [];
  }
}

class GuiasScreen extends StatelessWidget {
  const GuiasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.info_outline, color: Colors.white),
            SizedBox(width: 8),
            Text('Guia Votante', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        backgroundColor: Colors.blueAccent.shade200,
        elevation: 0,
      ),
      body: FutureBuilder<List<GuiaVotante>>(
        future: obtenerGuiaVotantes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay guías votantes.'));
          }

          final guiaVotantes = snapshot.data!;

          return ListView.builder(
            itemCount: guiaVotantes.length,
            itemBuilder: (context, index) {
              final guia = guiaVotantes[index];

              final Color bgColor = guia.tipo == 'cargo'
                  ? Color(int.parse(guia.colorHex!.substring(1, 7), radix: 16) +
                      0xFF000000)
                  : guia.tipo == 'paso'
                      ? Colors.pinkAccent.shade100
                      : Colors.grey.shade100;

              final Color textColor = bgColor.computeLuminance() > 0.5
                  ? Colors.black
                  : Colors.white;

              final iconMap = {
                'flag': Icons.flag,
                'gavel': Icons.gavel,
                'account_balance': Icons.account_balance,
                'location_city': Icons.location_city,
                'credit_card': Icons.credit_card,
                'assignment': Icons.assignment,
                'edit': Icons.edit,
                'how_to_vote': Icons.how_to_vote,
                'fingerprint': Icons.fingerprint,
              };

              final icon = iconMap[guia.icon] ?? Icons.info;

              // Título de sección
              String sectionTitle = "";
              if (guia.tipo == 'cargo') {
                sectionTitle = "Cargos a elegir";
              } else if (guia.tipo == 'paso') {
                sectionTitle = "Pasos para votar";
              }
              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (sectionTitle.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          sectionTitle,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.teal,
                          ),
                        ),
                      ),
                    Card(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      color: bgColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: Colors.grey.shade300, width: 1),
                      ),
                      elevation: 8,
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        title: Text(
                          guia.titulo ?? 'Sin título',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: textColor,
                          ),
                        ),
                        subtitle: Text(
                          guia.descripcion ?? 'Sin descripción',
                          style: TextStyle(
                            fontSize: 16,
                            color: textColor,
                          ),
                        ),
                        leading: CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Icon(icon, color: Colors.teal),
                        ),
                        onTap: () {},
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class Plomo extends StatelessWidget {
  const Plomo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
