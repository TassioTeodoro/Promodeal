// lib/services/comentario_service.dart
import 'package:promodeal/models/comentario_model.dart';
import 'package:promodeal/services/supabase_service.dart';

class ComentarioService {
  final _table = 'comentarios';

  Future<void> criarComentario(Comentario comentario) async {
    await SupabaseService.client.from(_table).insert(comentario.toMap());
  }

  Future<List<Comentario>> listarComentariosPorPromocao(String promocaoId) async {
    final response = await SupabaseService.client
        .from(_table)
        .select()
        .eq('promocao_id', promocaoId);

    return (response as List)
        .map((map) => Comentario.fromMap(map))
        .toList();
  }

  Future<void> deletarComentario(String id) async {
    await SupabaseService.client.from(_table).delete().eq('id', id);
  }
}
