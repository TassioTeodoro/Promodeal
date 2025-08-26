import 'dart:async';
import '../models/user_model.dart';

class AuthService {
  // TODO: integre com Supabase Auth
  Future<AppUser?> signIn(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 600));
    return AppUser(
      id: '1',
      nome: 'Usuário Demo',
      email: email,
      isComerciante: false,
    );
  }

  Future<AppUser?> signUp({
    required String name,
    required String email,
    required String password,
    bool isMerchant = false,
    String? cnpj,
    String? address,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));
    return AppUser(
      id: '2',
      nome: name,
      email: email,
      isComerciante: isMerchant,
      cnpj: cnpj,
      endereco: address,
    );
  }

  Future<void> signOut() async {
    await Future.delayed(const Duration(milliseconds: 300));
  }
}
