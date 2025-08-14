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
  final String imagemUrl;

  Promocao({
    required this.id,
    required this.titulo,
    required this.descricao,
    required this.preco,
    required this.desconto,
    required this.comercianteId,
    required this.dataCriacao,
    this.dataAgendamento,
    required this.imagemUrl,
  });

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
      'imagem_url': imagemUrl,
    };
  }
}
