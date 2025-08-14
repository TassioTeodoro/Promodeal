// lib/services/user_service.dart
import 'package:promodeal/models/user_model.dart';
import 'package:promodeal/services/supabase_service.dart';

class UserService {
  final _table = 'usuarios';

  Future<void> criarUsuario(AppUser user) async {
    await SupabaseService.client.from(_table).insert(user.toMap());
  }

  Future<AppUser?> buscarUsuarioPorId(String id) async {
    final response = await SupabaseService.client
        .from(_table)
        .select()
        .eq('id', id)
        .maybeSingle();

    if (response != null) {
      return AppUser.fromMap(response);
    }
    return null;
  }

  Future<void> atualizarUsuario(AppUser user) async {
    await SupabaseService.client
        .from(_table)
        .update(user.toMap())
        .eq('id', user.id);
  }

  Future<void> deletarUsuario(String id) async {
    await SupabaseService.client.from(_table).delete().eq('id', id);
  }
}
