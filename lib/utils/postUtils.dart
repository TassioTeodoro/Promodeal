
class PostUtils {
  static String fromPostCard({
    required String loja,
    required String data,
    required String local,
    required String descricao,
    required double precoDe,
    required double precoPor,
    required List<String> tags,
    String? fotoDaPromo,
  }) {
    final buffer = StringBuffer();

    buffer.writeln("📢 Promoção da loja: $loja");
    buffer.writeln("📍 Local: $local");
    buffer.writeln("🗓️ Publicado em: $data");
    buffer.writeln("💬 Descrição: $descricao");

    if (precoDe > 0) {
      buffer.writeln("💲 De: R\$${precoDe.toStringAsFixed(2)}");
    }
    buffer.writeln("🔥 Por: R\$${precoPor.toStringAsFixed(2)}");

    if (tags.isNotEmpty) {
      buffer.writeln("🏷️ Tags: ${tags.join(', ')}");
    }

    return buffer.toString();
  }
}
