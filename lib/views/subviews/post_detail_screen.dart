import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:promodeal/models/comentario_model.dart';
import 'package:promodeal/models/user_model.dart';
import 'package:promodeal/services/comentario_service.dart';
import 'package:promodeal/services/user_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/v4.dart';

class PostDetailScreen extends StatefulWidget {
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
  final int likes;

  const PostDetailScreen({
    super.key,
    required this.idPromocao,
    required this.loja,
    required this.data,
    required this.local,
    required this.descricao,
    required this.precoDe,
    required this.precoPor,
    required this.tags,
    this.fotoPerfilUrl,
    this.fotoDaPromo,
    this.likes = 0,
  });

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  final _comentarioService = ComentarioService();
  final _controller = TextEditingController();
  List<Map<String, dynamic>> _comentarios = [];
  bool _loading = true;
  bool _enviando = false;

  @override
  void initState() {
    super.initState();
    _carregarComentarios();
  }

  Future<void> _carregarComentarios() async {
    final comentarios =
        await _comentarioService.listarComentariosComUsuario(widget.idPromocao);
    setState(() {
      _comentarios = comentarios;
      _loading = false;
    });
  }
  Future<void> _enviarComentario() async {
    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Você precisa estar logado para comentar"),
        ),
      );
      return;
    }

    final conteudo = _controller.text.trim();
    if (conteudo.isEmpty) return;

    setState(() => _enviando = true);

    try {
      final comentario = Comentario(
        id: UuidV4().generate(),
        idUsuario: user.id,
        idPromocao: widget.idPromocao,
        conteudo: conteudo,
      );

      await _comentarioService.criarComentario(comentario);

      setState(() {
        _controller.clear(); // 🔹 limpa o campo
      });

      await _carregarComentarios(); // 🔹 recarrega lista após salvar
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Erro ao enviar comentário: $e")));
    } finally {
      setState(() => _enviando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Detalhes do Post")),
      body: Column(
        children: [
          // Foto da promoção em destaque
          if (widget.fotoDaPromo != null && widget.fotoDaPromo!.isNotEmpty)
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(12),
              ),
              child: Image.network(
                widget.fotoDaPromo!,
                fit: BoxFit.cover,
                width: double.infinity,
                height: 220,
              ),
            ),

          // Detalhes principais
          Card(
            margin: const EdgeInsets.all(12),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: widget.fotoPerfilUrl != null
                            ? NetworkImage(widget.fotoPerfilUrl!)
                            : null,
                        backgroundColor: Colors.grey[400],
                        child: widget.fotoPerfilUrl == null
                            ? const Icon(Icons.store, color: Colors.white)
                            : null,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.loja,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              widget.data,
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        widget.local,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(widget.descricao),
                  const SizedBox(height: 8),
                  Text(
                    "De: R\$${widget.precoDe.toStringAsFixed(2)}",
                    style: const TextStyle(
                      decoration: TextDecoration.lineThrough,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    "Por: R\$${widget.precoPor.toStringAsFixed(2)}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 8),
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
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            ),
          ),

          // Lista de comentários
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                        itemCount: _comentarios.length,
                        itemBuilder: (context, index) {
                          final c = _comentarios[index];
                          final user = c['usuarios'];
                          final nome = user?['nome'] ?? 'Usuário';
                          final foto = user?['pfp_url'];

                          return ListTile(
                            leading: CircleAvatar(
                              backgroundImage: foto != null
                                  ? NetworkImage(foto)
                                  : const AssetImage('assets/avatar_placeholder.png')
                                      as ImageProvider,
                              radius: 22,
                            ),
                            title: Text(
                              nome,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            subtitle: Text(
                              c['texto'] ?? '',
                              style: const TextStyle(fontSize: 13),
                            ),
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                          );
                        },
                      ),
          ),

          // Campo para enviar comentário
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    enabled: !_enviando,
                    decoration: const InputDecoration(
                      hintText: "Escreva um comentário...",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: _enviando
                      ? const CircularProgressIndicator()
                      : const Icon(Icons.send, color: Colors.green),
                  onPressed: _enviarComentario,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
