import 'package:flutter/material.dart';
import 'package:flutter_application_votacion/data/models/candidate_models.dart';

class CandidatoListProvider extends ChangeNotifier {
  final List<CandidatoModel> _candidatosOriginales;

  List<CandidatoModel> _candidatosFiltrados = [];
  List<CandidatoModel> _candidatosSeleccionados = [];

  String? _entidadSeleccionada;
  String? _partidoSeleccionado;

  CandidatoListProvider(this._candidatosOriginales) {
    _candidatosFiltrados = List.from(_candidatosOriginales);
  }

  List<CandidatoModel> get candidatosFiltrados => _candidatosFiltrados;
  List<CandidatoModel> get candidatosSeleccionados => _candidatosSeleccionados;

  List<String> get entidades =>
      _candidatosOriginales.map((c) => c.entidad).toSet().toList()..sort();
  List<String> get partidos =>
      _candidatosOriginales.map((c) => c.partido).toSet().toList()..sort();

  void seleccionarEntidad(String? entidad) {
    _entidadSeleccionada = entidad;
    _filtrar();
  }

  void seleccionarPartido(String? partido) {
    _partidoSeleccionado = partido;
    _filtrar();
  }

  void limpiarFiltros() {
    _entidadSeleccionada = null;
    _partidoSeleccionado = null;
    _candidatosFiltrados = List.from(_candidatosOriginales);
    notifyListeners();
  }

  void toggleSeleccion(CandidatoModel candidato, bool seleccionado) {
    seleccionado
        ? _candidatosSeleccionados.add(candidato)
        : _candidatosSeleccionados.remove(candidato);
    notifyListeners();
  }

  void _filtrar() {
    _candidatosFiltrados = _candidatosOriginales.where((c) {
      final coincideEntidad =
          _entidadSeleccionada == null || c.entidad == _entidadSeleccionada;
      final coincidePartido =
          _partidoSeleccionado == null || c.partido == _partidoSeleccionado;
      return coincideEntidad && coincidePartido;
    }).toList();
    notifyListeners();
  }
}
