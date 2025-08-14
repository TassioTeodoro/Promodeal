// lib/models/comentario_model.dart
class Comentario {
  final String id;
  final String promocaoId;
  final String usuarioId;
  final String texto;
  final DateTime dataComentario;

  Comentario({
    required this.id,
    required this.promocaoId,
    required this.usuarioId,
    required this.texto,
    required this.dataComentario,
  });

  factory Comentario.fromMap(Map<String, dynamic> map) {
    return Comentario(
      id: map['id'] ?? '',
      promocaoId: map['promocao_id'] ?? '',
      usuarioId: map['usuario_id'] ?? '',
      texto: map['texto'] ?? '',
      dataComentario: DateTime.parse(map['data_comentario']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'promocao_id': promocaoId,
      'usuario_id': usuarioId,
      'texto': texto,
      'data_comentario': dataComentario.toIso8601String(),
    };
  }
}
