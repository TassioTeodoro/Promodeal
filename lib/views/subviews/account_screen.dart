
import 'package:flutter/material.dart';
import 'package:promodeal/models/promocao_model.dart';
import 'package:promodeal/models/user_model.dart';
import 'package:promodeal/services/user_service.dart';
import 'package:promodeal/services/promocao_service.dart';
import 'package:promodeal/views/subviews/edit_profile_screen.dart';
import 'package:promodeal/widget/post_card.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileScreen extends StatefulWidget {
  final String idUsuario;

  const ProfileScreen({super.key, required this.idUsuario});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _userService = UserService();
  final _promocaoService = PromocaoService();

  AppUser? _usuario;
  List<Promocao> _posts = [];
  bool _loading = true;
  String? _idLogado;

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  Future<void> _carregarDados() async {
    final supabase = Supabase.instance.client;
    _idLogado = supabase.auth.currentUser?.id;

    final usuario = await _userService.buscarUsuarioPorId(widget.idUsuario);
    final posts = await _promocaoService.listarPromocoesPorUsuario(
      widget.idUsuario,
    );

    if (usuario != null) {
      setState(() {
        _usuario = usuario;
        _posts = posts;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final souLogado = widget.idUsuario == _idLogado;

    return Scaffold(
      appBar: AppBar(title: const Text("Conta"), backgroundColor: Colors.green, foregroundColor: Colors.white),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 🔹 Header verde igual design
            Container(
              width: double.infinity,
              color: Colors.green,
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.grey[300],
                    backgroundImage: null,
                    child: null,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _usuario!.nome,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          _usuario!.email,
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                  if (souLogado)
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.white),
                      onPressed: () async {
                        final atualizado = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ProfileEditScreen(usuario: _usuario!),
                          ),
                        );
                        if (atualizado) {
                          _carregarDados();
                        }
                      },
                    ),
                ],
              ),
            ),

            // 🔹 Bio, horários, endereço
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text(
                        "Bio",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(_usuario!.bio ?? "-", textAlign: TextAlign.justify),
                    ],
                  ),
                  const SizedBox(height: 12),

                  Row(
                    children: [
                      const Text(
                        "Endereço",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),

                  Row(children: [Text(_usuario!.endereco ?? "-")]),
                ],
              ),
            ),

            const Divider(),

            // 🔹 Lista de posts
            if (_posts.isEmpty)
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text("Nenhuma promoção publicada ainda."),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _posts.length,
                itemBuilder: (context, index) {
                  final post = _posts[index];
                  return PostCard(
                    idUsuario: _usuario!.id,
                    idPromocao: post.id!,
                    loja: _usuario!.nome,
                    data: post.dataPublicacao?.toIso8601String() ?? "",
                    local: _usuario!.endereco ?? "",
                    descricao: post.descricao,
                    precoDe: post.precoDe,
                    precoPor: post.precoPor,
                    tags: post.tags,
                    fotoDaPromo: post.imagemUrl,
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
