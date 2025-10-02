import 'package:flutter/material.dart';
import 'package:flutter_application_votacion/domian/entities/debate.dart';
import 'package:flutter_application_votacion/domian/repositories/debate_repositorie.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

 final debateProvider =
    StateNotifierProvider<DebateNotifier, AsyncValue<List<Debate>>>(
  (ref) {
    final repository = ref.watch(debateRepositoryProvider);
    return DebateNotifier(repository);
  },
);

final debateRepositoryProvider = Provider<DebateRepository>(
  (ref) => throw UnimplementedError('Debes proveer un DebateRepository'),
);

class DebateNotifier extends StateNotifier<AsyncValue<List<Debate>>> {
  final DebateRepository repository;

  DebateNotifier(this.repository) : super(const AsyncValue.loading()) {
    cargarDebates();
  }

  Future<void> cargarDebates() async {
    state = const AsyncValue.loading();
    try {
      final debates = await repository.fetchDebates();
      state = AsyncValue.data(debates);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> crearDebateDesdeFormulario({
    required BuildContext context,
    required GlobalKey<FormState> formKey,
    required TextEditingController tituloController,
    required TextEditingController autorController,
    required TextEditingController descripcionController,
    String? imageUrl,
    String? categoria,  
  }) async {
    final formState = formKey.currentState;
    if (formState == null || !formState.validate()) return;

    final titulo = tituloController.text.trim();
    final autor = autorController.text.trim();
    final descripcion = descripcionController.text.trim();

    state = const AsyncValue.loading();
    try {
      final debate = Debate(
        title: titulo,
        author: autor,
        description: descripcion,
        createdAt: DateTime.now(),
        imageUrl: imageUrl,
        categoria: categoria,  
      );

      final newDebate = await repository.insertDebate(debate);

      await cargarDebates();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Debate creado con éxito')),
      );

      Navigator.pop(context, newDebate);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al crear el debate: $e')),
      );
    }
  }
}
