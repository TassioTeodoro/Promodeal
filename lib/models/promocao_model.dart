class Promocao {
  final String? id;
  final String idUsuario;
  final String descricao;
  final double precoDe;
  final double precoPor;
  final List<String> tags;
  final DateTime? dataPublicacao;
  final String? imagemUrl;      // se quiser manter anexos adicionais
  final int likes;

  Promocao({
    this.id,
    required this.idUsuario,
    required this.descricao,
    required this.precoDe,
    required this.precoPor,
    required this.tags,
    this.dataPublicacao,
    this.imagemUrl,
    this.likes = 0,
  });

  factory Promocao.fromMap(Map<String, dynamic> map) {
    return Promocao(
      id: map['id'] as String?,
      idUsuario: map['id_usuario'] as String,
      descricao: map['descricao'] as String,
      precoDe: (map['preco_de'] as num).toDouble(),
      precoPor: (map['preco_por'] as num).toDouble(),
      tags: (map['tags'] as List<dynamic>).map((e) => e.toString()).toList(),
      dataPublicacao: map['data_publicacao'] != null
          ? DateTime.parse(map['data_publicacao'])
          : null,
      imagemUrl: map['imagem_url'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'id_usuario': idUsuario,
      'descricao': descricao,
      'preco_de': precoDe,
      'preco_por': precoPor,
      'tags': tags,
      'data_publicacao': dataPublicacao?.toIso8601String(),
      'imagem_url': imagemUrl,
    };
  }
}
