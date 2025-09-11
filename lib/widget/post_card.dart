import 'package:flutter/material.dart';
import 'package:promodeal/services/promocao_service.dart';
import 'package:promodeal/views/subviews/account_screen.dart';
import 'package:promodeal/views/subviews/post_detail_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PostCard extends StatefulWidget {
  final String idUsuario;
  final String idPromocao;
  final String loja;
  final String data;
  final String local;
  final String descricao;
  final double precoDe;
  final double precoPor;
  final List<String> tags;
  final String? fotoPerfilUrl;
  final String? fotoDaPromo;

  const PostCard({
    super.key,
    required this.idPromocao,
    required this.loja,
    required this.data,
    required this.local,
    required this.descricao,
    required this.precoDe,
    required this.precoPor,
    required this.tags,
    required this.idUsuario,
    this.fotoPerfilUrl,
    this.fotoDaPromo,
  });

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  final _promoService = PromocaoService();
  int _likes = 0;
  bool _curtiu = false;
  final user = Supabase.instance.client.auth.currentUser;

  @override
  void initState() {
    super.initState();
    _carregarLikes();
  }

  Future<void> _carregarLikes() async {
    if (user == null) return;

    final count = await _promoService.contarLikes(widget.idPromocao);
    final curtiu = await _promoService.usuarioCurtiu(
      widget.idPromocao,
      user!.id,
    );

    setState(() {
      _likes = count;
      _curtiu = curtiu;
    });
  }

  Future<void> _toggleLike() async {
    if (user == null) return;

    if (_curtiu) {
      await _promoService.removerLike(widget.idPromocao, user!.id);
    } else {
      await _promoService.darLike(widget.idPromocao, user!.id);
    }

    _carregarLikes(); // 🔹 recarrega likes e estado do botão
  }

  void _abrirComentarios() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PostDetailScreen(
          idPromocao: widget.idPromocao,
          loja: widget.loja,
          data: widget.data,
          local: widget.local,
          descricao: widget.descricao,
          precoDe: widget.precoDe,
          precoPor: widget.precoPor,
          tags: widget.tags,
          fotoPerfilUrl: widget.fotoPerfilUrl,
          fotoDaPromo: widget.fotoDaPromo,
          likes: _likes,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            ProfileScreen(idUsuario: widget.idUsuario),
                        // 🔹 aqui ajuste para usar o idUsuario da promoção em vez do idPromocao
                      ),
                    );
                  },
                  child: CircleAvatar(
                    backgroundColor: Colors.grey[400],
                    backgroundImage: widget.fotoPerfilUrl != null
                        ? NetworkImage(widget.fotoPerfilUrl!)
                        : null,
                    child: widget.fotoPerfilUrl == null
                        ? const Icon(Icons.store, color: Colors.white)
                        : null,
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            ProfileScreen(idUsuario: widget.idPromocao),
                      ),
                    );
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.loja,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        widget.data,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Text(widget.local, style: const TextStyle(color: Colors.grey)),
              ],
            ),

            // Descrição
            Text(widget.descricao),
            const SizedBox(height: 8),

            // 🔹 Foto da promoção (se existir)
            if (widget.fotoDaPromo != null && widget.fotoDaPromo!.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  widget.fotoDaPromo!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 180,
                ),
              ),
            if (widget.fotoDaPromo != null && widget.fotoDaPromo!.isNotEmpty)
              const SizedBox(height: 8),

            // Tags
            Wrap(
              spacing: 6,
              children: widget.tags
                  .map(
                    (t) => Chip(
                      label: Text(
                        t,
                        style: const TextStyle(color: Colors.white),
                      ),
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 8),

            // Preço
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 6,
                      horizontal: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      border: Border.all(color: Colors.green),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      "De: R\$${widget.precoDe.toStringAsFixed(2)}",
                      style: const TextStyle(
                        decoration: TextDecoration.lineThrough,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 6,
                      horizontal: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      border: Border.all(color: Colors.green, width: 2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      "Por: R\$${widget.precoPor.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Ações
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                InkWell(
                  onTap: _toggleLike,
                  child: Row(
                    children: [
                      Icon(
                        _curtiu
                            ? Icons.thumb_up_alt
                            : Icons.thumb_up_alt_outlined,
                        color: _curtiu ? Colors.green : Colors.black,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        "$_likes",
                        style: TextStyle(
                          color: _curtiu ? Colors.green : Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: _abrirComentarios,
                  child: Row(
                    children: const [
                      Icon(Icons.chat_bubble_outline),
                      SizedBox(width: 4),
                    ],
                  ),
                ),
                const Icon(Icons.share_outlined),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
