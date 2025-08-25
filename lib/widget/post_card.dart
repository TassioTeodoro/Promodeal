import 'package:flutter/material.dart';

class PostCard extends StatefulWidget {
  final String loja;
  final String data;
  final String local;
  final String descricao;
  final double precoDe;
  final double precoPor;
  final List<String> tags;
  final String? fotoPerfilUrl; // nova: foto do comerciante

  const PostCard({
    super.key,
    required this.loja,
    required this.data,
    required this.local,
    required this.descricao,
    required this.precoDe,
    required this.precoPor,
    required this.tags,
    this.fotoPerfilUrl,
  });

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool _curtiu = false;
  int _likes = 0;

  void _toggleLike() {
    setState(() {
      _curtiu = !_curtiu;
      _likes += _curtiu ? 1 : -1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header com foto + loja + botão seguir
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: widget.fotoPerfilUrl != null
                      ? NetworkImage(widget.fotoPerfilUrl!)
                      : null,
                  backgroundColor: Colors.grey[400],
                  child: widget.fotoPerfilUrl == null
                      ? const Icon(Icons.store, color: Colors.white)
                      : null,
                ),
                const SizedBox(width: 10),
                Expanded(
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
                        "${widget.data}  •  ${widget.local}",
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.green,
                    side: const BorderSide(color: Colors.green),
                  ),
                  child: const Text("+ Seguir"),
                ),
              ],
            ),

            const SizedBox(height: 8),
            Text(widget.descricao, style: const TextStyle(fontSize: 14)),
            const SizedBox(height: 8),

            // Tags
            Wrap(
              spacing: 6,
              children: widget.tags.map((t) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.shade600,
                    borderRadius: BorderRadius.circular(30), // pill shape
                  ),
                  child: Text(
                    t,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 8),

            // Placeholder imagem
            Container(
              height: 150,
              color: Colors.grey[300],
              alignment: Alignment.center,
              child: const Text("Imagem do Post"),
            ),
            const SizedBox(height: 8),

            // Preços
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      "De: R\$${widget.precoDe.toStringAsFixed(2)}",
                      style: const TextStyle(
                        color: Colors.white,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      "Por: R\$${widget.precoPor.toStringAsFixed(2)}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Ações (like, comentários, share)
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
                      Text("$_likes"),
                    ],
                  ),
                ),
                Row(
                  children: const [
                    Icon(Icons.chat_bubble_outline),
                    SizedBox(width: 4),
                    Text("0"),
                  ],
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
