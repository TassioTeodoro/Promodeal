class Comentario {
  final String? id;
  final String idUsuario;
  final String idPromocao;
  final String conteudo;
  final DateTime createdAt;

  Comentario({
    this.id,
    required this.idUsuario,
    required this.idPromocao,
    required this.conteudo,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory Comentario.fromMap(Map<String, dynamic> map) {
    return Comentario(
      id: map['id'] as String?,
      idUsuario: map['usuario_id'] as String,
      idPromocao: map['promocao_id'] as String,
      conteudo: map['texto'] as String,
      createdAt: DateTime.parse(map['data_comentario']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'usuario_id': idUsuario,
      'promocao_id': idPromocao,
      'texto': conteudo,
      'data_comentario': createdAt.toIso8601String(),
    };
  }
}
