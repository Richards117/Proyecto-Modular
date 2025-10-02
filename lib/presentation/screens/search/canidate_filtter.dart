import 'package:flutter_application_votacion/data/models/candidate_models.dart';

class CandidatoFilter {
  static List<CandidatoModel> filterCandidates(
    List<CandidatoModel> candidatos,
    String selectedFilter,
    String entityQuery,
    String partyQuery,
    String nameQuery,
  ) {
    return candidatos.where((candidato) {
      bool matchesEntity = true;
      bool matchesParty = true;
      bool matchesName = true;

      // filtro Entidad y Partido
      if (selectedFilter == 'Entidad y Partido') {
        matchesEntity = entityQuery.isEmpty ||
            candidato.entidad.toLowerCase().contains(entityQuery.toLowerCase());
        matchesParty = partyQuery.isEmpty ||
            candidato.partido.toLowerCase().contains(partyQuery.toLowerCase());
      }

      // filtro Entidad
      if (selectedFilter == 'Entidad') {
        matchesEntity = entityQuery.isEmpty ||
            candidato.entidad.toLowerCase().contains(entityQuery.toLowerCase());
      }

      // filtro Partido
      if (selectedFilter == 'Partido') {
        matchesParty = partyQuery.isEmpty ||
            candidato.partido.toLowerCase().contains(partyQuery.toLowerCase());
      }

      // filtro Nombre
      if (selectedFilter == 'Nombre') {
        matchesName = nameQuery.isEmpty ||
            candidato.nombreCandidato.toLowerCase().contains(
                  nameQuery.toLowerCase(),
                );
      }

      return matchesEntity && matchesParty && matchesName;
    }).toList();
  }
}
