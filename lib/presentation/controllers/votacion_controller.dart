import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_application_votacion/presentation/providers/votaciones/votacion_provider.dart';

class VotacionNotifier extends ChangeNotifier {
  final SupabaseService supabaseService;

  VotacionNotifier({required this.supabaseService});

   String? selectedGenero;
  String? selectedEntidadUsuario;
  String? selectedEntidadCandidato;
  String? selectedPartido;
  String? selectedCandidato;
  String? selectedCargo;

  String? selectedEdad;
  String? selectedEducacion;
  String? selectedOcupacion;
  String? selectedEstadoCivil;

  String? temaInteres;
  String? prioridadCandidato;

  String? frecuenciaVoto;
  String? fuenteInformacion;

   List<String> entidadesUsuario = [];
  List<String> entidadesCandidato = [];
  List<String> cargos = [];

   List<String> entidadesFiltradasPorCargo = [];
  List<String> partidosFiltrados = [];
  List<String> candidatosFiltrados = [];

   bool yaVotoPorCargo = false;
  bool loadingCandidatos = false;
  bool bloqueadoDatosPersonales = false;

   Future<void> loadInitialData() async {
    final entidades = await supabaseService.fetchEntidades();
    final cargosData = await supabaseService.fetchCargos();

    entidadesUsuario = entidades.where((e) => e != 'NACIONAL').toList();
    entidadesCandidato = entidades;
    cargos = cargosData;

    notifyListeners();
  }

   void setSelectedGenero(String? val) {
    if (bloqueadoDatosPersonales) return;
    selectedGenero = val;
    notifyListeners();
  }

  void setSelectedEntidadUsuario(String? val) {
    if (bloqueadoDatosPersonales) return;
    selectedEntidadUsuario = val;
    notifyListeners();
  }

  void setSelectedEdad(String? val) {
    if (bloqueadoDatosPersonales) return;
    selectedEdad = val;
    notifyListeners();
  }

  void setSelectedEducacion(String? val) {
    if (bloqueadoDatosPersonales) return;
    selectedEducacion = val;
    notifyListeners();
  }

  void setSelectedOcupacion(String? val) {
    if (bloqueadoDatosPersonales) return;
    selectedOcupacion = val;
    notifyListeners();
  }

  void setSelectedEstadoCivil(String? val) {
    if (bloqueadoDatosPersonales) return;
    selectedEstadoCivil = val;
    notifyListeners();
  }

  void setTemaInteres(String? val) {
    temaInteres = val;
    notifyListeners();
  }

  void setPrioridadCandidato(String? val) {
    prioridadCandidato = val;
    notifyListeners();
  }

  void setFrecuenciaVoto(String? val) {
    frecuenciaVoto = val;
    notifyListeners();
  }

  void setFuenteInformacion(String? val) {
    fuenteInformacion = val;
    notifyListeners();
  }

  Future<void> setSelectedCargo(String? val) async {
    selectedCargo = val;
    selectedEntidadCandidato = null;
    selectedPartido = null;
    selectedCandidato = null;
    partidosFiltrados = [];
    candidatosFiltrados = [];
    yaVotoPorCargo = false;

    if (val != null) {
      entidadesFiltradasPorCargo =
          await supabaseService.fetchEntidadesConCandidatos(val);
    } else {
      entidadesFiltradasPorCargo = [];
    }

    notifyListeners();
    await checkSiYaVotoPorCargo();
  }

  Future<void> setSelectedEntidadCandidato(String? val) async {
    selectedEntidadCandidato = val;
    selectedPartido = null;
    selectedCandidato = null;
    partidosFiltrados = [];
    candidatosFiltrados = [];

    if (val != null && selectedCargo != null) {
      await loadPartidosFiltrados();
    }

    notifyListeners();
  }

  Future<void> setSelectedPartido(String? val) async {
    selectedPartido = val;
    selectedCandidato = null;
    candidatosFiltrados = [];

    if (val != null &&
        selectedCargo != null &&
        selectedEntidadCandidato != null) {
      await loadCandidatos();
    }

    notifyListeners();
  }

  void setSelectedCandidato(String? val) {
    selectedCandidato = val;
    notifyListeners();
  }

   Future<void> loadPartidosFiltrados() async {
    if (selectedCargo == null || selectedEntidadCandidato == null) return;
    partidosFiltrados = await supabaseService.fetchPartidosFiltrados(
        entidad: selectedEntidadCandidato!, cargo: selectedCargo!);
    notifyListeners();
  }

  Future<void> loadCandidatos() async {
    if (selectedCargo == null ||
        selectedEntidadCandidato == null ||
        selectedPartido == null) return;

    loadingCandidatos = true;
    notifyListeners();

    candidatosFiltrados = await supabaseService.fetchCandidatos(
        entidad: selectedEntidadCandidato!,
        partido: selectedPartido!,
        cargo: selectedCargo!);

    selectedCandidato = null;
    loadingCandidatos = false;
    notifyListeners();
  }

   Future<void> checkSiYaVotoPorCargo() async {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId != null && selectedCargo != null) {
      yaVotoPorCargo =
          await supabaseService.usuarioYaVotoPorCargo(userId, selectedCargo!);
      notifyListeners();
    }
  }

   Future<void> guardarVoto({
    required String genero,
    required String entidadUser,
    required String entidadCandidatoParam,
    required String partido,
    required String cargo,
    required String candidato,
    String? edad,
    String? educacion,
    String? ocupacion,
    String? estadoCivil,
    String? temaInteres,
    String? prioridadCandidato,
    String? frecuenciaVoto,
    String? fuenteInformacion,
  }) async {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) throw Exception('Usuario no autenticado');

    await supabaseService.guardarVoto(
      userId: userId,
      genero: genero,
      entidadUser: entidadUser,
      entidadCandidato: entidadCandidatoParam,
      partido: partido,
      cargo: cargo,
      candidato: candidato,
      edad: edad,
      educacion: educacion,
      ocupacion: ocupacion,
      estadoCivil: estadoCivil,
      temaInteres: temaInteres,
      prioridadCandidato: prioridadCandidato,
      frecuenciaVoto: frecuenciaVoto,
      fuenteInformacion: fuenteInformacion,
    );
  }
}
