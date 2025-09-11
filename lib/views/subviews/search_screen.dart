import 'package:flutter/material.dart';
import 'package:promodeal/models/promocao_model.dart';
import 'package:promodeal/models/user_model.dart';
import 'package:promodeal/services/promocao_service.dart';
import 'package:promodeal/services/user_service.dart';
import 'package:promodeal/views/subviews/account_screen.dart';
import 'package:promodeal/widget/post_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();
  final _promocaoService = PromocaoService();
  final _userService = UserService();

  bool _loading = false;
  List<Promocao> _resultPosts = [];
  List<AppUser> _resultUsers = [];

  Future<void> _buscar() async {
    final query = _controller.text.trim();
    if (query.isEmpty) return;

    setState(() {
      _loading = true;
      _resultPosts.clear();
      _resultUsers.clear();
    });

    try {
      final termos = query.split(" ");

      String? filtroTag;
      String? filtroUsuario;
      List<String> termosLivres = [];

      for (var termo in termos) {
        if (termo.startsWith("tag:")) {
          filtroTag = termo.substring(4);
        } else if (termo.startsWith("user:")) {
          filtroUsuario = termo.substring(5);
        } else {
          termosLivres.add(termo);
        }
      }

      // 🔹 Buscar usuários
      if (filtroUsuario != null || termosLivres.isNotEmpty) {
        final users = await _userService.listarUsuarios();
        _resultUsers = users.where((u) {
          final nome = u.nome.toLowerCase();
          if (filtroUsuario != null && !nome.contains(filtroUsuario.toLowerCase())) {
            return false;
          }
          if (termosLivres.isNotEmpty &&
              !termosLivres.any((t) => nome.contains(t.toLowerCase()))) {
            return false;
          }
          return true;
        }).toList();
      }

      // 🔹 Buscar promoções
      final posts = await _promocaoService.listarTodasPromocoes();
      _resultPosts = posts.where((p) {
        bool match = true;

        if (filtroTag != null) {
          match &= p.tags.any((t) => t.toLowerCase() == filtroTag!.toLowerCase());
        }
        if (termosLivres.isNotEmpty) {
          final conteudo = "${p.descricao} ${p.tags.join(" ")}".toLowerCase();
          match &= termosLivres.any((t) => conteudo.contains(t.toLowerCase()));
        }
        return match;
      }).toList();
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // 🔹 Barra de pesquisa
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: "Insira um termo de busca",
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.all(12),
                    ),
                    onPressed: _buscar,
                    child: const Icon(Icons.search, color: Colors.white),
                  )
                ],
              ),
            ),

            if (_loading)
              const Expanded(
                child: Center(child: CircularProgressIndicator()),
              )
            else if (_resultPosts.isEmpty && _resultUsers.isEmpty)
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("O item não foi encontrado."),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                      onPressed: _buscar,
                      child: const Text("Tentar Novamente"),
                    ),
                  ],
                ),
              )
            else
              Expanded(
                child: ListView(
                  children: [
                    // 🔹 Usuários encontrados
                    if (_resultUsers.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Usuários", style: TextStyle(fontWeight: FontWeight.bold)),
                            ..._resultUsers.map((u) => ListTile(
                                  leading: CircleAvatar(
                                    backgroundImage: u.fotoPerfil != null ? NetworkImage(u.fotoPerfil!) : null,
                                    child: u.fotoPerfil == null
                                        ? const Icon(Icons.person)
                                        : null,
                                  ),
                                  title: Text(u.nome),
                                  subtitle: Text(u.email),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => ProfileScreen(idUsuario: u!.),
                                      ),
                                    );
                                  },
                                )),
                          ],
                        ),
                      ),

                    // 🔹 Posts encontrados
                    if (_resultPosts.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Promoções", style: TextStyle(fontWeight: FontWeight.bold)),
                            ..._resultPosts.map((p) => PostCard(
                                  idPromocao: p.id!,
                                  loja: "Loja", // poderia vir junto com join da tabela
                                  data: p.dataPublicacao?.toIso8601String() ?? "",
                                  local: "",
                                  descricao: p.descricao,
                                  precoDe: p.precoDe,
                                  precoPor: p.precoPor,
                                  tags: p.tags,
                                  idUsuario: p.idUsuario,
                                  fotoDaPromo: p.imagemUrl,
                                )),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
