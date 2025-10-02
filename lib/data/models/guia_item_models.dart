class GuiaVotante {
  final int id;
  final String? tipo;
  final String? titulo;
  final String? descripcion;
  final String? icon;
  final String? colorHex;
  final int? orden;
  final int? eleccionId;
  final DateTime? createdAt;

  GuiaVotante({
    required this.id,
    this.tipo,
    this.titulo,
    this.descripcion,
    this.icon,
    this.colorHex,
    this.orden,
    this.eleccionId,
    this.createdAt,
  });

  factory GuiaVotante.fromMap(Map<String, dynamic> map) {
    return GuiaVotante(
      id: map['id'] is int ? map['id'] : int.parse(map['id'].toString()),
      tipo: map['tipo'],
      titulo: map['titulo'],
      descripcion: map['descripcion'],
      icon: map['icon'],
      colorHex: map['color_hex'],
      orden: map['orden'],
      eleccionId: map['eleccion_id'],
      createdAt:
          map['created_at'] != null ? DateTime.parse(map['created_at']) : null,
    );
  }
}
