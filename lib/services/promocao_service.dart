import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/promocao_model.dart';

class PromocaoService {
  final supabase = Supabase.instance.client;

  Future<void> criarPromocao(Promocao promocao) async {
    await supabase.from('promocoes').insert(promocao.toMap());
  }

Future<List<Promocao>> listarPromocoes() async {
    final response = await supabase
        .from('promocoes')
        .select('*')
        .lte('data_publicacao', DateTime.now())
        .order('data_publicacao', ascending: false);

    final list = (response as List).map((map) {
      final data = map as Map<String, dynamic>;

      return Promocao.fromMap(data);
    }).toList();

    return list;
  }

  Future<List<Map<String, dynamic>>> listarPromocoesComUsuarios() async {
    final response = await supabase
        .from('promocoes')
        .select('*, usuarios (id, nome, endereco)')
        .lte('data_publicacao', DateTime.now());

    return (response as List).map((e) => e as Map<String, dynamic>).toList();
  }

  Future<void> atualizarPromocao(Promocao promocao) async {
    if (promocao.id == null) {
      throw Exception("ID da promoção não pode ser nulo");
    }
    await supabase
        .from('promocoes')
        .update(promocao.toMap())
        .eq('id', promocao.id!);
  }

  Future<void> deletarPromocao(String id) async {
    await supabase.from('promocoes').delete().eq('id', id);
  }

    /// Conta total de likes de uma promoção
  Future<int> contarLikes(String idPromocao) async {
    // .count() substitui FetchOptions; CountOption.exact é o comportamento padrão/mais preciso.
    final res = await supabase
        .from('likes')
        .select('id')
        .eq('id_promocao', idPromocao)
        .count(CountOption.exact);

    // res.count vem do PostgrestResponse quando você usa .count()
    return res.count ?? 0;
  }

  /// Verifica se o usuário já curtiu (retorna true/false)
  Future<bool> usuarioCurtiu(String idPromocao, String idUsuario) async {
    final response = await supabase
        .from('likes')
        .select('id')
        .eq('id_promocao', idPromocao)
        .eq('id_usuario', idUsuario)
        .maybeSingle();

    return response != null;
  }

  /// Insere like (unique constraint evita duplicatas)
  Future<void> darLike(String idPromocao, String idUsuario) async {
    await supabase.from('likes').insert({
      'id_promocao': idPromocao,
      'id_usuario': idUsuario,
    });
  }

  /// Remove like
  Future<void> removerLike(String idPromocao, String idUsuario) async {
    await supabase
        .from('likes')
        .delete()
        .eq('id_promocao', idPromocao)
        .eq('id_usuario', idUsuario);
  }

  Future<List<Promocao>> listarPromocoesPorUsuario(String idUsuario) async {
    final response = await supabase
        .from('promocoes')
        .select('*')
        .eq('id_usuario', idUsuario)
        .lte('data_publicacao', DateTime.now())
        .order('data_publicacao', ascending: false);

    return (response as List)
        .map((map) => Promocao.fromMap(map as Map<String, dynamic>))
        .toList();
  }

  Future<List<Map<String,dynamic>>> listarFeedPersonalizado() async {
    final idLogado = supabase.auth.currentUser?.id;
    if (idLogado == null) return [];

    // 🔹 Primeiro, busca IDs das pessoas que o usuário segue
    final seguidos = await supabase
        .from('seguidores')
        .select('seguido_id')
        .eq('seguidor_id', idLogado);

    final idsSeguidos =
        (seguidos as List).map((e) => e['seguido_id'] as String).toList();

    // 🔹 Se o usuário ainda não segue ninguém, retorna todos os posts
    final filtro = idsSeguidos.isNotEmpty ? 'in' : 'neq';
    final valor = idsSeguidos.isNotEmpty ? idsSeguidos : [idLogado];

    final response = await supabase
        .from('promocoes')
        .select('*, usuarios (id, nome, email, endereco, pfp_url)')
        .filter('id_usuario', filtro, valor)
        .lte('data_publicacao', DateTime.now())
        .order('data_publicacao', ascending: false);

    return response;
  }
}
