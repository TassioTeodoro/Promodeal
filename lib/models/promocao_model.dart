// lib/models/promocao_model.dart
class Promocao {
  final String id;
  final String titulo;
  final String descricao;
  final double preco;
  final double desconto; // percentual
  final String comercianteId;
  final DateTime dataCriacao;
  final DateTime? dataAgendamento;
  final DateTime startAt;
  final DateTime endAt;
  final String imagemUrl;

  Promocao({
    required this.id,
    required this.titulo,
    required this.descricao,
    required this.preco,
    required this.desconto,
    required this.comercianteId,
    required this.dataCriacao,
    required this.startAt,
    required this.endAt,
    this.dataAgendamento,
    required this.imagemUrl,
  });

  double get finalPrice => preco * (1 - (desconto / 100));

  factory Promocao.fromMap(Map<String, dynamic> map) {
    return Promocao(
      id: map['id'] ?? '',
      titulo: map['titulo'] ?? '',
      descricao: map['descricao'] ?? '',
      preco: (map['preco'] ?? 0).toDouble(),
      desconto: (map['desconto'] ?? 0).toDouble(),
      comercianteId: map['comerciante_id'] ?? '',
      dataCriacao: DateTime.parse(map['data_criacao']),
      dataAgendamento: map['data_agendamento'] != null
          ? DateTime.parse(map['data_agendamento'])
          : null,
      startAt: DateTime.parse(map['start_at']),
      endAt: DateTime.parse(map['end_at']),
      imagemUrl: map['imagem_url'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titulo': titulo,
      'descricao': descricao,
      'preco': preco,
      'desconto': desconto,
      'comerciante_id': comercianteId,
      'data_criacao': dataCriacao.toIso8601String(),
      'data_agendamento': dataAgendamento?.toIso8601String(),
      'start_at': startAt.toIso8601String(),
      'end_at': endAt.toIso8601String(),
      'imagem_url': imagemUrl,
    };
  }
}
