// lib/services/promocao_service.dart
import 'package:promodeal/models/promocao_model.dart';
import 'package:promodeal/services/supabase_service.dart';

class PromocaoService {
  final _table = 'promocoes';

  Future<void> criarPromocao(Promocao promocao) async {
    await SupabaseService.client.from(_table).insert(promocao.toMap());
  }

  Future<List<Promocao>> listarPromocoes() async {
    final response = await SupabaseService.client.from(_table).select();
    return (response as List)
        .map((map) => Promocao.fromMap(map))
        .toList();
  }

  Future<Promocao?> buscarPromocaoPorId(String id) async {
    final response = await SupabaseService.client
        .from(_table)
        .select()
        .eq('id', id)
        .maybeSingle();

    if (response != null) {
      return Promocao.fromMap(response);
    }
    return null;
  }

  Future<void> atualizarPromocao(Promocao promocao) async {
    await SupabaseService.client
        .from(_table)
        .update(promocao.toMap())
        .eq('id', promocao.id);
  }

  Future<void> deletarPromocao(String id) async {
    await SupabaseService.client.from(_table).delete().eq('id', id);
  }
}
