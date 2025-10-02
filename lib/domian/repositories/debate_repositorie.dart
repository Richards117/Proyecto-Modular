import 'dart:io';
import 'package:flutter_application_votacion/domian/entities/debate.dart';

abstract class DebateRepository {
  Future<Debate> insertDebate(Debate debate);
  Future<List<Debate>> fetchDebates();

  Future<String> uploadImage(File file);
}
