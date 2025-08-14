// lib/models/user_model.dart
class AppUser {
  final String id;
  final String nome;
  final String email;
  final bool isComerciante;
  final String? cnpj;
  final String? endereco;

  AppUser({
    required this.id,
    required this.nome,
    required this.email,
    required this.isComerciante,
    this.cnpj,
    this.endereco,
  });

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      id: map['id'] ?? '',
      nome: map['nome'] ?? '',
      email: map['email'] ?? '',
      isComerciante: map['is_comerciante'] ?? false,
      cnpj: map['cnpj'],
      endereco: map['endereco'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'email': email,
      'is_comerciante': isComerciante,
      'cnpj': cnpj,
      'endereco': endereco,
    };
  }
}
