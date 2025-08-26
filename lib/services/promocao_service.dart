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
    return (response as List).map((map) => Promocao.fromMap(map)).toList();
  }

  Future<List<Promocao>> listActive({String? query}) async {
    final now = DateTime.now().toIso8601String();

    var queryBuilder = SupabaseService.client
        .from(_table)
        .select()
        .gte('end_at', now) // só promoções com validade >= hoje
        .lte('start_at', now); // já iniciadas

    if (query != null && query.isNotEmpty) {
      queryBuilder = queryBuilder.ilike('title', '%$query%');
    }

    final response = await queryBuilder;
    return (response as List).map((map) => Promocao.fromMap(map)).toList();
  }

  Future<List<Promocao>> listarPromocoesPorMerchant(String merchantId) async {
    final response = await SupabaseService.client
        .from(_table)
        .select()
        .eq('merchant_id', merchantId);

    return (response as List).map((map) => Promocao.fromMap(map)).toList();
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
