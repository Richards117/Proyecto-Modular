class CandidatoModel {
  int? id;
  String nombreCandidato;
  String cargo;
  int edad;
  String sexo;
  String circunscripcion;
  String distritoFederal;
  String municipio;
  String entidad;
  String nivel;
  String tipoCandidato;
  String estatus;
  String escolaridad;
  String estatusEscolaridad;
  String direccionCasaCampana;
  String telefono;
  String correoElectronico;
  String paginaWeb;
  String partido;
  String tipoEleccion;

  List<PropuestaModel> propuestas;
  List<RedSocialModel> redesSociales;
  List<HistoriaProfesionalModel> historiaProfesional;
  List<TrayectoriaPoliticaModel> trayectoriaPolitica;
  List<CursoModel> cursos;

  CandidatoModel({
    this.id,
    required this.nombreCandidato,
    required this.cargo,
    required this.edad,
    required this.sexo,
    required this.circunscripcion,
    required this.distritoFederal,
    required this.municipio,
    required this.entidad,
    required this.nivel,
    required this.tipoCandidato,
    required this.estatus,
    required this.escolaridad,
    required this.estatusEscolaridad,
    required this.direccionCasaCampana,
    required this.telefono,
    required this.correoElectronico,
    required this.paginaWeb,
    required this.partido,
    required this.tipoEleccion,
    this.propuestas = const [],
    this.redesSociales = const [],
    this.historiaProfesional = const [],
    this.trayectoriaPolitica = const [],
    this.cursos = const [],
  });

  factory CandidatoModel.fromMap(Map<String, dynamic> json) {
    return CandidatoModel(
      id: json['id'] as int?,
      nombreCandidato: json['nombre'] ?? '',
      cargo: json['cargo'] ?? '',
      edad: (json['edad'] as int?) ?? 0,
      sexo: json['sexo'] ?? '',
      circunscripcion: json['circunscripcion'] ?? '',
      distritoFederal: json['distrito_federal'] ?? '',
      municipio: json['municipio'] ?? '',
      entidad: json['entidad'] ?? '',
      nivel: json['nivel'] ?? '',
      tipoCandidato: json['tipo_candidato'] ?? '',
      estatus: json['estatus'] ?? '',
      escolaridad: json['escolaridad'] ?? '',
      estatusEscolaridad: json['estatus_escolaridad'] ?? '',
      direccionCasaCampana: json['direccion_casa_campana'] ?? '',
      telefono: json['telefono'] ?? '',
      correoElectronico: json['correo_electronico'] ?? '',
      paginaWeb: json['pagina_web'] ?? '',
      partido: json['partidos'] != null ? json['partidos']['nombre'] ?? '' : '',
      tipoEleccion: json['tipos_eleccion'] != null
          ? json['tipos_eleccion']['nombre'] ?? ''
          : '',
      propuestas: (json['propuestas'] as List<dynamic>?)
              ?.map((e) => PropuestaModel.fromMap(e))
              .toList() ??
          [],
      redesSociales: (json['redes_sociales'] as List<dynamic>?)
              ?.map((e) => RedSocialModel.fromMap(e))
              .toList() ??
          [],
      historiaProfesional: (json['historia_profesional'] as List<dynamic>?)
              ?.map((e) => HistoriaProfesionalModel.fromMap(e))
              .toList() ??
          [],
      trayectoriaPolitica: (json['trayectoria_politica'] as List<dynamic>?)
              ?.map((e) => TrayectoriaPoliticaModel.fromMap(e))
              .toList() ??
          [],
      cursos: (json['cursos'] as List<dynamic>?)
              ?.map((e) => CursoModel.fromMap(e))
              .toList() ??
          [],
    );
  }
}

class PropuestaModel {
  int? id;
  String titulo;
  String descripcion;
  String categoria;

  PropuestaModel({
    this.id,
    required this.titulo,
    required this.descripcion,
    required this.categoria,
  });

  factory PropuestaModel.fromMap(Map<String, dynamic> json) {
    return PropuestaModel(
      id: json['id'] as int?,
      titulo: json['titulo'] ?? '',
      descripcion: json['descripcion'] ?? '',
      categoria: json['categoria'] ?? '',
    );
  }
}

class RedSocialModel {
  int? id;
  String tipo;
  String url;

  RedSocialModel({this.id, required this.tipo, required this.url});

  factory RedSocialModel.fromMap(Map<String, dynamic> json) {
    return RedSocialModel(
      id: json['id'] as int?,
      tipo: json['tipo'] ?? '',
      url: json['url'] ?? '',
    );
  }
}

class HistoriaProfesionalModel {
  int? id;
  String puesto;
  String institucion;
  String periodo;

  HistoriaProfesionalModel({
    this.id,
    required this.puesto,
    required this.institucion,
    required this.periodo,
  });

  factory HistoriaProfesionalModel.fromMap(Map<String, dynamic> json) {
    return HistoriaProfesionalModel(
      id: json['id'] as int?,
      puesto: json['puesto'] ?? '',
      institucion: json['institucion'] ?? '',
      periodo: json['periodo'] ?? '',
    );
  }
}

class TrayectoriaPoliticaModel {
  int? id;
  String cargo;
  String partido;
  String periodo;

  TrayectoriaPoliticaModel({
    this.id,
    required this.cargo,
    required this.partido,
    required this.periodo,
  });

  factory TrayectoriaPoliticaModel.fromMap(Map<String, dynamic> json) {
    return TrayectoriaPoliticaModel(
      id: json['id'] as int?,
      cargo: json['cargo'] ?? '',
      partido: json['partido'] ?? '',
      periodo: json['periodo'] ?? '',
    );
  }
}

class CursoModel {
  int? id;
  String nombre;
  String institucion;
  String? anio;

  CursoModel({
    this.id,
    required this.nombre,
    required this.institucion,
    this.anio,
  });

  factory CursoModel.fromMap(Map<String, dynamic> json) {
    return CursoModel(
      id: json['id'] as int?,
      nombre: json['nombre'] ?? '',
      institucion: json['institucion'] ?? '',
      anio: json['anio'] as String?,
    );
  }
}
