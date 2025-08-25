import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_model.dart';

class UserService {
  final supabase = Supabase.instance.client;

  Future<void> criarUsuario(AppUser user) async {
    await supabase.from('usuarios').insert(user.toMap());
  }

  Future<AppUser?> buscarUsuarioPorId(String id) async {
    final response = await supabase
        .from('usuarios')
        .select()
        .eq('id', id)
        .maybeSingle();

    if (response == null) return null;
    return AppUser.fromMap(response);
  }

  Future<List<AppUser>> listarUsuarios() async {
    final response = await supabase.from('usuarios').select();
    return (response as List).map((e) => AppUser.fromMap(e)).toList();
  }

  Future<void> deletarUsuario(String id) async {
    await supabase.from('usuarios').delete().eq('id', id);
  }

  /// 🔹 Novo método de atualização
  Future<void> atualizarUsuario(AppUser user) async {
    await supabase.from('usuarios').update(user.toMap()).eq('id', user.id);
  }
}
