import 'package:flutter_application_votacion/data/models/debates_models/debate_models.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DebateRemoteDataSource {
  Future<DebateModel> insert(DebateModel debate) async {
    final response = await Supabase.instance.client
        .from('debates')
        .insert(debate.toJson())
        .select()
        .single();

    return DebateModel.fromJson(response);
  }

  Future<List<DebateModel>> fetchAll() async {
    final response = await Supabase.instance.client
        .from('debates')
        .select('*, comentarios(id)')
        .order('created_at', ascending: false);

    return (response as List)
        .map((json) => DebateModel.fromJson(json))
        .toList();
  }
}
